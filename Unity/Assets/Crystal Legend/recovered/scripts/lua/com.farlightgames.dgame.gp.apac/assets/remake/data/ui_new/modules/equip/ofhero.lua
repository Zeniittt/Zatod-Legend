local base = ed.ui.popwindow
local chooseheroWin = {}
chooseheroWin.__index = chooseheroWin
setmetatable(chooseheroWin, base.mt)
ed.ui.chooseheroWin = chooseheroWin
local dx, dy = 78, 100
local colNum = 5

function chooseheroWin.create(param)
  local self = base.create("chooseheroWin")
  setmetatable(self, chooseheroWin)
  self:initData(param)
  self:initUI()
  self:registerTouchHandlers()
  self.refreshCliprectConfig = {
    draglist = self.draglist
  }
  self:show()
  return self
end

function chooseheroWin:initData(param)
  self.param = param
  self.heroIDArray = {}
  self.item_len = 70
  self.item_offset_x = 0
  self.item_offset_y = 8
  self.colume_count = 5
  self.additionalOffsetY = 0
  self.extra_item_y = 0
  self.left_top_x = 30
  self.left_top_y = 288
  self.heroes = {}
  self.clid = "all"
end

function chooseheroWin:doPressInList()
  local function handler(x, y)
    for k, v in pairs(self.uiList) do
      local icon = v.icon
      
      if ed.containsPoint(icon, x, y) then
        return v
      end
    end
    return nil
  end
  
  return handler
end

function chooseheroWin:doClickInList()
  local function handler(x, y, v)
    if not v then
      return
    end
    local icon = v.icon
    if ed.containsPoint(icon, x, y) then
    end
  end
  
  return handler
end

function chooseheroWin:cancelPressInList()
  local function handler(x, y, v)
    if not v then
      return
    end
  end
  
  return handler
end

function chooseheroWin:createDraglist()
  self.draglist = ed.UITool.createDraglist(self.ui.Panel_6501, {
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList()
  })
end

function chooseheroWin:initUI()
  local container = self.container
  local ui = {}
  self.ui = ui
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ed.uieditor.chooseheroWin)
  self.selectedCild = self.ui.tag_selected1
  self.selectedCild:setVisible(true)
  local collect_wid = self.ui.label_tag5:getContentSize().width
  if 45 < collect_wid then
    self.ui.label_tag5:setScale(45 / collect_wid)
  end
  self:createDraglist()
  self:refreshHeroList()
  self:refreshUI()
end

local function getItemPos(i)
  local ox, oy = 50, 260
  local x, y = 0, 0
  local row = math.floor((i - 1) / colNum)
  local col = i - row * colNum - 1
  x = ox + dx * col
  y = oy - dy * row
  return ccp(x, y)
end

function chooseheroWin:refreshDraglist()
  self.uiList = {}
  for k, item in ipairs(self.heroIDArray) do
    local container, ui = self:getItem(item)
    ui.id = item.id
    self.draglist:addItem(container)
    table.insert(self.uiList, ui)
    ui.container:setPosition(getItemPos(k))
  end
  local rowNum = math.floor((#self.heroIDArray + 8) / colNum)
  self.draglist:initListHeight(rowNum * dy)
end

function chooseheroWin:getItem(item)
  local container = CCNode:create()
  local ui = {}
  ui.container = container
  return container, ui
end

function chooseheroWin:refreshUI()
end

function chooseheroWin:refreshSubBtn(clid, btn)
  self.clid = clid
  self.selectedCild:setVisible(false)
  self.selectedCild = self.ui[btn]
  self.selectedCild:setVisible(true)
end

function chooseheroWin:doPressInList()
  local function handler(x, y)
    local list = self.heroes
    
    for k, v in pairs(list or {}) do
      if ed.containsPoint(v.icon, x, y) then
        v.icon:setScale(0.95)
        return k
      end
    end
  end
  
  return handler
end

function chooseheroWin:cancelPressInList()
  local function handler(x, y, id)
    self.heroes[id].icon:setScale(1)
  end
  
  return handler
end

function chooseheroWin:doClickInList()
  local function handler(x, y, id)
    local icon = self.heroes[id].icon
    
    icon:setScale(1)
    local signName = self.param.signName
    local tb = {
      "rewardPromote",
      "rewardAwaken",
      "rewardEmploy",
      "taskPromote",
      "taskEnhance",
      "taskEmploy",
      "incubus",
      "tarot"
    }
    if ed.containsPoint(icon, x, y) then
      if not ed.player.heroes[id] and not ed.isElementInTable(signName, tb) then
        ed.showToast(T("\228\189\160\229\176\154\230\156\170\230\139\165\230\156\137\232\175\165\232\139\177\233\155\132"))
        return
      end
      if self.param.withState then
        local state = ed.player.heroes[id]._state
        if state == "hire" then
          ed.showToast(T("\232\175\165\232\139\177\233\155\132\229\183\178\230\180\190\229\135\186\229\174\136\232\144\165"))
          return
        end
      end
      if self.param.callback then
        local bClose = self.param.callback(id)
        if bClose then
          return
        end
      end
      self:destroy({
        skipAnim = true,
        callback = self.param.destroyCallback
      })
    end
  end
  
  return handler
end

function chooseheroWin:cancelClickInList()
  local function handler(x, y, id)
    self.heroes[id].icon:setScale(1)
  end
  
  return handler
end

function chooseheroWin:getMaxEquipState(hid)
  local hero = ed.player.heroes[hid]
  if not hero then
    return nil
  end
  for i = 1, 6 do
    local id = hero._items[i]._item_id or 0
    if 0 < id then
      local l, e, ml, me = ed.readequip.getEquipLevel(hid, i)
      if l ~= ml or e ~= me then
        return nil
      end
    end
  end
  return "maxequip"
end

local function calculateNum(hero)
  local va = 0
  local tempHero = ed.player.heroes[hero._tid]
  if tempHero then
    va = (tempHero._state == "idle" and 1000000 or 0) + tempHero._gs
  else
    va = hero._tid
  end
  return va
end

local function sortHeroListGuild(list)
  table.sort(list, function(heroA, heroB)
    return calculateNum(heroA) > calculateNum(heroB)
  end)
end

local function sortHeroListEquip(self, list)
  table.sort(list, function(a, b)
    local a_state = self:getMaxEquipState(a._tid) and 1 or 0
    local b_state = self:getMaxEquipState(b._tid) and 1 or 0
    return a_state < b_state
  end)
end

local function sortHeroListTarot(list)
  table.sort(list, function(a, b)
    local a_state = ed.TarotModel:isHeroRed(a._tid) and 1 or 0
    local b_state = ed.TarotModel:isHeroRed(b._tid) and 1 or 0
    if a_state ~= b_state then
      return a_state > b_state
    else
      local newIndexA = ed.TarotModel:getCardNewIndex(a._tid)
      local newIndexB = ed.TarotModel:getCardNewIndex(b._tid)
      if newIndexA ~= newIndexB then
        return newIndexA > newIndexB
      end
    end
    return a._tid < b._tid
  end)
end

local function sortHeroList(self, list)
  local list = list or {}
  if self.param.signName == "equip" then
    sortHeroListEquip(self, list)
  end
  if self.param.signName == "guild_mercenary" then
    sortHeroListGuild(list)
  end
  if self.param.signName == "tarot" then
    sortHeroListTarot(list)
  end
end

function chooseheroWin:getList()
  if not self.all then
    local list = {}
    local heroAddition = {}
    local heroList = self.param.heroList
    if heroList then
      if type(heroList[1]) == "table" then
        for i, v in ipairs(heroList) do
          table.insert(list, v.id)
          heroAddition[v.id] = v
        end
      else
        list = self.param.heroList
      end
    else
      local hl = ed.orderHeroes() or {}
      for i, v in ipairs(hl) do
        table.insert(list, v._tid)
      end
    end
    local clist = {}
    for i, v in pairs(list) do
      if not ed.isElementInTable(v, self.param.noShowList) then
        local idx = #clist + 1
        clist[idx] = {}
        clist[idx]._tid = v
      end
    end
    self.all, self.front, self.middle, self.back = ed.readhero.classify("ofhero", "position", {}, clist)
    self.collect = {}
    self.collectList = ed.player:getCollectList()
    for k, v in ipairs(self.collectList or {}) do
      table.insert(self.collect, ed.player.heroes[v])
    end
    sortHeroList(self, self.all)
    sortHeroList(self, self.front)
    sortHeroList(self, self.middle)
    sortHeroList(self, self.back)
    self.heroAddition = heroAddition
    ed.allSortTarot = self.all
  end
  return self[self.clid]
end

function chooseheroWin:getHeroIconPos(i)
  local ox, oy = self.left_top_x + self.item_len / 2, self.left_top_y - self.item_len / 2
  local en = self.ui.explain
  if not tolua.isnull(en) then
    oy = oy - en:getContentSize().height - self.explain_offset_y
  end
  local x = ox + (self.item_len + 20 + self.item_offset_x) * ((i - 1) % self.colume_count)
  local y = oy - (self.item_len + 10 + self.item_offset_y + self.extra_item_y) * math.floor((i - 1) / self.colume_count)
  return ccp(x, y - self.additionalOffsetY)
end

function chooseheroWin:getListHeight()
  local list = self:getList()
  local newLength = #list
  if self.param.hasQ then
    newLength = newLength + 1
  end
  local h = (self.item_len + 10 + self.item_offset_y + self.extra_item_y) * math.ceil(newLength / self.colume_count) + 20
  local en = self.ui.explain
  if not tolua.isnull(en) then
    h = h + en:getContentSize().height
    h = h + self.explain_offset_y
  end
  h = h + self.additionalOffsetY
  return h
end

function chooseheroWin:getTemplateStar(tid)
  local promoteList = self.param.promoteList
  local tempStar = 0
  if promoteList and promoteList[tid] then
    tempStar = promoteList[tid]
  end
  return tempStar
end

function chooseheroWin:getTemplateAwaken(tid)
  local awakeList = self.param.awakeList
  local tempAwake = false
  if awakeList and awakeList[tid] then
    tempAwake = true
  end
  return tempAwake
end

function chooseheroWin:getTemplateSAwaken(tid)
  local awakeList = self.param.sawakeList
  local tempSAwake = false
  if awakeList and awakeList[tid] then
    tempSAwake = true
  end
  return tempSAwake
end

function chooseheroWin:getTemplateEmploy(tid)
  local employList = self.param.employList
  local tempEmploy = false
  if employList and employList[tid] then
    tempEmploy = true
  end
  return tempEmploy
end

function chooseheroWin:getMaxEquipState(hid)
  local hero = ed.player.heroes[hid]
  if not hero then
    return nil
  end
  for i = 1, 6 do
    local id = hero._items[i]._item_id or 0
    if 0 < id then
      local l, e, ml, me = ed.readequip.getEquipLevel(hid, i)
      if l ~= ml or e ~= me then
        return nil
      end
    end
  end
  return "maxequip"
end

function chooseheroWin:getAwakenState(hid)
  local tempSAwake = self:getTemplateSAwaken(hid)
  if tempSAwake then
    return "superawake"
  end
  local tempAwake = self:getTemplateAwaken(hid)
  if tempAwake then
    return "awaken"
  end
end

function chooseheroWin:getEmployState(hid)
  local employList = self.param.employList
  local tempEmploy = false
  if employList and employList[hid] then
    tempEmploy = true
  end
  if tempEmploy then
    return "employ"
  end
end

function chooseheroWin:getMultiPlayerState(hid)
  if self.param.dispatchList then
    local list = self.param.dispatchList
    for _, id in pairs(list) do
      if id == hid then
        return "dispatch"
      end
    end
  end
  if self.param.disableList then
    local list = self.param.disableList
    for _, id in pairs(list) do
      if id == hid then
        return "disable"
      end
    end
  end
end

function chooseheroWin:getTarotState(hid)
  if ed.TarotModel:isHeroRed(hid) then
    return "redTag"
  end
end

function chooseheroWin:getStateInCreateHero(tid)
  local signName = self.param.signName
  local state
  if signName == "equip" then
    state = self:getMaxEquipState(tid)
  elseif signName == "rewardAwaken" or signName == "taskEnhance" then
    state = self:getAwakenState(tid)
  elseif signName == "rewardEmploy" or signName == "taskEmploy" then
    state = self:getEmployState(tid)
  elseif signName == "tarot" then
    state = self:getTarotState(tid)
  end
  if state == nil then
    return not self.param.withState and "idle" or nil
  end
  return state
end

function chooseheroWin:getAwakeInCreateHero(tid)
  local signName = self.param.signName
  local awake = true
  local tb = {
    "rewardPromote",
    "rewardAwaken",
    "rewardEmploy",
    "taskPromote",
    "taskEnhance"
  }
  if signName == "taskEmploy" and not ed.canAwake(tid) then
    awake = false
  elseif ed.isElementInTable(signName, tb) then
    awake = self:getTemplateAwaken(tid)
  end
  return awake
end

function chooseheroWin:getStarsInCreateHero(tid)
  local stars = 0
  local type_name = self.param.signName
  if type_name == "rewardPromote" then
    local hero = ed.realarena.hero_mgr:getHeroByIDWithEmploy(tid)
    if hero then
      stars = hero._stars
    end
  elseif type_name == "taskPromote" or type_name == "taskEnhance" then
    local hero = ed.multiarena.heroMgr:GetHeroByIDWithEmploy(tid)
    if hero then
      stars = hero._stars
    end
  elseif type_name == "rewardEmploy" then
    stars = ed.getDataTable("Unit")[tid]["Initial Stars"]
  elseif type_name == "taskEmploy" then
    stars = ed.parameter.hero_max_star
  end
  return stars
end

function chooseheroWin:getRanksInCreateHero(tid)
  local signName = self.param.signName
  local ranks = 0
  if signName == "rewardPromote" or signName == "rewardAwaken" or signName == "rewardEmploy" then
    ranks = ed.realarena.hero_mgr:getRealarenaMaxHeroRank()
  end
  if signName == "taskPromote" or signName == "taskEnhance" or signName == "taskEmploy" then
    ranks = ed.multiarena.heroMgr:GetRanksWithHeroId(tid)
  end
  if signName == "incubus" then
    ranks = ed.incubus.DataResource:getBossRank(tid)
  end
  return ranks
end

function chooseheroWin:getShadeInCreateHero(tid)
  local signName = self.param.signName
  local shade = false
  if signName == "rewardPromote" then
    local tempStar = self:getTemplateStar(tid)
    local hero = ed.realarena.hero_mgr:getHeroByIDWithEmploy(tid)
    if hero and tempStar then
      shade = hero._stars + tempStar >= 5
    end
  elseif signName == "taskPromote" then
    local tempStar = self:getTemplateStar(tid)
    local hero = ed.multiarena.heroMgr:GetHeroByIDWithEmploy(tid)
    if hero and tempStar then
      shade = hero._stars + tempStar >= 5
    end
  elseif signName == "rewardAwaken" or signName == "taskEnhance" then
    shade = self:getTemplateAwaken(tid)
  elseif signName == "rewardEmploy" or signName == "taskEmploy" then
    shade = self:getTemplateEmploy(tid)
  end
  return shade
end

function chooseheroWin:getSummary(tid)
  local type_name = self.param.signName
  local summary
  if type_name == "rewardPromote" then
    local hero = ed.realarena.hero_mgr:getHeroByIDWithEmploy(tid)
    if hero then
      summary = hero
    end
  elseif type_name == "taskPromote" or type_name == "taskEnhance" then
    local hero = ed.multiarena.heroMgr:GetHeroByIDWithEmploy(tid)
    if hero then
      summary = hero
    end
  end
  return summary
end

function chooseheroWin:createHero(index)
  local signName = self.param.signName
  local list = self:getList()
  local tid = list[index]._tid
  local ranks = self:getRanksInCreateHero(tid)
  local stars = self:getStarsInCreateHero(tid)
  local state = self:getStateInCreateHero(tid)
  local shade = self:getShadeInCreateHero(tid)
  local tempStar = self:getTemplateStar(tid)
  local summary = self:getSummary(tid)
  self.heroes[tid] = ed.readhero.createIconByID(tid, {
    state = state,
    isShowLegendEquip = ed.openLegendEquip()
  })
  local icon = self.heroes[tid].icon
  self.heroes[tid]:showLegendEquip(not ed.openLegendEquip())
  local pos
  if self.param.hasQ then
    pos = self:getHeroIconPos(index + 1)
    if index == 1 then
      local node = CCSprite:create()
      node:setContentSize(ed.DGSizeMake(104, 104))
      local qm = ed.createSprite("UI/alpha/1080P/common/handbook_icon_lock.png")
      qm:setPosition(ed.getCenterPos(node))
      node:addChild(qm)
      local qm = ed.createSprite("UI/alpha/HVGA/hero_icon_frame_1.png")
      qm:setPosition(ed.getCenterPos(node))
      node:addChild(qm)
      local tempIcon = {
        info = {id = 0},
        icon = node
      }
      self.heroes[0] = tempIcon
      local poss = self:getHeroIconPos(1)
      tempIcon.icon:setPosition(poss)
      self.draglist:addItem(tempIcon.icon)
    end
  else
    pos = self:getHeroIconPos(index)
  end
  icon:setPosition(pos)
  self.draglist:addItem(icon)
  if ed.readequip.canHeroItemsEnhance(tid) then
    self.EEselectHeroid = tid
  end
end

function chooseheroWin:asyncLoadHero()
  local index = 1
  
  local function handler()
    local list = self:getList()
    for i = math.max(1, 5 * (index - 1)), math.min(#list, 5 * index) do
      self:createHero(i)
    end
    if 5 * index > #list then
      self:getScene():removeUpdateHandler("asyncLoadHero")
    end
    index = index + 1
  end
  
  return handler
end

function chooseheroWin:createHeroList()
  local dl = self.draglist
  dl.doPressIn = self:doPressInList()
  dl.cancelPressIn = self:cancelPressInList()
  dl.doClickIn = self:doClickInList()
  dl.cancelClickIn = self:cancelClickInList()
  self:getScene():registerUpdateHandler("asyncLoadHero", self:asyncLoadHero())
  self.draglist:initListHeight(self:getListHeight())
end

function chooseheroWin:refreshHeroList()
  self.draglist:clearList()
  self.heroes = {}
  self:createHeroList()
end

function chooseheroWin:registerTouchHandlers()
  self:btRegisterOutClick({
    area = self.ui.bg,
    key = "clickOut",
    clickHandler = function()
      self:destroy()
    end,
    force = true
  })
  ed.UITool.registerBtn(self, "tag1", function()
    if self.clid ~= "all" then
      self:refreshSubBtn("all", "tag_selected1")
      self:refreshHeroList()
    end
  end, {})
  ed.UITool.registerBtn(self, "tag2", function()
    if self.clid ~= "front" then
      self:refreshSubBtn("front", "tag_selected2")
      self:refreshHeroList()
    end
  end, {})
  ed.UITool.registerBtn(self, "tag3", function()
    if self.clid ~= "middle" then
      self:refreshSubBtn("middle", "tag_selected3")
      self:refreshHeroList()
    end
  end, {})
  ed.UITool.registerBtn(self, "tag4", function()
    if self.clid ~= "back" then
      self:refreshSubBtn("back", "tag_selected4")
      self:refreshHeroList()
    end
  end, {})
  ed.UITool.registerBtn(self, "tag5", function()
    if self.clid ~= "collect" then
      self:refreshSubBtn("collect", "tag_selected5")
      self:refreshHeroList()
    end
  end, {})
end

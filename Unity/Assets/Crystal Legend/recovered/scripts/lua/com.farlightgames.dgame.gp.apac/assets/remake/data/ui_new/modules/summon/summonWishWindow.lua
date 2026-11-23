local base = ed.ui.popwindow
local SummonWishWindow = newclass(base.mt)
ed.ui.summonWishWindow = SummonWishWindow

function SummonWishWindow.create(...)
  local self = base.create("SummonWishWindow")
  setmetatable(self, SummonWishWindow.mt)
  SummonWishWindow.eventScope = {}
  self:init(...)
  return self
end

function SummonWishWindow:init()
  self:initData()
  self:initView()
  self:addEventListener()
end

function SummonWishWindow:initData()
  local allHeroList = ed.summonMgr:getAllWishingHeros()
  self.tabHeroList = {}
  
  local function pushToTabTable(name, id)
    if not self.tabHeroList[name] then
      self.tabHeroList[name] = {}
    end
    table.insert(self.tabHeroList[name], id)
  end
  
  for i, id in ipairs(allHeroList) do
    pushToTabTable("ALL", id)
    pushToTabTable(ed.lookupDataTable("Unit", "Main Attrib", id), id)
  end
  for k, v in pairs(self.tabHeroList) do
    table.sort(v, function(a, b)
      local as = ed.readhero.checkHeroMaxStar(a) and 1 or 0
      local bs = ed.readhero.checkHeroMaxStar(b) and 1 or 0
      return as < bs
    end)
  end
  self.heroList = {}
  self.wishingHeroList = nil
  self:resetWishingHeroList()
  self.wishItems = {}
end

function SummonWishWindow:initView()
  local container, ui = ed.editorui(ed.uieditor.summonWishWindow)
  self.ui = ui
  self.container:addChild(container)
  self:setBackButton()
  self:initTips()
  self:initFontStyle()
  self:initHerosList()
  self:switchTab(1)
  self:updateWishList()
end

function SummonWishWindow:initFontStyle()
  local strokecolor = ccc3(39, 37, 36)
  local fontcolor = ccc3(255, 230, 154)
  ed.setLabelColor(self.ui.btn_save_label, fontcolor)
  fontcolor = ccc3(255, 252, 231)
  ed.setLabelColor(self.ui.text_title, fontcolor)
  ed.setLabelStroke(self.ui.text_title, strokecolor, 1)
  ed.setLabelStroke(self.ui.label_img, ed.toccc3(12808510), 1)
  for i = 1, 4 do
    local label = self.ui["btn_text_" .. i]
    ed.setLabelStroke(label, strokecolor, 2)
    ed.setLabelColor(label, fontcolor)
  end
  if ed.isAreaOverSea() then
    self.ui.title_bg:setVisible(false)
    self.ui.title_bg_global:setVisible(true)
    ed.setLabelStroke(self.ui.Label_54, ed.toccc3(11818272), 1)
    self.ui.Label_54:limitWidthByScale(100)
  end
end

function SummonWishWindow:initTips()
  local dlTip = ed.UITool.createDraglist(self.ui.top, {})
  local autoTxt = ed.ui.autoText.new()
  local txt = T("\232\142\183\229\143\1503\230\152\159\232\139\177\233\155\132\230\151\182\239\188\140\229\135\186\231\142\176\232\174\184\230\132\191\229\141\149\229\134\133\231\154\132\232\139\177\233\155\132\231\154\132\230\166\130\231\142\135\229\144\132\230\143\144\229\141\135<lable color=ccc3(112,255,84)>35%</lable>\227\128\130") .. "<br/>" .. T("\230\156\128\229\164\154\233\128\137\230\139\169<lable color=ccc3(112,255,84)>2</lable>\228\189\141\232\139\177\233\155\132\239\188\140\230\175\143\229\145\168\229\144\132\231\148\159\230\149\136<lable color=ccc3(112,255,84)>1</lable>\230\172\161\227\128\130")
  autoTxt:initParam({
    context = txt,
    color = ccc3(255, 230, 154),
    fontSize = 15,
    shadowColor = ccc3(0, 0, 0),
    shadowOffset = ccp(0, 3)
  })
  dlTip:addItem(autoTxt.node)
  autoTxt.node:setPositionY(self.ui.top:getContentSize().height - autoTxt:getFirstLineHeight() * 0.6)
  local _, hei = autoTxt:getCurContentSize()
  dlTip:initListHeight(hei)
end

function SummonWishWindow:initHerosList()
  local delegate = {
    numberOfCells = function()
      return #self.heroList
    end,
    cellSizeFromIndex = function(idx)
      return CCSizeMake(75, 75)
    end,
    createCell = function(idx)
      local id = self.heroList[idx]
      local item, selected = self:createHeroItem(id, true)
      return item, {id = id, selected = selected}
    end,
    doClickIn = function(cell, x, y)
      if not ed.containsPoint(cell.node, x, y) then
        return
      end
      local id = self.heroList[cell.idx]
      local data, index = self:findHeroInWishList(id)
      local alreadyAdd = data ~= nil
      if alreadyAdd and data._succeeded > 0 then
        ed.showToast(T("\230\173\164\230\132\191\230\156\155\229\183\178\229\174\158\231\142\176\230\151\160\230\179\149\229\136\135\230\141\162\239\188\129"))
        return
      end
      if alreadyAdd and self:removeFromWishingListAt(index) then
        cell.data.selected:setVisible(false)
        self:updateWishList()
        self.heroListView:updateCellAtIndex(cell.idx)
      elseif self:addToWishingList(id) then
        cell.data.selected:setVisible(true)
        self:updateWishList()
        self.heroListView:updateCellAtIndex(cell.idx)
      end
    end
  }
  local size = self.ui.hero_list_bg:getContentSize()
  local param = {
    delegate = delegate,
    container = self.ui.hero_list_bg,
    cliprect = CCRectMake(9, 0, size.width, size.height - 8),
    dragMode = 1,
    colNum = 4,
    zorder = 999,
    touchpriority = -301,
    noshade = true,
    padding = CCSizeMake(11, 12),
    offset = {2.5, -5}
  }
  self.heroListView = Tableview.create(param)
end

function SummonWishWindow:updateWishList()
  local list = self.wishingHeroList
  if ed.tableIsNilOrEmpty(list) then
    return
  end
  for i = 1, 2 do
    local data = list[i]
    local item = self.ui["item_" .. i]
    self:clearItemAt(i)
    if data and data._hero > 0 then
      item:setVisible(false)
      local x, y = item:getPosition()
      item = self:createHeroItem(data._hero, false)
      item:setPosition(x, y)
      self.ui.wish_heros_root:addChild(item)
      self.wishItems[i] = item
      self:btRegisterClick({
        key = "item_" .. i,
        clickHandler = function(param, x, y)
          if not ed.containsPoint(item, x, y) then
            return
          end
          if data._succeeded > 0 then
            ed.showToast(T("\230\173\164\230\132\191\230\156\155\229\183\178\229\174\158\231\142\176\239\188\129"))
            return
          end
          if self:removeFromWishingListAt(i) then
            self:updateWishList()
            self.heroListView:staticSync()
          end
        end,
        force = true,
        priority = 10
      })
    else
      item:setVisible(true)
    end
  end
end

function SummonWishWindow:addToWishingList(id)
  local dirty = false
  for i, v in ipairs(self.wishingHeroList) do
    if not v._hero or v._hero == 0 then
      self.wishingHeroList[i]._hero = id
      dirty = true
      break
    end
  end
  if dirty then
    ed.summonMgr:sortWishList(self.wishingHeroList)
  end
  return dirty
end

function SummonWishWindow:removeFromWishingListAt(idx)
  local data = self.wishingHeroList[idx]
  if not data or data._succeeded > 0 then
    return false
  end
  local len = #self.wishingHeroList
  local lastest = data
  for i = idx + 1, len do
    data = self.wishingHeroList[i]
    if data._succeeded == 0 then
      local j = 1
      local predata = self.wishingHeroList[i - j]
      while predata and predata._succeeded > 0 do
        j = j + 1
        predata = self.wishingHeroList[i - j]
      end
      if predata then
        predata._hero = data._hero
        predata._succeeded = 0
        lastest = data
      end
    end
  end
  lastest._hero = 0
  lastest._succeeded = 0
  ed.summonMgr:sortWishList(self.wishingHeroList)
  return true
end

function SummonWishWindow:clearItemAt(idx)
  local item = self.wishItems[idx]
  if item then
    item:removeFromParentAndCleanup(true)
    self.wishItems[idx] = nil
  end
end

function SummonWishWindow:setBackButton()
  local ui = self.ui
  local readnode = ed.readnode.create(self.container, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "btn_back_wish",
        res = "UI/alpha/1080P/common/break_butt_bj.png"
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "back_arrow",
        res = "UI/alpha/1080P/common/break_butt.png",
        parent = "btn_back_wish"
      },
      config = {}
    }
  }
  readnode:addNode(ui_info)
  ed.layout.centerInParent(ui.back_arrow)
  ed.layout.layoutWithMagin(ui.btn_back_wish, {left = 0, top = 0})
end

function SummonWishWindow:switchTab(idx)
  if idx == self.tabIdx then
    return
  end
  local selected = self.ui["btn_selected_" .. idx]
  selected:setVisible(true)
  if self.tabIdx then
    selected = self.ui["btn_selected_" .. self.tabIdx]
    selected:setVisible(false)
  end
  self.tabIdx = idx
  self.heroList = self:getTabHeroList(idx)
  self.heroListView:reloadData()
end

function SummonWishWindow:addEventListener()
  self:registerBtnClick("btn_save", function()
    local list = ed.copyTable(self.wishingHeroList)
    for i = #list, 1, -1 do
      if list[i]._hero == 0 then
        table.remove(list, i)
      end
    end
    ed.summonNet:send("switch_wish", {_wish_list = list})
    ed.summonMgr:setUserSelectedWishList(self.wishingHeroList)
  end)
  self:registerBtnClick("btn_back_wish", function()
    local tabs = ed.summonMgr:getWishList()
    local tabNew = self.wishingHeroList
    local heroUp = false
    for i = 1, 2 do
      if (tabs[i] and tabs[i]._hero or -1) ~= (tabNew[i] and tabNew[i]._hero or -1) then
        heroUp = true
        break
      end
    end
    if heroUp then
      local function callBack()
        local list = ed.copyTable(self.wishingHeroList)
        
        for i = #list, 1, -1 do
          if list[i]._hero == 0 then
            table.remove(list, i)
          end
        end
        ed.summonNet:send("switch_wish", {_wish_list = list})
        ed.summonMgr:setUserSelectedWishList(self.wishingHeroList)
        self:destroy({
          skipAnim = true,
          callback = function()
            self:onDestroy()
          end
        })
      end
      
      local dialogInfo = {
        text = T("\232\174\184\230\132\191\229\141\149\230\156\137\229\176\154\230\156\170\228\191\157\229\173\152\231\154\132\230\155\180\230\148\185\239\188\140\230\152\175\229\144\166\228\191\157\229\173\152?"),
        rightHandler = callBack,
        leftHandler = function()
          self:destroy({
            skipAnim = true,
            callback = function()
              self:onDestroy()
            end
          })
        end
      }
      ed.showConfirmDialog(dialogInfo)
    else
      self:destroy({
        skipAnim = true,
        callback = function()
          self:onDestroy()
        end
      })
    end
  end)
  for i = 1, 4 do
    self:registerBtnClick("btn_" .. i, function()
      self:switchTab(i)
    end)
  end
  ListenEvent("SummonSwitchWish", function(result)
    if result then
      ed.showToast(T("\228\191\157\229\173\152\230\136\144\229\138\159\239\188\129"))
      self:destroy({
        skipAnim = true,
        callback = function()
          self:onDestroy()
        end
      })
      return
    end
    ed.showToast(T("\228\191\157\229\173\152\229\164\177\232\180\165\239\188\129"))
    self:resetWishingHeroList()
    self:updateWishList()
    self.heroListView:staticSync()
  end, SummonWishWindow.eventScope)
end

function SummonWishWindow:registerBtnClick(key, func)
  local ui = self.ui
  local config = {
    button = ui[key],
    press = ui[key .. "_press"],
    key = key,
    pressScale = 0.9,
    clickHandler = function(_, x, y)
      ed.playEffect(ed.sound.deo.common_back)
      func()
    end,
    clickInterval = 0.5,
    priority = 10
  }
  self:btRegisterButtonClick(config)
end

function SummonWishWindow:onDestroy()
  CloseScope(SummonWishWindow.eventScope)
end

function SummonWishWindow:findHeroInWishList(id)
  for i, v in ipairs(self.wishingHeroList) do
    if v._hero == id then
      return v, i
    end
  end
  return nil
end

function SummonWishWindow:createHeroItem(id, isCell)
  local stars = ed.readhero.getHeroInitStars(id)
  local state
  if ed.player.heroes[id] then
    stars = ed.player.heroes[id]._stars
  else
    state = "noOwn"
  end
  local item = ed.readhero.getIcon({
    id = id,
    stars = stars,
    length = 75,
    state = state
  })
  local data = self:findHeroInWishList(id)
  local size = item:getContentSize()
  if (not data or not (data._succeeded > 0)) and ed.readhero.checkHeroMaxStar(id) then
    local flag = ed.createSprite("UI/alpha/1080P/summon/summon_hero_star_max.png")
    flag:setPosition(size.width / 2, size.height / 2 + 22)
    local label_star = ed.createttf(T("\229\183\178\230\187\161\230\152\159"), 15, ed.fontBold)
    label_star:limitWidthByScale(size.width - 5)
    ed.setLabelColor(label_star, ed.toccc3(16775796))
    ed.setLabelStroke(label_star, ed.toccc3(9978880), 1)
    flag:addChild(label_star)
    ed.layout.centerInParent(label_star)
    item:addChild(flag)
  end
  local flagLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  size.width = size.width + 6
  size.height = size.height + 6
  flagLayer:setContentSize(size)
  item:addChild(flagLayer, 2)
  flagLayer:setVisible(false)
  ed.layout.centerInParent(flagLayer)
  local x, y = flagLayer:getPosition()
  flagLayer:setPosition(x - 2.5, y - 3)
  if isCell then
    local flag = ed.createSprite("UI/alpha/1080P/package/selected.png")
    flag:setScale(0.9)
    flagLayer:addChild(flag)
    flagLayer:setVisible(data ~= nil)
    ed.layout.centerInParent(flag)
  elseif data and data._succeeded > 0 then
    local ttf = ed.createSprite("UI/alpha/1080P/summon/summon_hero_pass.png")
    flagLayer:addChild(ttf)
    flagLayer:setVisible(true)
    ed.layout.centerInParent(ttf)
    local completeLabel = EDCurLanguage == "en" and "Acquired" or T("\229\183\178\232\190\190\230\136\144")
    local label_pass = ed.createttf(completeLabel, 15, ed.fontBold)
    ed.setLabelColor(label_pass, ed.toccc3(11202661))
    ed.setLabelStroke(label_pass, ed.toccc3(874533), 1)
    ttf:addChild(label_pass)
    ed.layout.centerInParent(label_pass)
  end
  if not isCell then
    local name = ed.getDataTable("Unit")[id]["Display Name"]
    local ttf = ed.createLabelTTF(name, 15)
    ed.setLabelColor(ttf, ccc3(ed.colorToStr("#fffce7")))
    ttf:setPosition(size.width / 2 - 2, size.height / 2 - 52)
    ed.setLabelStroke(ttf, ccc3(ed.colorToStr("#272524")), 1)
    ed.adaptLabel(ttf, {maxWidth = 85, minScale = 0.75})
    item:addChild(ttf)
  end
  return item, flagLayer
end

local tabType = {
  "ALL",
  "STR",
  "INT",
  "AGI"
}

function SummonWishWindow:getTabHeroList(idx)
  if not tabType[idx] then
    return
  end
  return self.tabHeroList[tabType[idx]]
end

function SummonWishWindow:resetWishingHeroList()
  self.wishingHeroList = {}
  for i, v in ipairs(ed.summonMgr:getWishList()) do
    table.insert(self.wishingHeroList, {
      _pos = v._pos,
      _succeeded = v._succeeded,
      _hero = v._hero
    })
  end
end

function SummonWishWindow.getGoodsName(id, type)
  local typ = string.lower(type)
  local name = "nil"
  if typ == "gold" then
    name = T("\233\135\145\229\184\129")
  elseif typ == "diamond" then
    name = T("\233\146\187\231\159\179")
  elseif typ == "item" then
    name = ed.getDataTable("equip")[id].Name
  elseif typ == "medal" then
    name = ed.getDataTable("Medal")[id].Name
  elseif typ == "hero" then
    name = ed.getDataTable("Unit")[id]["Display Name"]
  end
  return name
end

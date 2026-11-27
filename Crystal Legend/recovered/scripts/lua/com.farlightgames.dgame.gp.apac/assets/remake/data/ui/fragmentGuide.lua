local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.fragmentGuide = class
local lsr = ed.ui.fragmentcomposelsr.create()

local function show(self)
  lsr:report("createWindow")
  self.bg:setScale(0)
  local action = CCScaleTo:create(0.2, 1)
  action = CCEaseBackOut:create(action)
  self.bg:runAction(action)
end

class.show = show

local function cheakGetWay(self)
  local wayNum = 0
  for i, v in ipairs(self.getWayID) do
    local id = v.wayid
    local st = ed.stageType(id)
    if ed.isElementInTable(st, {"normal", "elite"}) then
      local star = ed.player:getStageStar(id) or 0
      local preStar = ed.player:getStageStar(id - 1) or 0
      if 0 < star + preStar then
        wayNum = wayNum + 1
      end
    end
  end
  return wayNum
end

class.cheakGetWay = cheakGetWay

local function createCraftTree(self, id, skipAnim, isOneTimeCraft)
  if self.tree and not tolua.isnull(self.tree.layer) then
    self.tree.layer:removeFromParentAndCleanup(true)
  end
  self.tree = {}
  self.getWayButton = {}
  local layer = self.bg
  local components, category
  local row = ed.getDataTable("equipcraft")[id]
  if row then
    components = row.Components
    category = row.Category
  else
    components = 0
  end
  components = components or 0
  self.craftid = id
  self.components = components
  self.craftCategory = category
  local tree = CCSprite:create()
  tree:setPosition(ccp(0, 0))
  self.tree.layer = tree
  tree:setCascadeOpacityEnabled(true)
  layer:addChild(tree)
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "name",
        text = ed.getDataTable("equip")[id].Name,
        size = 18
      },
      layout = {
        position = ccp(142, 286)
      },
      config = {
        color = ccc3(255, 0, 0)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "craftButton",
        res = "UI/alpha/HVGA/package_button.png"
      },
      layout = {
        position = ccp(143, 45)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "craftButtonPress",
        res = "UI/alpha/HVGA/package_button_down.png"
      },
      layout = {
        position = ccp(143, 45)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(tree, self.tree)
  readNode:addNode(ui_info)
  local rootBg = ed.readequip.createIcon(id, 60)
  rootBg:setPosition(ccp(141, 226))
  self.tree.rootBg = rootBg
  tree:addChild(rootBg, 1)
  local text = ""
  local expense
  local can, exp, onetime, totalconsume = ed.isEquipCraftable(id, true)
  local curIdCanOnetime = can and onetime
  rootBg:setPosition(ccp(50, 248))
  rootBg:setScale(0.6)
  local bg = ed.createSprite("UI/alpha/HVGA/equip_craft_getway_bg.png")
  bg:setPosition(ccp(142, 172))
  tree:addChild(bg)
  local label = ed.createttf(T("\232\142\183\229\190\151\233\128\148\229\190\132:"), 20)
  label:setAnchorPoint(ccp(0, 0.5))
  label:setPosition(ccp(80, 248))
  ed.setLabelColor(label, ccc3(203, 128, 91))
  tree:addChild(label)
  local container = CCSprite:create()
  self.tree.container = container
  container:setCascadeOpacityEnabled(true)
  tree:addChild(container)
  local info = {
    cliprect = CCRectMake(10, 70, 250, 160),
    container = container,
    priority = -180,
    upShade = "UI/alpha/HVGA/gvg/gvg_battle_shade.png",
    downShade = "UI/alpha/HVGA/gvg/gvg_battle_shade.png",
    capInsets = CCRectMake(7.81, 0, 39.84, 17.97),
    contentSize = CCSizeMake(0, 0),
    doPressIn = self:doGetWayTouch(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doGetWayTouch2(),
    cancelClickIn = self:cancelClickInList()
  }
  self.draglistBG = ed.draglist.create(info)
  self.draglistBG:setTouchEnabled(true)
  local layer = self.draglistBG:getList()
  self.draglistHeight = 0
  local getway = self:equipGetWay(id)
  self.getWayID = getway
  if #getway == 0 then
    local equip = ed.getDataTable("equip")[id]
    local getText = table.concat(equip["How To Get"], "\n")
    if getText and getText ~= "" then
      local label = ed.createNode({
        t = "Label",
        base = {text = getText, size = 18},
        layout = {
          anchor = ccp(0.5, 1),
          position = ccp(140, 170)
        },
        config = {
          color = ccc3(238, 204, 119),
          dimension = CCSizeMake(240, 0),
          shadow = {
            color = ccc3(0, 0, 0),
            offset = ccp(0, 2)
          }
        }
      }, tree)
    end
  else
    for i = 1, #getway do
      local id = getway[i].wayid
      local dropid = id
      self.draglistHeight = self.draglistHeight + 53.5
      local board = ed.createSprite("UI/alpha/HVGA/equip_craft_getway_board.png")
      board:setPosition(ccp(142, 195 - 50 * (i - 1)))
      self.draglistBG:addItem(board)
      board:setCascadeOpacityEnabled(true)
      local iconRes = ed.ui.stageselectres.getStageIcon(id)
      self:createStageDetail(board, getway[i], iconRes)
      if ed.tutorialcheck.SFSelectStage() then
        local hid, teid, sid = ed.readhero.getFarmableProp()
        if hid == self.hid and self.id == teid and sid == dropid then
          ed.teach("SFSelectStage", board, tree)
        end
      end
      self.getWayButton[i] = board
    end
    local num = math.max(self.draglistHeight - 265 + (self:cheakGetWay() - 3) * 53.5, 0)
    self:setListLayerHeight(self.draglistHeight, num)
  end
  text = T("\232\191\148\229\155\158")
  local craftLabel = ed.createttf(text, 24)
  craftLabel:setPosition(ccp(143, 45))
  self.tree.craftLabel = craftLabel
  tree:addChild(craftLabel)
end

class.createCraftTree = createCraftTree

function class:createStageDetail(board, stageinfo, iconRes)
  local difficultyRoman = {
    [0] = "I",
    [1] = "II",
    [2] = "III",
    [3] = "IV",
    [4] = "V",
    [5] = "VI",
    [6] = "VII",
    [7] = "VIII",
    [8] = "IX",
    [9] = "X"
  }
  local ui = {}
  local stageTable = ed.getDataTable("Stage")
  local id = stageinfo.wayid
  local row
  local isElite = 10000 < id and id < 20000
  if id < 10000 then
    row = stageTable[id]
  else
    local gid = stageTable[id]["Stage Group"]
    row = stageTable[gid]
  end
  if iconRes then
    ui.stage = self:createStageDetailIcon(board, iconRes, stageinfo.enable)
  end
  local title = self:getStageName(id)
  title = self:createStageDetailTitle(board, title, stageinfo.enable)
  ui.title = title
  if isElite then
    ui.elite = self:createEliteTitle(board, title)
  end
  local name = row["Stage Name"]
  if stageinfo.start_id then
    name = T("\233\154\190\229\186\166") .. difficultyRoman[stageinfo.start_id]
    if stageinfo.end_id then
      name = name .. T("-\233\154\190\229\186\166") .. difficultyRoman[stageinfo.end_id]
    end
  end
  ui.name = self:createStageDetailName(board, name, stageinfo.enable)
  if self:isCurrentHeroTaskItem(self.currentId) and not ed.isAwakeEquipDropStage(sid) then
    self:setStageGray(ui)
  end
end

function class:createEliteTitle(board, title)
  local elite = ed.createttf(T("\231\178\190\232\139\177"), 18)
  ed.setLabelColor(elite, ccc3(255, 0, 0))
  elite:setAnchorPoint(ccp(0, 0.5))
  elite:setPosition(ccp(75 + title:getContentSize().width, 35))
  board:addChild(elite)
  return elite
end

function class:createStageDetailName(board, name, enable)
  local name = ed.createttf(name, 18)
  if enable == false then
    ed.setLabelColor(name, ccc3(173, 156, 131))
  else
    ed.setLabelColor(name, ccc3(182, 65, 21))
  end
  name:setAnchorPoint(ccp(0, 0.5))
  name:setPosition(ccp(68, 12))
  board:addChild(name)
  return name
end

function class:getStageName(id)
  local row = ed.getDataTable("Stage")[id]
  if id < 20000 then
    return T("\194\183\231\172\172%d\231\171\160", row["Chapter ID"])
  elseif 20000 < id and id < 30000 then
    return T("\194\183" .. row["Stage Name"])
  end
end

function class:createStageDetailTitle(board, title, enable)
  local title = ed.createttf(title, 18)
  if enable == false then
    ed.setLabelColor(title, ccc3(173, 156, 131))
  else
    ed.setLabelColor(title, ccc3(182, 65, 21))
  end
  title:setAnchorPoint(ccp(0, 1))
  title:setPosition(ccp(65, 44))
  if self.drop == "specialdrop" and not self.getWayColum then
    title:setDimensions(CCSizeMake(160, 0))
    title:setPosition(ccp(65, 40))
    title:setHorizontalAlignment(kCCTextAlignmentLeft)
  end
  board:addChild(title)
  return title
end

function class:createStageDetailIcon(board, res, enable)
  local stage = ed.createSprite(res)
  stage:setPosition(ccp(35, 25))
  if enable == false then
    ed.setSpriteGray(stage)
  end
  stage:setScale(58 / stage:getContentSize().height)
  board:addChild(stage)
  return stage
end

function class:equipGetWay(id)
  local getway = {}
  local equipInfo = ed.getDataTable("equip")[id]
  local tg = equipInfo.Drop
  if self.drop == "specialdrop" then
    tg = equipInfo["Special Loot Drop"]
    if #tg == 0 then
      tg = equipInfo.Drop
    end
  end
  for i, v in ipairs(tg) do
    if 0 < v then
      table.insert(getway, {wayid = v})
    end
  end
  if self:isCurrentHeroTaskItem(id) then
    getway = {}
    table.sort(tg, function(a, b)
      return a < b
    end)
    for i, v in ipairs(tg) do
      if 0 < v and v >= ed.getAwakeEquipDropStage() and self:notClosePreStage(tg[i - 1]) then
        table.insert(getway, {wayid = v})
      end
    end
  end
  
  local function getThousandDigit(num)
    num = num % 10000
    return math.floor(num / 1000)
  end
  
  local grayGetWay = {}
  local actStageCsv = ed.getDataTable("ActStageGroup")
  for stage_group, stage_content in pairs(actStageCsv) do
    local rewards = stage_content["UI reward"]
    local fragCsv = ed.getDataTable("fragment")
    for rew_idx, rew_id in ipairs(rewards or {}) do
      if fragCsv[rew_id] and id == fragCsv[rew_id]["Fragment ID"] then
        local start_id, end_id, start_stage_id
        local stageIds = stage_content.Stages
        local stageCsv = ed.getDataTable("Stage")
        for idx, stage_id in ipairs(stageIds) do
          local stageInfo = stageCsv[stage_id]
          for i = 1, 10 do
            if rew_id == stageInfo["UI reward" .. i] then
              if not start_id then
                start_stage_id = stage_id
                start_id = getThousandDigit(stage_id)
              else
                end_id = getThousandDigit(stage_id)
                end_id = self:filterEndForMonsterseal(end_id, stage_id)
              end
            end
          end
        end
        if self:filterStartForMonsterseal(start_id, start_stage_id) then
          if not ed.player:isStageEnable(stage_group) then
            table.insert(grayGetWay, {
              wayid = stage_group,
              start_id = start_id,
              end_id = end_id,
              enable = false
            })
          else
            table.insert(getway, {
              wayid = stage_group,
              start_id = start_id,
              end_id = end_id
            })
          end
        end
      end
    end
  end
  for i, v in ipairs(grayGetWay) do
    table.insert(getway, v)
  end
  return getway
end

function class:isCurrentHeroTaskItem(tid)
  local herotask = ed.player:withHeroTask("working")
  if herotask then
    local id = herotask._id
    local line = herotask._line
    local taskinfo = ed.getDataTable("HeroTask")[line][id]
    if taskinfo and taskinfo["Item ID"] == tid then
      return true
    end
  end
end

local filterTbl = {
  str = 8,
  agi = 8,
  int = 8,
  spring = 8
}

function class:notClosePreStage(stage)
  if not stage then
    return true
  end
  local star = ed.player:getStageStar(stage) or 0
  local preStar = ed.player:getStageStar(stage - 1) or 0
  if 0 < star + preStar then
    return true
  end
  return false
end

function class:filterStartForMonsterseal(start_id, stage_id)
  local key
  if 20000 < stage_id and stage_id < 30000 then
    local mod = stage_id % 100
    if 3 == mod then
      key = "int"
    elseif 4 == mod then
      key = "agi"
    elseif 5 == mod then
      key = "str"
    elseif 6 <= mod and mod <= 12 then
      key = "spring"
    end
  end
  if key and filterTbl[key] < start_id + 1 then
    local monsterseal_obj = ed.monsterseal.monsterseal_object
    local milestoneid = monsterseal_obj:getMileStoneID()
    local limitid = monsterseal_obj:getLimitID()
    if limitid == 0 or limitid == 1 and 0 < milestoneid and milestoneid <= 4 then
      return false
    end
  end
  return true
end

function class:filterEndForMonsterseal(end_id, stage_id)
  local key
  if 20000 < stage_id and stage_id < 30000 then
    local mod = stage_id % 100
    if 3 == mod then
      key = "int"
    elseif 4 == mod then
      key = "agi"
    elseif 5 == mod then
      key = "str"
    elseif 6 <= mod and mod <= 12 then
      key = "spring"
    end
  end
  if key and filterTbl[key] < end_id + 1 then
    local monsterseal_obj = ed.monsterseal.monsterseal_object
    local milestoneid = monsterseal_obj:getMileStoneID()
    local limitid = monsterseal_obj:getLimitID()
    if limitid == 0 or limitid == 1 and 0 < milestoneid and milestoneid <= 4 then
      return filterTbl[key]
    end
  end
  return end_id
end

local function setHistoryListWidth(self, width)
  local lw = 265
  local pw = self.draglist.listWidth
  local ll = self.draglist.listLayer
  local px, py = ll:getPosition()
  self.draglist:initListWidth(width)
  ll:setPosition(px, py)
  if width > lw then
    ll:stopAllActions()
    local move = CCMoveTo:create(0.2, ccp(lw - width, 0))
    move = CCEaseBackOut:create(move)
    ll:runAction(move)
  else
    ll:stopAllActions()
    local move = CCMoveTo:create(0.2, ccp(0, 0))
    move = CCEaseBackOut:create(move)
    ll:runAction(move)
  end
end

class.setHistoryListWidth = setHistoryListWidth

local function setListLayerHeight(self, lh, num)
  local ll = self.draglistBG:getList()
  local x, y = ll:getPosition()
  local bp = ccp(x, y)
  self.draglistBG:initListHeight(lh)
  ll:setPosition(bp)
  local ep = ccp(x, num)
  ll:setPosition(ep)
  if ll:getPositionY() > 0 then
    self.draglistBG:refreshShade()
  end
end

class.setListLayerHeight = setListLayerHeight

local function doPressInList(self)
  local handler = self:doGetWayTouch()
  return handler
end

class.doPressInList = doPressInList

local function cancelPressInList(self)
  local scale = 1
  local event = event
  
  local function handler(x, y, id)
    local buttons = self.getWayButton
    if not buttons then
      return
    end
    if self.stageid then
      buttons[self.stageid]:setScale(scale)
    end
  end
  
  return handler
end

class.cancelPressInList = cancelPressInList

local function doClickGetWay(self, wayinfo)
  local id = wayinfo.wayid
  local st = ed.stageType(id)
  if ed.isElementInTable(st, {"normal", "elite"}) then
    local star = ed.player:getStageStar(id) or 0
    local preStar = ed.player:getStageStar(id - 1) or 0
    if 0 < star + preStar then
      local scene = ed.ui.stageselect.createByStage(id)
      ed.pushScene(scene)
    else
      ed.showToast(T("\229\133\179\229\141\161\229\176\154\230\156\170\229\188\128\229\144\175\227\128\130"))
    end
  elseif st == "act" then
    local id = wayinfo.wayid
    if 20000 < id and id < 30000 then
      if wayinfo.enable == false then
        ed.showToast(T("\232\175\165\230\180\187\229\138\168\229\133\179\229\141\161\228\187\138\230\151\165\230\156\170\229\188\128\230\148\190"))
      else
        local mod = id % 100
        if 3 <= mod and mod <= 5 then
          ed.ui.main.openExercise("equip", wayinfo)
        elseif 6 <= mod and mod <= 12 then
          ed.ui.main.openExercise("spring", wayinfo)
        end
      end
    end
  end
  if self.SFDropId and self.SFDropId == id then
    ed.endTeach("SFSelectStage")
    self.SFDropId = nil
  end
end

class.doClickGetWay = doClickGetWay

local function doGetWayTouch(self)
  self.stageid = nil
  local scale = 1
  local event = event
  
  local function handler(x, y)
    local buttons = self.getWayButton
    if not buttons then
      return
    end
    for i = 1, #buttons do
      local button = buttons[i]
      if ed.containsPoint(button, x, y) then
        self.stageid = i
        scale = button:getScale()
        button:setScale(scale * 0.95)
        break
      end
    end
    return self.stageid
  end
  
  return handler
end

class.doGetWayTouch = doGetWayTouch

local function doGetWayTouch2(self)
  local scale = 1
  local event = event
  
  local function handler(x, y, id)
    local buttons = self.getWayButton
    if not buttons then
      return
    end
    if self.stageid then
      buttons[self.stageid]:setScale(scale)
      if ed.containsPoint(buttons[self.stageid], x, y) then
        self:doClickGetWay(self.getWayID[self.stageid])
      end
    end
    self.stageid = nil
  end
  
  return handler
end

class.doGetWayTouch2 = doGetWayTouch2

local function cancelClickInList(self)
  local scale = 1
  local event = event
  
  local function handler(x, y, id)
    local buttons = self.getWayButton
    if not buttons then
      return
    end
    if self.stageid then
      buttons[self.stageid]:setScale(scale)
    end
  end
  
  return handler
end

class.cancelClickInList = cancelClickInList

local function setHistory(self, index, id, oneTimeCraftInfo)
  self.history = self.history or {}
  index = index or 0
  local hst = self.history
  local cw = self.craftWindow
  local ori = ccp(55, 340)
  local offsetX = 58
  local len = #self.history
  local cursor
  local container = self:createHistoryLayer()
  if index == 0 or index > len then
    self.historyid = len + 1
    local iconBg, icon = ed.readequip.createSmallIcon(id)
    iconBg:setPosition(ori.x + offsetX * len, ori.y)
    self.hstIconScale = iconBg:getScale()
    local arrow
    if 0 < len then
      arrow = ed.createSprite("UI/alpha/HVGA/view_history_arrow.png")
      arrow:setPosition(ori.x + offsetX * (len - 0.5), ori.y)
    end
    local element = {
      id = id,
      iconBg = iconBg,
      icon = icon,
      arrow = arrow
    }
    hst[len + 1] = element
    if arrow then
      container:addChild(arrow)
    end
    container:addChild(iconBg)
    local action = CCFadeIn:create(0.5)
    iconBg:runAction(action)
    cursor = len + 1
    self:setHistoryListWidth(ori.x + offsetX * len + 30)
  elseif index <= len then
    self.historyid = index
    for i = index + 1, len do
      hst[i].iconBg:removeFromParentAndCleanup(true)
      if hst[i].arrow then
        hst[i].arrow:removeFromParentAndCleanup(true)
      end
      hst[i] = nil
    end
    self:createCraftTree(hst[index].id, nil, oneTimeCraftInfo)
    cursor = index
    local x = hst[index].iconBg:getPositionX()
    self:setHistoryListWidth(x + 30)
  end
  if tolua.isnull(self.historyCursor) then
    local tag = ed.createSprite("UI/alpha/HVGA/equip_craft_select.png")
    self.historyCursor = tag
    container:addChild(tag, 10)
  end
  self.historyCursor:setPosition(ccp(ori.x + offsetX * (cursor - 1), ori.y - 3))
end

class.setHistory = setHistory

local function createHistoryLayer(self)
  if self.draglist and not tolua.isnull(self.draglist.layer) then
    return self.draglist.listLayer
  end
  local config = {
    cliprect = CCRectMake(12, 300, 265, 80),
    container = self.bg,
    zorder = 10,
    priority = -161,
    noshade = true,
    doClickIn = self:doClickInHistory(),
    cancelClickIn = self:cancelClickInHistory(),
    doPressIn = self:doPressInHistory(),
    cancelPressIn = self:cancelPressInHistory()
  }
  self.draglist = ed.draglist.create(config)
  return self.draglist.listLayer
end

class.createHistoryLayer = createHistoryLayer

local function doPressInHistory(self)
  local function handler(x, y)
    if not self.isOpen then
      return
    end
    local hst = self.history
    local osc = self.hstIconScale or 1
    for i = 1, #(hst or {}) do
      local icon = hst[i].iconBg
      if ed.containsPoint(icon, x, y) then
        icon:setScale(osc * 0.95)
        return i
      end
    end
  end
  
  return handler
end

class.doPressInHistory = doPressInHistory

local function doClickInHistory(self)
  local function handler(x, y, id)
    if self.isCrafting or not self.isOpen then
      return
    end
    local hst = self.history
    local osc = self.hstIconScale or 1
    local icon = hst[id].iconBg
    icon:setScale(osc)
    if ed.containsPoint(icon, x, y) then
      lsr:report("clickHistoryNode")
      local delay = CCDelayTime:create(0)
      local func = CCCallFunc:create(function()
        xpcall(function()
          self:setHistory(id)
        end, EDDebug)
      end)
      local s = CCSequence:createWithTwoActions(delay, func)
      self.mainLayer:runAction(s)
    end
  end
  
  return handler
end

class.doClickInHistory = doClickInHistory

local function cancelPressInHistory(self)
  local function handler(x, y, id)
    if not self.isOpen then
      return
    end
    local hst = self.history
    local osc = self.hstIconScale or 1
    local icon = hst[id].iconBg
    icon:setScale(osc)
  end
  
  return handler
end

class.cancelPressInHistory = cancelPressInHistory

local function cancelClickInHistory(self)
  local function handler(x, y, id)
    if not self.isOpen then
      return
    end
    local hst = self.history
    local osc = self.hstIconScale or 1
    local icon = hst[id].iconBg
    icon:setScale(osc)
  end
  
  return handler
end

class.cancelClickInHistory = cancelClickInHistory

local function destroy(self)
  lsr:report("closeWindow")
  self.mainLayer:removeFromParentAndCleanup(true)
end

class.destroy = destroy

local function doOutPanelTouch(self)
  local function handler(event, x, y)
    xpcall(function()
      if event == "began" then
        if not ed.containsPoint(self.bg, x, y) then
          self.isClickOutPanel = true
        end
      elseif event == "ended" and not ed.containsPoint(self.bg, x, y) and self.isClickOutPanel then
        self:retrunFragmentComposeView()
        self:destroy()
      end
    end, EDDebug)
  end
  
  return handler
end

class.doOutPanelTouch = doOutPanelTouch

local function doCraftButtonTouch(self)
  local click = false
  local button, shade
  
  local function handler(event, x, y)
    if not ed.containsPoint(self.tree.craftButton, x, y) then
      return
    end
    local ui = self.tree
    button = self.tree.craftButton
    shade = self.tree.craftButtonPress
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        shade:setVisible(true)
        click = true
      end
    elseif event == "ended" then
      shade:setVisible(false)
      if ed.containsPoint(button, x, y) and click then
        self:retrunFragmentComposeView()
        self:destroy()
      end
      click = false
    end
  end
  
  return handler
end

class.doCraftButtonTouch = doCraftButtonTouch

local function retrunFragmentComposeView(self)
  local fragmentcomposeLayer = ed.ui.fragmentcompose.pop(self.id, {
    package = self.package,
    destroyCallback = self.destroyHandler
  })
  self.package.composeLayer = fragmentcomposeLayer
end

class.retrunFragmentComposeView = retrunFragmentComposeView

local function doMainLayerTouch(self)
  local doCraftButtonTouch = self:doCraftButtonTouch()
  
  local function handler(event, x, y)
    xpcall(function()
      self:doOutPanelTouch()(event, x, y)
      doCraftButtonTouch(event, x, y)
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doMainLayerTouch = doMainLayerTouch

local function create(id)
  local self = {}
  setmetatable(self, class.mt)
  self.id = id
  local mainLayer = CCLayerColor:create(ccc4(0, 0, 0, 150))
  self.mainLayer = mainLayer
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, -145, true)
  local bg = ed.createSprite("UI/alpha/HVGA/equip_craft_bg.png")
  bg:setPosition(ccp(400, 240))
  self.bg = bg
  mainLayer:addChild(bg)
  ListenTimer(Timer:Once(0.1), function()
    self:createCraftTree(self.id)
    self.tree.layer:setOpacity(255)
    self:setHistory(0, self.id)
  end)
  self:show()
  return self
end

class.create = create

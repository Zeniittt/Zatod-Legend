local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.commonscene
ed.ui.equipstrengthen = class
setmetatable(class, base.mt)
local res = ed.ui.baseres
local lsr = ed.ui.equipstrengthenlsr.create()
local isFirst = true

local function createnpcTalk(self, text)
  if tolua.isnull(self.talkContainer) then
    local container = CCSprite:create()
    self.talkContainer = container
    container:setCascadeOpacityEnabled(true)
    self.container:addChild(container, 50)
    local ui = {}
    local frame = ed.createScale9Sprite("UI/alpha/1080P/equipupgrade/equipupgrade_talk_bg.png", CCRectMake(15, 26, 5, 13))
    frame:setContentSize(CCSizeMake(120, 56))
    frame:setAnchorPoint(ccp(0.5, 1))
    frame:setPosition(ccp(688 * self.fixScaleX, 438 * self.fixScaleY - 110))
    container:addChild(frame)
    ui.frame = frame
    local label = ed.createttf("", 15)
    label:setAnchorPoint(ccp(0.5, 1))
    label:setPosition(ccp(695 * self.fixScaleX, 328 * self.fixScaleY))
    container:addChild(label)
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    ed.setLabelDimensions(label, CCSizeMake(164, 0))
    ui.label = label
    self.talkui = ui
  end
  local ui = self.talkui
  local frame = ui.frame
  local label = ui.label
  ed.setString(label, text)
  local height = label:getContentSize().height + 30
  label:setPositionY(438 * self.fixScaleY - 130)
  frame:setContentSize(CCSizeMake(176, height))
end

class.createnpcTalk = createnpcTalk

local function doTalk(self, text)
  self:createnpcTalk(text)
  local container = self.talkContainer
  container:stopAllActions()
  container:setOpacity(255)
end

class.doTalk = doTalk

local function doSpeak(self, text)
  self:createnpcTalk(text)
  local container = self.talkContainer
  container:stopAllActions()
  container:setOpacity(255)
  local delay = CCDelayTime:create(1)
  local fade = CCFadeOut:create(0.2)
  local s = CCSequence:createWithTwoActions(delay, fade)
  container:runAction(s)
end

class.doSpeak = doSpeak

local function hideTalk(self)
  local container = self.talkContainer
  container:stopAllActions()
  container:setOpacity(0)
end

class.hideTalk = hideTalk

local function doStrenReply(self)
  local slot = self.slot
  
  local function handler(result)
    if ed.getCurrentScene().identity ~= "equipStrengthen" then
      return
    end
    if result then
      lsr:report("enhanceSuccess")
      self:doSpeak(T("\230\129\173\229\150\156\228\189\160\239\188\140\233\153\132\233\173\148\230\136\144\229\138\159"))
    else
      self:doSpeak(T("\229\190\136\233\129\151\230\134\190\239\188\140\233\153\132\233\173\148\229\164\177\232\180\165"))
    end
    self:initmtList()
    self:initStrenButton()
    self:initBar()
    self:initEquipAtt()
    self:initHeroEquip()
  end
  
  return handler
end

class.doStrenReply = doStrenReply

local function initmtList(self)
  self:refreshmtList()
  self:refreshmtListPos()
  if self:checkMaxLevel(self.slot) then
    self:doShowMaxLevel()
  else
    self:initMaterialLayer()
  end
  self.addmtInfo = {}
end

class.initmtList = initmtList

local function asyncLoadmt(self)
  local index = 1
  local eof
  
  local function handler()
    eof = self:createmt(index)
    index = index + 1
    if eof then
      self:removeUpdateHandler("asyncLoadmt")
    end
  end
  
  return handler
end

class.asyncLoadmt = asyncLoadmt

local function createmt(self, index)
  local list = self.allmt
  local amount = #list
  local ox, oy = 33, 438 * self.fixScaleY - 297
  local dx, dy = 62, 62
  local fixWidth = 620 * self.fixScaleX - 6
  local row = math.floor(fixWidth / 62)
  ox = fixWidth % 62 / 2 + ox
  if not self.mts then
    self.mts = {}
  end
  local bi = row * (index - 1) + 1
  local ei = math.min(row * index, amount)
  if amount < bi then
    return true
  end
  for i = bi, ei do
    local icon = ed.readequip.createIcon(list[i].id)
    icon:setPosition(ccp(ox + dx * (i - bi), oy - dy * (index - 1)))
    self.draglist:addItem(icon)
    local ehcBg
    if list[i].category == T("\231\162\142\231\137\135") then
      ehcBg = ed.createSprite("UI/alpha/HVGA/equipupgrade/equipupgrade_fragment_bg.png")
    else
      ehcBg = ed.createSprite("UI/alpha/HVGA/skill_material_att_bg.png")
    end
    ehcBg:setScaleX(77 / ehcBg:getContentSize().width)
    ehcBg:setPosition(ccp(45, 18))
    icon:addChild(ehcBg, -1)
    local aLabel = ed.createttf(list[i].amount, 14)
    aLabel:setColor(ccc3(255, 252, 231))
    aLabel:setPosition(ccp(45, 18))
    ed.setLabelStroke(aLabel, ccc3(12, 11, 11), 1)
    icon:setScale(0.78)
    icon:addChild(aLabel)
    table.insert(self.mts, {
      icon = icon,
      amountLabel = aLabel,
      info = list[i],
      add = 0
    })
    self.draglist:setFrameRect(icon, icon:getTextureRect())
    self.draglist:setParentClipNode(icon, self.draglist.listLayer)
  end
end

class.createmt = createmt

local function refreshmtList(self)
  self.moneyCost = nil
  for i = 1, #(self.mts or {}) do
    local info = self.mts[i]
    local amount = info.info.amount - info.add
    self.mts[i].info.amount = amount
    self.mts[i].add = 0
    if amount <= 0 then
      info.icon:removeFromParentAndCleanup(true)
      table.remove(self.mts, i)
      return self:refreshmtList()
    end
  end
end

class.refreshmtList = refreshmtList

local function getmtPos(self, index)
  local ox, oy = 33, 438 * self.fixScaleY - 297
  local dx, dy = 62, 62
  local fixWidth = 620 * self.fixScaleX - 6
  local row = math.floor(fixWidth / 62)
  ox = fixWidth % 62 / 2 + ox
  local x = (index - 1) % row
  local y = math.floor((index - 1) / row)
  return ccp(ox + x * dx, oy - y * dy)
end

class.getmtPos = getmtPos

local function refreshmtListPos(self)
  for i = 1, #(self.mts or {}) do
    local icon = self.mts[i].icon
    local pos = self:getmtPos(i)
    icon:setPosition(pos)
  end
end

class.refreshmtListPos = refreshmtListPos

local function createmtList(self)
  local elist = ed.readequip.getMaterialList()
  self.allmt = elist
  local amount = #elist
  self.mts = {}
  local fixWidth = 620 * self.fixScaleX - 6
  local row = math.floor(fixWidth / 62)
  local plies = math.ceil(amount / row)
  local height = 62 * plies
  self.draglist:initListHeight(height)
  self:registerUpdateHandler("asyncLoadmt", self:asyncLoadmt())
end

class.createmtList = createmtList

local function createMinusIcon(self, id)
  local mt = (self.mts or {})[id]
  if tolua.isnull(mt.minus) then
    local minus = ed.createSprite("UI/alpha/HVGA/equipupgrade/skill_material_delete.png")
    local minusPress = ed.createSprite("UI/alpha/HVGA/equipupgrade/skill_material_delete_down.png")
    local minusButton = ed.createSprite("UI/alpha/HVGA/equipupgrade/equipupgrade_star_blue.png")
    minusPress:setAnchorPoint(ccp(0, 0))
    minusPress:setPosition(ccp(0, 0))
    minus:addChild(minusPress)
    minusPress:setVisible(false)
    minusButton:setVisible(false)
    minus:setAnchorPoint(ccp(0.5, 0.5))
    minus:setPosition(ccp(70, 70))
    minusButton:setAnchorPoint(ccp(0.3, 0.3))
    minusButton:setPosition(ccp(70, 70))
    minusButton:setScale(2)
    mt.icon:addChild(minus)
    mt.icon:addChild(minusButton)
    self.mts[id].minus = minus
    self.mts[id].minusPress = minusPress
    self.mts[id].minusButton = minusButton
  end
end

class.createMinusIcon = createMinusIcon

local function removeMinusIcon(self, id)
  local mt = (self.mts or {})[id]
  if not tolua.isnull(mt.minus) then
    mt.minus:removeFromParentAndCleanup(true)
  end
end

class.removeMinusIcon = removeMinusIcon

local function playAddmtAnim(self, id, addition)
  if not isFirst then
    return
  end
  isFirst = false
  local index = id
  local mt = (self.mts or {})[id]
  local id = mt.info.id
  local icon = mt.icon
  local ti = ed.readequip.createIcon(id)
  local pos = self.draglist:getItemWorldPos(ccp(icon:getPosition()))
  ti:setPosition(pos)
  self.container:addChild(ti)
  local epos = ccp(ed.display.winSize.width / 2, 212)
  local array = CCArray:create()
  local m = CCMoveTo:create(0.2, epos)
  m = CCEaseSineIn:create(m)
  local scale = CCScaleTo:create(0.2, 0.5)
  local spawn = CCSpawn:createWithTwoActions(m, scale)
  local fade = CCFadeOut:create(0.2)
  local func = CCCallFunc:create(function()
    xpcall(function()
      ti:removeFromParentAndCleanup(true)
    end, EDDebug)
  end)
  array:addObject(spawn)
  array:addObject(fade)
  array:addObject(func)
  local s = CCSequence:create(array)
  ti:runAction(s)
end

class.playAddmtAnim = playAddmtAnim

local function playAddExpAnim(self, id, addition)
  local mt = (self.mts or {})[id]
  local bpos = ccp(ed.display.winSize.width / 2, 264.5 + 438 * (self.fixScaleY - 1))
  local ehc = mt.info.ehc
  local name = mt.info.name or ""
  local expStr = name .. "+" .. ehc
  local label = ed.createttf(expStr, 24)
  ed.setLabelColor(label, ccc3(101, 207, 255))
  ed.setLabelStroke(label, ccc3(0, 0, 0), 1)
  label:setPosition(bpos)
  self.container:addChild(label, 10)
  label:setOpacity(0)
  local a = CCArray:create()
  local fi = CCFadeIn:create(0.2)
  local d = CCDelayTime:create(0.2)
  local m = CCMoveBy:create(addition.addition, ccp(0, 30))
  m = CCEaseSineOut:create(m)
  local fo = CCFadeOut:create(addition.addition)
  local spawn = CCSpawn:createWithTwoActions(m, fo)
  local f = CCCallFunc:create(function()
    xpcall(function()
      label:removeFromParentAndCleanup(true)
    end, EDDebug)
  end)
  a:addObject(fi)
  a:addObject(d)
  a:addObject(spawn)
  a:addObject(f)
  local s = CCSequence:create(a)
  label:runAction(s)
end

class.playAddExpAnim = playAddExpAnim

local function addMaterial(self, id, addition)
  if self:checkMaxLevel(self.slot, self.targetExp) then
    self:doSpeak(T("\231\187\143\233\170\140\229\128\188\229\183\178\230\187\161"))
    return
  end
  local mt = (self.mts or {})[id]
  local add = mt.add
  local amount = mt.info.amount
  if add == amount then
    self:doSpeak(T("\230\173\164\230\157\144\230\150\153\229\183\178\231\148\168\229\174\140"))
    return
  end
  add = add + 1
  self.mts[id].add = add
  self.addmtInfo = self.addmtInfo or {}
  self.addmtInfo[mt.info.id] = (self.addmtInfo[mt.info.id] or 0) + 1
  ed.setString(mt.amountLabel, string.format("%d/%d", add, amount))
  self:createMinusIcon(id)
  if addition.isMax ~= true then
    self:playAddmtAnim(id, addition)
    self:playAddExpAnim(id, addition)
  end
  self:addExp(mt.info.ehc, addition)
  self.addmtInfo = self.addmtInfo or {}
  self.mts[id].leftTimes = self.mts[id].leftTimes or 0
  self.mts[id].leftTimes = self.mts[id].leftTimes + 1
end

class.addMaterial = addMaterial

local function deleteMaterial(self, id)
  local mt = self.mts[id]
  local add = mt.add
  if add == 0 then
    return true
  end
  add = add - 1
  self.addmtInfo[mt.info.id] = self.addmtInfo[mt.info.id] - 1
  self.mts[id].add = add
  local amount = mt.info.amount
  ed.setString(mt.amountLabel, string.format("%d/%d", add, amount))
  self:addExp(-mt.info.ehc)
  if add == 0 then
    self:removeMinusIcon(id)
  end
  self.mts[id].leftTimes = self.mts[id].leftTimes - 1
  if 0 > self.mts[id].leftTimes then
    self.mts[id].leftTimes = 0
  end
  return false
end

class.deleteMaterial = deleteMaterial

local function doPressInList(self)
  local function handler(x, y)
    local mt = self.mts
    
    for i = 1, #(mt or {}) do
      local icon = mt[i].icon
      local minus = mt[i].minus
      local press = mt[i].minusPress
      local minusButton = mt[i].minusButton
      if not tolua.isnull(minus) and ed.containsPoint(minusButton, x, y) then
        press:setVisible(true)
        return -i
      end
      if ed.containsPoint(icon, x, y) then
        icon:setScale(0.67)
        return i
      end
    end
  end
  
  return handler
end

class.doPressInList = doPressInList

local function longPressHandler(self, id)
  local speed = 6
  local count = 0
  local delay = 0.6
  local times = 0
  
  local function handler(dt)
    count = count + dt
    if count <= delay and self.draglist.dragMode then
      self:cancelKeepDoHandler()
      return
    elseif count > delay then
      times = times + speed * dt
      while 1 < times do
        EDLog("longPressHandler")
        EDLog(id)
        if self.isKeepDo then
        else
          EDLog("self.isKeepDo nil")
        end
        if 0 < id and not self.isKeepDo then
          self.isKeepDo = true
          local pressIcon = self.mts[id].icon
          local iconPos = pressIcon:getParent():convertToWorldSpace(ccp(pressIcon:getPosition()))
          local equipId = self.mts[id].info.id
          ed.ui.equipstrengthenpop.pop({
            equipId = equipId,
            hid = self.hid,
            slot = self.slot,
            ehc = self.mts[id].info.ehc,
            initAdd = self.mts[id].add,
            iconPos = iconPos,
            addHandler = function(addChange, isMax)
              for i = 1, addChange do
                self:addMaterial(id, {addition = 0.06666666666666667, isMax = isMax})
              end
            end
          })
          self:cancelKeepDoHandler()
        end
        if id < 0 then
          self.isKeepDo = true
          local is_end = self:deleteMaterial(-id, {
            addition = 1 / speed
          })
          if is_end then
            self:cancelKeepDoHandler()
          end
        end
        times = times - 1
      end
    end
  end
  
  return handler
end

class.longPressHandler = longPressHandler

local function cancelKeepDoHandler(self)
  self:removeUpdateHandler("keepDo")
end

class.cancelKeepDoHandler = cancelKeepDoHandler

local function registerKeepDoHandler(self, id)
  self:registerUpdateHandler("keepDo", self:longPressHandler(id))
end

class.registerKeepDoHandler = registerKeepDoHandler

local function doPressList(self)
  local function handler(x, y)
    self.isKeepDo = nil
    
    local mt = self.mts
    for i = 1, #(mt or {}) do
      local icon = mt[i].icon
      local minus = mt[i].minus
      local press = mt[i].minusPress
      local minusButton = mt[i].minusButton
      if not tolua.isnull(minus) and ed.containsPoint(minusButton, x, y) then
        self:registerKeepDoHandler(-i)
        press:setVisible(true)
        return -i
      end
      if ed.containsPoint(icon, x, y) then
        self:registerKeepDoHandler(i)
        return i
      end
    end
  end
  
  return handler
end

class.doPressList = doPressList

local function cancelPressInList(self)
  local function handler(x, y, id)
    self:cancelKeepDoHandler()
    
    local mt = self.mts or {}
    local icon
    if 0 < id then
      icon = mt[id].icon
      icon:setScale(0.78)
    else
      self.mts[-id].leftTimes = self.mts[-id].leftTimes or 0
      if 0 < self.mts[-id].leftTimes then
        icon = mt[-id].minusPress
        if icon and not tolua.isnull(icon) then
          icon:setVisible(false)
        end
      end
    end
  end
  
  return handler
end

class.cancelPressInList = cancelPressInList

local function doClickInList(self)
  local function handler(x, y, id)
    self:cancelKeepDoHandler()
    
    local mt = self.mts or {}
    if 0 < id then
      lsr:report("clickMaterial")
      local icon = mt[id].icon
      icon:setScale(0.78)
      if ed.containsPoint(icon, x, y) and not self.isKeepDo then
        self:addMaterial(id, {addition = 0.06666666666666667})
      end
    else
      self.mts[-id].leftTimes = self.mts[-id].leftTimes or 0
      if 0 < self.mts[-id].leftTimes then
        local minus = mt[-id].minus
        local minusPress = mt[-id].minusPress
        minusPress:setVisible(false)
        if ed.containsPoint(minusPress, x, y) then
          self:deleteMaterial(-id, {addition = 0.06666666666666667})
        end
      end
    end
  end
  
  return handler
end

class.doClickInList = doClickInList

local function cancelClickInList(self)
  local function handler(x, y, id)
    self:cancelKeepDoHandler()
    
    local mt = self.mts or {}
    local icon
    if 0 < id then
      icon = mt[id].icon
      icon:setScale(1)
    else
      icon = mt[-id].minusPress
      self.mts[-id].leftTimes = self.mts[-id].leftTimes or 0
      if 0 < self.mts[-id].leftTimes and icon then
        icon:setVisible(false)
      end
    end
  end
  
  return handler
end

class.cancelClickInList = cancelClickInList

local function createmtListLayer(self)
  local size = self.ui.material_bg:getContentSize()
  local info = {
    cliprect = CCRectMake(3, 3, size.width - 6, size.height - 6),
    noshade = true,
    container = self.ui.material_bg,
    doPressIn = self:doPressList(),
    cancelPressIn = self:cancelPressInList(),
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelClickInList()
  }
  self.draglist = ed.draglist.create(info)
  self.draglist:setLayerPos(ccp(0, -100))
  local m = CCMoveTo:create(0.2, ccp(0, 0))
  m = CCEaseSineOut:create(m)
  self.draglist:runLayerAction(m)
end

class.createmtListLayer = createmtListLayer

local function initMaterialData(self)
  self.moneyCost = nil
  for i = 1, #(self.mts or {}) do
    self.mts[i].add = 0
  end
  self.addmtInfo = {}
end

class.initMaterialData = initMaterialData

local function initMaterialLayer(self)
  if not self.draglist then
    return
  end
  if self.draglist:checknull() then
    return
  end
  local ll = self.draglist:getList()
  ll:stopAllActions()
  self:saveDraglistPos()
  self:setMaterialLayerVisible(true)
  self:initMaterialData()
  for i = 1, #(self.mts or {}) do
    local minus = self.mts[i].minus
    if not tolua.isnull(minus) then
      minus:removeFromParentAndCleanup(true)
    end
    ed.setString(self.mts[i].amountLabel, self.mts[i].info.amount)
  end
end

class.initMaterialLayer = initMaterialLayer

local function createMaterialLayer(self)
  ed.endTeach("EEopenMaterial")
  self.isSelectHero = true
  self.ui.material_label:setVisible(false)
  self.ui.btn_material:setVisible(false)
  if not tolua.isnull(self.mtContainer) then
    self:initMaterialLayer()
    return
  end
  local container = CCLayer:create()
  self.mtContainer = container
  self.container:addChild(container)
  self:createmtListLayer()
  self:createmtList()
end

class.createMaterialLayer = createMaterialLayer

local function removeMaterialLayer(self)
  if not tolua.isnull(self.mtContainer) then
    self.mtContainer:removeFromParentAndCleanup(true)
    self.draglist:clearList()
    self.mtContainer = nil
  end
end

class.removeMaterialLayer = removeMaterialLayer

local function setMaterialLayerVisible(self, visible)
  if not tolua.isnull(self.mtContainer) then
    self.mtContainer:setVisible(visible)
    self.draglist.listLayer:setVisible(visible)
  end
end

class.setMaterialLayerVisible = setMaterialLayerVisible

local function initStrenButton(self)
  local ui = self.strenui
  ui.no_cost:setVisible(true)
  ui.money_icon:setVisible(false)
  ui.money:setVisible(false)
  self.moneyCost = 0
  self.rmbCost = self:getFastStrenCost(self.slot)
  ed.setString(ui.rmb, self.rmbCost)
end

class.initStrenButton = initStrenButton

local function refreshStrenCostHandler(self)
  local function handler()
    local ui = self.strenui
    
    if self.moneyCost > ed.player._money then
      ed.setLabelColor(ui.money, ccc3(255, 0, 0))
    else
      ed.setLabelColor(ui.money, ccc3(255, 255, 255))
    end
  end
  
  return handler
end

class.refreshStrenCostHandler = refreshStrenCostHandler

local function refreshStrenCostCallback(self)
  local function handler()
    local ui = self.strenui
    
    if self.moneyCost > ed.player._money then
      self:doSpeak(T("\229\165\189\229\131\143\232\191\152\230\152\175\228\184\141\229\164\159\229\145\128"))
    else
      self:hideTalk()
    end
  end
  
  return handler
end

class.refreshStrenCostCallback = refreshStrenCostCallback

local function refreshStrenCost(self)
  local ui = self.strenui
  local hasmt = false
  for k, v in pairs(self.addmtInfo) do
    if 0 < (v or 0) then
      hasmt = true
    end
  end
  local target = math.max(math.min(self.targetExp, self:getTotalExp(self.slot)), 0)
  local ori = self:getItemExp(self.slot)
  local cost = self:getUnitMoney(self.slot) * (target - ori)
  ed.setString(self.strenui.money, cost)
  self.moneyCost = cost
  if not hasmt then
    ui.no_cost:setVisible(true)
    ui.money_icon:setVisible(false)
    ui.money:setVisible(false)
  else
    ui.no_cost:setVisible(false)
    ui.money_icon:setVisible(true)
    ui.money:setVisible(true)
    if cost > ed.player._money then
      ed.setLabelColor(ui.money, ccc3(255, 0, 0))
      self:doSpeak(T("\228\189\160\229\165\189\229\131\143\230\178\161\232\191\153\228\185\136\229\164\154\233\146\177\228\186\134"))
    else
      ed.setLabelColor(ui.money, ccc3(255, 255, 255))
      self:hideTalk()
    end
  end
end

class.refreshStrenCost = refreshStrenCost

local function dombTouch(self)
  local isPress
  
  local function handler(event, x, y)
    local button = self.ui.btn_material
    local label = self.ui.material_label
    local slot = self.slot
    if not slot then
      return
    end
    if self:checkMaxLevel(slot) then
      return
    end
    if not self.ui.material_label:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        button:setScale(0.97)
      end
    elseif event == "ended" then
      if isPress then
        button:setScale(1)
        if ed.containsPoint(button, x, y) then
          lsr:report("createMaterialList")
          self:createMaterialLayer()
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.dombTouch = dombTouch

local function doClickStren(self)
  ed.endTeach("EEclickEnhance")
  if self:checkMaxLevel(self.slot) then
    self:doSpeak(T("\232\191\153\228\184\170\231\137\169\229\147\129\229\183\178\231\187\143\228\184\141\232\131\189\229\134\141\233\153\132\233\173\148\228\186\134\227\128\130"))
    return
  end
  if (self.moneyCost or 0) <= 0 then
    self:doSpeak(T("\230\156\170\230\183\187\229\138\160\230\157\144\230\150\153"))
    return
  end
  if ed.player._money < (self.moneyCost or 0) then
    ed.showHandyDialog("useMidas", {
      callback = self:refreshStrenCostCallback(),
      refreshHandler = self:refreshStrenCostHandler()
    })
    return
  end
  self:saveDraglistPos()
  local mt = {}
  local mts = {}
  for k, v in pairs(self.addmtInfo) do
    local m = ed.packItem(k, v)
    table.insert(mt, m)
    table.insert(mts, {id = k, amount = v})
  end
  ed.netdata.equipUpgrade = {
    type = "money",
    cost = self.moneyCost,
    mts = mts,
    hid = self.hid,
    slot = self.slot
  }
  ed.netreply.equipUpgrade = self:doStrenReply()
  local msg = ed.upmsg.hero_equip_upgrade()
  msg._op_type = 1
  msg._heroid = self.hid
  msg._slot = self.slot
  msg._materials = mt
  ed.send(msg, "hero_equip_upgrade")
end

class.doClickStren = doClickStren

local function doStrenTouch(self)
  local isPress
  
  local function handler(event, x, y)
    if not self.strenui then
      return
    end
    if tolua.isnull(self.strenui.stren) then
      return
    end
    local button = self.strenui.stren
    local press = self.strenui.stren_press
    if not button:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        button:setScale(0.95)
      end
    elseif event == "ended" then
      if isPress then
        button:setScale(1)
        if ed.containsPoint(button, x, y) then
          lsr:report("clickEnhance")
          self:doClickStren()
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doStrenTouch = doStrenTouch

local function upFastStren(self)
  if self:checkMaxLevel(self.slot) then
    self:doSpeak(T("\229\183\178\233\153\132\233\173\148\229\136\176\233\161\182\231\186\167"))
    return
  end
  if ed.player._rmb < (self.rmbCost or 0) then
    ed.showHandyDialog("toRecharge")
    return
  end
  ed.netdata.equipUpgrade = {
    type = "rmb",
    cost = self.rmbCost,
    hid = self.hid,
    slot = self.slot
  }
  ed.netreply.equipUpgrade = self:doStrenReply()
  local msg = ed.upmsg.hero_equip_upgrade()
  msg._op_type = 2
  msg._heroid = self.hid
  msg._slot = self.slot
  ed.send(msg, "hero_equip_upgrade")
end

class.upFastStren = upFastStren

local function doClickFastStren(self)
  if self:checkMaxLevel(self.slot) then
    self:doSpeak(T("\232\191\153\228\184\170\231\137\169\229\147\129\229\183\178\231\187\143\228\184\141\232\131\189\229\134\141\233\153\132\233\173\148\228\186\134\227\128\130"))
    return
  end
  local ds, addition = ed.playerlimit.getAreaUnlockPrompt("Item One-Click-Upgrade")
  if ds then
    if addition and addition.type == "vip" then
      ed.showHandyDialog("vipLocked", {
        vip = addition.limit
      })
    else
      ed.showToast(ds)
    end
    return
  end
  local price = self.rmbCost
  local info = {
    text = T("\228\184\128\233\148\174\233\153\132\233\173\148\233\156\128\232\166\129\230\182\136\232\128\151%d\233\146\187\231\159\179\239\188\140\230\152\175\229\144\166\231\187\167\231\187\173\239\188\159", price),
    rightHandler = function()
      self:upFastStren()
    end
  }
  ed.showConfirmDialog(info)
end

class.doClickFastStren = doClickFastStren

local function doFastStrenTouch(self)
  local isPress
  
  local function handler(event, x, y)
    if not self.strenui then
      return
    end
    if tolua.isnull(self.strenui.faststren) then
      return
    end
    if tolua.isnull(self.strenui.fsContainer) then
      return
    end
    if not self.strenui.fsContainer:isVisible() then
      return
    end
    local button = self.strenui.faststren
    local press = self.strenui.faststren_press
    if not button:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          lsr:report("clickFastEnhance")
          self:doClickFastStren()
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doFastStrenTouch = doFastStrenTouch

local function createStrenButton(self, slot)
  if not tolua.isnull(self.strenContainer) then
    self.strenContainer:removeFromParentAndCleanup(true)
    self.strenContainer = nil
  end
  if not slot then
    self.strenui = nil
    self:setMaterialLayerVisible(false)
    return
  end
  local container = CCSprite:create()
  self.strenContainer = container
  container:setCascadeOpacityEnabled(true)
  self.container:addChild(container)
  self.rmbCost = self:getFastStrenCost(slot)
  local strenui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "money_bg",
        res = "UI/alpha/1080P/equipupgrade/equipupgrade_goldnum_bg.png"
      },
      layout = {
        position = ccp(795 * self.fixScaleX, 115)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "no_cost",
        text = T("\230\156\170\230\183\187\229\138\160\230\157\144\230\150\153"),
        size = 15
      },
      layout = {
        position = ccp(795 * self.fixScaleX, 115)
      },
      config = {
        stroke = {
          color = ccc3(21, 19, 1),
          size = 1
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "money_icon",
        res = "UI/alpha/1080P/icon/gold.png"
      },
      layout = {
        position = ccp(756 + 783 * (self.fixScaleX - 1), 115)
      },
      config = {
        fix_size = CCSizeMake(27, 25),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "money",
        text = 0,
        size = 15
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(851 + 783 * (self.fixScaleX - 1), 115)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        },
        visible = false
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "stren",
        res = "UI/alpha/1080P/package/btn_package2.png",
        capInsets = CCRectMake(11, 9, 1, 1)
      },
      layout = {
        position = ccp(795 * self.fixScaleX, 70)
      },
      config = {
        scaleSize = CCSizeMake(120, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "stren_press",
        res = "UI/alpha/1080P/package/btn_package2.png",
        capInsets = CCRectMake(11, 9, 1, 1),
        parent = "stren"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        visible = false,
        scaleSize = CCSizeMake(125, 45)
      }
    },
    {
      t = "Label",
      base = {
        name = "stren_label",
        text = T("\233\153\132\233\173\148"),
        size = 20,
        parent = "stren"
      },
      layout = {
        position = ccp(60, 23)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    }
  }
  local readNode = ed.readnode.create(container, strenui)
  readNode:addNode(ui_info)
  local fsContainer = CCSprite:create()
  strenui.fsContainer = fsContainer
  container:addChild(fsContainer)
  readNode = ed.readnode.create(fsContainer, strenui)
  self.strenui = strenui
  self:refreshFastStrenButton()
end

class.createStrenButton = createStrenButton

local function refreshFastStrenButton(self)
  local ui = self.strenui or {}
  if tolua.isnull(ui.fsContainer) then
    return
  end
  if resource_config.hide_fast_enhance_equip then
    ui.fsContainer:setVisible(false)
  else
    local showvip = ed.playerlimit.getAreaShowvip("Item One-Click-Upgrade")
    if showvip <= ed.player:getvip() then
      ui.fsContainer:setVisible(true)
    else
      ui.fsContainer:setVisible(false)
    end
  end
end

class.refreshFastStrenButton = refreshFastStrenButton

local function initBar(self)
  local slot = self.slot
  local level, exp, mlevel, mexp = self:getEquipLevel(slot)
  self.oriExp = self:getItemExp(slot)
  self.oriLevel = level
  self.targetExp = self.oriExp
  local nl = math.min(level + 1, mlevel)
  local ui = self.barui
  ed.setString(ui.b_lv, res.enhance_level_res[level] or "")
  ed.setString(ui.n_lv, res.enhance_level_res[nl] or "")
  ed.setString(ui.ehc, string.format("%d/%d", exp, mexp))
  ui.bar:setVisible(true)
  if not tolua.isnull(ui.bar) then
    print("exp", exp / mexp)
    ui.bar:setScaleX(exp / mexp * self.barScale)
  end
end

class.initBar = initBar

local function refreshExpBar(self, addition)
  addition = addition or {}
  local count = 0
  local exp = self.oriExp
  local target = math.max(math.min(self.targetExp, self:getTotalExp(self.slot)), 0)
  local ui = self.barui
  local animDuration = addition.animDuration
  local bar = ui.bar
  bar:setVisible(true)
  local isAdd = exp < target
  local dexp = target - exp
  local speed = dexp / 0.2
  
  local function handler(dt)
    exp = isAdd and math.min(target, exp + speed * dt) or math.max(target, exp + speed * dt)
    if isAdd then
      if exp >= target then
        exp = target
        self:removeUpdateHandler("refreshExpBar")
      end
    elseif exp <= target then
      exp = target
      self:removeUpdateHandler("refreshExpBar")
      if exp == self:getItemExp(self.slot) then
        ui.bar:setVisible(true)
      end
    end
    local l, e, ml, me = self:getEquipLevel(self.slot, exp)
    local e = math.floor(e)
    local me = math.floor(me)
    count = count + dt
    print(e, me)
    if l ~= self.oriLevel then
      self.oriLevel = l
      ed.setString(ui.b_lv, res.enhance_level_res[l] or "")
      ed.setString(ui.n_lv, res.enhance_level_res[math.min(l + 1, ml)] or "")
    end
    ed.setString(ui.ehc, string.format("%d/%d", e, me))
    if not tolua.isnull(bar) then
      bar:setScaleX(e / me * self.barScale)
      print(e / me)
    end
    self.oriExp = exp
  end
  
  return handler
end

class.refreshExpBar = refreshExpBar

local function addExp(self, exp, addition)
  self.targetExp = (self.targetExp or self.oriExp) + exp
  self:registerUpdateHandler("refreshExpBar", self:refreshExpBar(addition))
  self:refreshStrenCost()
end

class.addExp = addExp

local function createExpBar(self, slot)
  if not tolua.isnull(self.barContainer) then
    self.barContainer:removeFromParentAndCleanup(true)
    self.barContainer = nil
  end
  if not slot then
    return
  end
  local container = CCSprite:create()
  self.barContainer = container
  container:setCascadeOpacityEnabled(true)
  self.ui.bg:addChild(container)
  local level, exp, mlevel, mexp = self:getEquipLevel(slot)
  self.oriExp = self:getItemExp(slot)
  self.oriLevel = level
  self.targetExp = self.oriExp
  local nl = math.min(level + 1, mlevel)
  local fixY = 438 * (self.fixScaleY - 1)
  local fixX = 783 * (self.fixScaleX - 1)
  local barui = {}
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "bar_bg",
        res = "UI/alpha/1080P/equipupgrade/equipupgrade_progress_bg.png",
        capInsets = CCRectMake(3.5, 3.5, 38, 8.5)
      },
      layout = {
        position = ccp(392.5 * self.fixScaleX, 214.5 + fixY)
      },
      config = {
        scaleSize = CCSizeMake(744.5 + fixX, 14.5)
      }
    },
    {
      t = "Label",
      base = {
        name = "b_lv",
        text = res.enhance_level_res[level] or "",
        fontinfo = "equipstrengthen"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(20 * self.fixScaleX, 235 + fixY)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "n_lv",
        text = res.enhance_level_res[nl] or "",
        fontinfo = "equipstrengthen"
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(765 * self.fixScaleX, 235 + fixY)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "ehc",
        text = string.format("%d/%d", exp, mexp),
        size = 18,
        z = 10
      },
      layout = {
        position = ccp(400 * self.fixScaleX, 214 + fixY)
      },
      config = {
        color = ccc3(255, 252, 231),
        stroke = {
          color = ccc3(57, 36, 21),
          size = 1
        }
      }
    }
  }
  local readNode = ed.readnode.create(container, barui)
  readNode:addNode(ui_info)
  local stencil_res = "UI/alpha/1080P/equipupgrade/equipupgrade_progress_1.png"
  local clippingNode = ed.createClippingNodeOnly(stencil_res, 0.5)
  local sprite = ed.createScale9Sprite("UI/alpha/1080P/equipupgrade/equipupgrade_progress_1.png", CCRectMake(4, 5, 821.5, 5))
  clippingNode:setPosition(21.5, 214.5 + fixY)
  local stencil = clippingNode:getStencil()
  local stencil_size = stencil:getContentSize()
  self.barScale = (742 + fixX) / stencil_size.width
  stencil:setScale(self.barScale)
  sprite:setContentSize(CCSizeMake(742 + fixX, 12))
  stencil:setAnchorPoint(ccp(0, 0.5))
  sprite:setAnchorPoint(ccp(0, 0.5))
  barui.bar = stencil
  stencil:setScaleX(exp / mexp * self.barScale)
  clippingNode:addChild(sprite)
  container:addChild(clippingNode)
  self.barui = barui
end

class.createExpBar = createExpBar

local function initEquipAtt(self)
  local slot = self.slot
  local preAdd = self.preAddAtt
  local att, add = self:getEquipAtt(slot)
  local ui = self.attui
  ed.setString(ui.level, self:getLevelText(slot))
  for k, v in pairs(add) do
    if (preAdd[k] or 0) ~= v then
      for i = 1, #self.attLabelList do
        if k == self.attLabelList[i].key then
          local label = self.attLabelList[i].add
          ed.setString(label, "+" .. v)
          local s = CCScaleTo:create(0.2, 1.2)
          s = CCEaseBackIn:create(s)
          local sb = CCScaleTo:create(0.2, 1)
          sb = CCEaseBackIn:create(sb)
          local seq = CCSequence:createWithTwoActions(s, sb)
          label:runAction(seq)
          self.preAddAtt[k] = v
        end
      end
    end
  end
  self:refreshAttListPos()
end

class.initEquipAtt = initEquipAtt

local function getEquipid(self, slot)
  return self.equips[slot].id
end

class.getEquipid = getEquipid

local function getEquipRow(self, slot)
  local id = self:getEquipid(slot)
  return ed.getDataTable("equip")[id]
end

class.getEquipRow = getEquipRow

local function getEquipName(self, slot)
  local row = self:getEquipRow(slot)
  return row.Name
end

class.getEquipName = getEquipName

local function getEquipLevelExp(self, slot)
  return ed.readequip.getEquipLevelExp(self.hid, slot)
end

class.getEquipLevelExp = getEquipLevelExp

local function getTotalExp(self, slot)
  local le = self:getEquipLevelExp(slot)
  local exp = 0
  for i = 1, #le do
    exp = exp + le[i]
  end
  return exp
end

class.getTotalExp = getTotalExp

local function getEquipLevel(self, slot, exp)
  return ed.readequip.getEquipLevel(self.hid, slot, exp)
end

class.getEquipLevel = getEquipLevel

local function getUnitrmb(self, slot)
  local quality = self:getEquipRow(slot).Quality
  local info = ed.getDataTable("enhancement")
  return info[quality]["One-Click Unit Price"]
end

class.getUnitrmb = getUnitrmb

local function getUnitMoney(self, slot)
  local quality = self:getEquipRow(slot).Quality
  local info = ed.getDataTable("enhancement")
  return info[quality]["Unit Price"]
end

class.getUnitMoney = getUnitMoney

local function getFastStrenCost(self, slot)
  local up = self:getUnitrmb(slot)
  local l, e, ml, me = self:getEquipLevel(slot)
  local et, tl = self:getEquipLevelExp(slot)
  local cost = 0
  cost = cost + up * (me - e)
  for i = l + 2, tl do
    cost = cost + up * et[i]
  end
  return cost
end

class.getFastStrenCost = getFastStrenCost

local function checkMaxLevel(self, slot, exp)
  local l, e, ml, me = self:getEquipLevel(slot, exp)
  if l == ml and e == me then
    return true
  end
  return false
end

class.checkMaxLevel = checkMaxLevel

local function getEquipAtt(self, slot)
  self.att = {}
  self.attAdd = {}
  local att, attAdd = {}, {}
  local id = self:getEquipid(slot)
  att = ed.readequip.getAttList(id)
  local el = self:getEquipLevel(slot)
  attAdd = ed.readequip.getAddAttList(id, el)
  return att, attAdd
end

class.getEquipAtt = getEquipAtt

local function getLevelText(self, slot)
  local level = self:getEquipLevel(slot)
  if level == 0 then
    return T("\230\156\170\233\153\132\233\173\148")
  else
    return res.enhance_level_res[level] or ""
  end
end

class.getLevelText = getLevelText

local function refreshAttListPos(self)
  local ox, oy = 150, 140
  local ox1, ox2 = 340 * self.fixScaleX, 400 * self.fixScaleX
  local list = self.attLabelList
  local y = oy
  for i = 1, #list do
    local x = ox
    local axl, axr
    local pre = list[i].pre
    local att = list[i].att
    local add = list[i].add
    local suf = list[i].suf
    axl = 0
    axr = pre:getContentSize().width / 2
    pre:setPosition(ccp(x, y))
    axl = pre:getContentSize().width / 2
    axr = att:getContentSize().width / 2
    x = x + axl + axr
    att:setPosition(ccp(ox1, y))
    axl = att:getContentSize().width / 2
    axr = add:getContentSize().width / 2
    x = x + axl + axr
    add:setPosition(ccp(ox2, y))
    y = y - att:getContentSize().height - 5
  end
  self.att_draglist:initListHeight(oy - y + 20)
end

class.refreshAttListPos = refreshAttListPos

local function createAttList(self, slot)
  if tolua.isnull(self.att_draglist) then
    local container = self.equipContainer
    local param = {
      cliprect = CCRectMake(130, 0, 500, 175),
      noshade = true,
      container = container,
      zorder = 10
    }
    self.att_draglist = ed.draglist.create(param)
  end
  local res = ed.ui.baseres
  local pre = res.att_pre
  local suffix = res.att_suffix
  local att, add = self:getEquipAtt(slot)
  self.preAddAtt = add
  self.attLabelList = {}
  local attList = ed.ui.baseres.att_name
  for i, v in ipairs(attList) do
    local id = self:getEquipid(slot)
    if 416 == id and "INT" == v then
      att[v] = 1
    end
    if att[v] then
      local k = v
      if 416 == id and "INT" == v then
        v = 0
      else
        v = att[v]
      end
      local lpre = ed.createttf(pre[k], 14)
      lpre:setAnchorPoint(ccp(0, 0.5))
      ed.setLabelColor(lpre, ccc3(255, 252, 231))
      ed.setLabelStroke(lpre, ccc3(57, 36, 21), 1)
      self.att_draglist:addItem(lpre)
      local latt = ed.createttf(v, 14)
      latt:setAnchorPoint(ccp(1, 0.5))
      ed.setLabelColor(latt, ccc3(255, 252, 231))
      ed.setLabelStroke(latt, ccc3(57, 36, 21), 1)
      self.att_draglist:addItem(latt)
      local strSuffix = suffix[k] or ""
      local ladd
      if 0 < (add[k] or 0) then
        ladd = ed.createttf("+" .. add[k] .. strSuffix, 14)
      else
        ladd = ed.createttf("", 14)
      end
      ladd:setAnchorPoint(ccp(1, 0.5))
      ed.setLabelColor(ladd, ccc3(141, 244, 118))
      ed.setLabelStroke(ladd, ccc3(10, 42, 3), 1)
      self.att_draglist:addItem(ladd)
      table.insert(self.attLabelList, {
        key = k,
        pre = lpre,
        att = latt,
        add = ladd
      })
    end
  end
  self:refreshAttListPos()
end

class.createAttList = createAttList

local function createEquipAtt(self, slot)
  if not tolua.isnull(self.attContainer) then
    local ac = self.attContainer
    self.attContainer = nil
    ac:removeFromParentAndCleanup(true)
    self.att_draglist.listLayer:setVisible(false)
  end
  if not slot then
    return
  end
  self:getEquipAtt(slot)
  local name = self:getEquipName(slot)
  local level = self:getEquipLevel(slot)
  local container = CCSprite:create()
  self.attContainer = container
  container:setCascadeOpacityEnabled(true)
  self.ui.bg:addChild(container)
  local ui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "name_bg",
        res = "UI/alpha/1080P/equipupgrade/equipupgrade_name_bg.png"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(270, 405 + 438 * (self.fixScaleY - 1))
      },
      config = {}
    }
  }
  local readNode = ed.readnode.create(container, ui)
  readNode:addNode(ui_info)
  local richText = richText:new()
  richText:setString(string.format("<text|hint_text|%s(><text|equipstrengthen|%s><text|hint_text|)>", name, self:getLevelText(slot)))
  richText:setPosition(ccp(298, 405 + 438 * (self.fixScaleY - 1)))
  container:addChild(richText.rootNode)
  self:createAttList(slot)
  self.attui = ui
end

class.createEquipAtt = createEquipAtt

local function initHeroEquip(self)
  local slot = self.slot
  local stars = self.equips[slot].stars
  ed.readequip.refreshHeroItemStar(self.hid, slot, stars)
  self:playEnhanceAnim(slot)
end

class.initHeroEquip = initHeroEquip

local function playStarAnim(self, stars, index, eof, isdelay)
  if eof < index then
    return
  end
  local star = stars[index].icon
  star:stopAllActions()
  local osc = star:getScale()
  local a = CCArray:create()
  local delay = CCDelayTime:create(0.5)
  local f1 = CCCallFunc:create(function()
    xpcall(function()
      star:setVisible(true)
      star:setScale(2)
    end, EDDebug)
  end)
  local sl = CCScaleTo:create(0.2, osc)
  sl = CCEaseBackIn:create(sl)
  local f2 = CCCallFunc:create(function()
    xpcall(function()
      self:playStarAnim(stars, index + 1, eof)
    end, EDDebug)
  end)
  if isdelay then
    a:addObject(delay)
  end
  a:addObject(f1)
  a:addObject(sl)
  a:addObject(f2)
  local s = CCSequence:create(a)
  star:runAction(s)
end

class.playStarAnim = playStarAnim

local function playEnhanceAnim(self, slot)
  local hid = self.hid
  local equip = self.equips[slot]
  local icon = equip.icon
  local stars = equip.stars
  local level = equip.level
  local nl = ed.readequip.getEquipLevel(hid, slot)
  equip.level = nl
  if level < nl then
    local size = icon:getContentSize()
    local node = ed.createFcaNode("eff_UI_enhance_success")
    node:setScale(1.8)
    node:setPosition(ccp(size.width / 2, size.height / 2))
    icon:addChild(node)
    self:addFca(node)
  end
  for i = level + 1, nl do
    local s = stars[i]
    s.icon:setVisible(false)
  end
  self:playStarAnim(stars, level + 1, nl, true)
end

class.playEnhanceAnim = playEnhanceAnim

local function getEquipPos(self, i)
  local ox, oy = 39, 158
  local dx, dy = 60, 60
  local iy = (i - 1) % 3
  local ix = math.floor((i - 1) / 3)
  local x = ox + dx * ix
  local y = oy - dy * iy
  return ccp(x, y)
end

class.getEquipPos = getEquipPos

local function createEquip(self, skipAnim, isEmpty)
  if not tolua.isnull(self.equipContainer) then
    self.equipContainer:removeFromParentAndCleanup(true)
    self.equipContainer = nil
    self.equips = nil
  end
  local container = ed.createScale9Sprite("UI/alpha/1080P/equipupgrade/equipupgrade_item_info_bg.png")
  container:setPosition(ccp(359 + (420 * self.fixScaleX - 420) / 2, 438 * self.fixScaleY - 108))
  container:setContentSize(CCSizeMake(420 * self.fixScaleX, 195))
  self.equipContainer = container
  container:setCascadeOpacityEnabled(true)
  self.ui.bg:addChild(container)
  if not isEmpty then
    self.equips = {}
  end
  local count = 0
  local maxQuality = 0
  local firstNotMaxIdx = 0
  for i = 1, 6 do
    local icon, eIcon, stars
    if isEmpty then
      icon = ed.createSprite("UI/alpha/1080P/common/frame/gocha.png")
    else
      local id = self:getItemid(i)
      if 0 < id then
        icon, eIcon, stars = ed.readequip.createESHeroItem(self.hid, i)
        local level = ed.readequip.getEquipLevel(self.hid, i)
        self.equips[i] = {
          icon = icon,
          eIcon = eIcon,
          stars = stars,
          id = id,
          has = true,
          level = level
        }
        count = count + 1
        maxQuality = math.max(maxQuality, ed.readequip.quality(id))
        if not self:checkMaxLevel(i) and firstNotMaxIdx == 0 then
          firstNotMaxIdx = i
        end
      else
        icon = ed.createSprite("UI/alpha/1080P/common/frame/gocha.png")
        self.equips[i] = {
          icon = icon,
          eIcon = nil,
          id = nil,
          has = false
        }
      end
      local pos = self:getEquipPos(i)
      icon:setScale(0.7)
      icon:setPosition(pos)
      container:addChild(icon)
      if 0 < id and 1 < ed.readequip.quality(id) and not self:checkMaxLevel(i) and ed.readequip.quality(id) then
        self.EEclickEquipid = i
      end
    end
  end
  if not skipAnim and not isEmpty then
    container:setOpacity(0)
    local fade = CCFadeTo:create(0.2, 255)
    container:runAction(fade)
  end
  return count, maxQuality, firstNotMaxIdx
end

class.createEquip = createEquip

local function selectEquip(self, slot)
  if not self.equips then
    return
  end
  if slot then
    local el, ml = self:getEquipLevelExp(slot)
    if ml == 0 then
      self:doSpeak(T("\229\143\170\230\156\137\231\187\191\232\137\178\229\143\138\228\187\165\228\184\138\229\147\129\232\180\168\231\154\132\232\163\133\229\164\135\230\137\141\229\143\175\228\187\165\233\153\132\233\173\148\227\128\130"))
      return
    end
  end
  local heroChange
  if not self.slot then
    self.slot = slot
    heroChange = true
  elseif self.slot == slot then
  else
    self.slot = slot
  end
  self:doSelectSlot(slot, heroChange)
  if self:checkMaxLevel(slot) then
    self:doTalk(T("\229\183\178\233\153\132\233\173\148\232\135\179\233\161\182\231\186\167"))
  else
    self:doTalk(T("\232\175\183\230\183\187\229\138\160\230\157\144\230\150\153\239\188\140\230\137\128\230\156\137\232\163\133\229\164\135\233\131\189\229\143\175\228\187\165\231\148\168\229\147\166"))
  end
  for i = 1, 6 do
    local icon = self.equips[i].icon
    local has = self.equips[i].has
    icon:stopAllActions()
    local fade
    if slot == i then
      fade = CCFadeTo:create(0.2, 255)
    else
      fade = CCFadeTo:create(0.2, 75)
    end
    if fade then
      icon:runAction(fade)
    end
  end
end

class.selectEquip = selectEquip

local function getItemid(self, slot)
  local hero = self:getHero()
  if not hero then
    return 0
  end
  local id = hero._items[slot]._item_id or 0
  return id
end

class.getItemid = getItemid

local function getItemExp(self, slot)
  local hero = self:getHero()
  if not hero then
    return 0
  end
  local exp = hero._items[slot]._exp or 0
  return exp
end

class.getItemExp = getItemExp

local function getEquipid(self, i)
  local hero = self:getHero()
  local hid = self.hid
  local rank = hero._rank
  local items = hero._items[i]
  if not items then
    print("the slot has no item")
    return
  end
  local eid = items._item_id
  return eid
end

class.getEquipid = getEquipid

local function getHero(self)
  if not self.hid then
    return nil
  end
  return ed.player.heroes[self.hid]
end

class.getHero = getHero

local function getHeroIndex(self)
  if not self.currentHeroList then
    return
  end
  for idx, hid in ipairs(self.currentHeroList) do
    if hid == self.hid then
      return idx
    end
  end
end

class.getHeroIndex = getHeroIndex

local function doChangeHero(self)
  ed.endTeach("EEclickHero")
  self:saveDraglistPos()
  local composeWin = ed.ui.chooseheroWin.create({
    name = "hero",
    signName = "equip",
    callback = self:setHeroIcon(),
    hasClassifyPart = true
  })
  composeWin:popWindow(500)
end

class.doChangeHero = doChangeHero

local function setHeroIcon(self)
  local function handler(tid)
    if not self.hid then
      local ui = self.ui
      
      local label = ui.select_hero_label
      ed.setString(label, T("\229\136\135\230\141\162\232\139\177\233\155\132"))
    end
    if not self.currentHeroList then
      local list = {}
      local hl = ed.orderHeroes() or {}
      for i, v in ipairs(hl) do
        table.insert(list, v._tid)
      end
      self.currentHeroList = list
      self:createArrowButton()
    end
    self:initMaterialData()
    self.hid = tid
    print("tid", tid)
    self:updateHeroIconUI()
  end
  
  return handler
end

class.setHeroIcon = setHeroIcon

local function updateHeroIconUI(self)
  local pos = ccp(self.ui.heroIcon:getPosition())
  self.ui.heroIcon:removeFromParentAndCleanup(true)
  local icon = ed.readhero.createIconByID(self.hid).icon
  icon:setPosition(pos)
  self.ui.bg:addChild(icon)
  self.ui.heroIcon = icon
  self.ui.label_noselected:setVisible(false)
  local name = ed.readhero.createHeroName(self.hid)
  name:setAnchorPoint(ccp(0.5, 0.5))
  name:setPosition(ccp(33, 100))
  icon:addChild(name)
  self.ui.heroName = name
  local count, mq, fnmi = self:createEquip()
  local talk = T("\232\175\183\233\128\137\230\139\169\232\163\133\229\164\135")
  if count <= 0 then
    talk = T("\232\191\153\228\184\170\232\139\177\233\155\132\230\178\161\230\156\137\231\169\191\232\163\133\229\164\135\239\188\140\232\175\183\233\135\141\230\150\176\233\128\137\230\139\169\232\139\177\233\155\132")
  elseif mq <= 1 then
    talk = T("\232\191\153\228\184\170\232\139\177\233\155\132\232\186\171\228\184\138\230\178\161\230\156\137\229\143\175\229\188\186\229\140\150\231\154\132\232\163\133\229\164\135\239\188\140\232\175\183\233\135\141\230\150\176\233\128\137\230\139\169\232\139\177\233\155\132")
  elseif fnmi == 0 then
    talk = T("\232\191\153\228\184\170\232\139\177\233\155\132\230\137\128\230\156\137\232\163\133\229\164\135\233\131\189\229\183\178\229\188\186\229\140\150\229\136\176\230\187\161\231\186\167\239\188\140\232\175\183\233\135\141\230\150\176\233\128\137\230\139\169\232\139\177\233\155\132")
  end
  self:doTalk(talk)
  if 0 < fnmi then
    self:doClickEquip(fnmi)
    if not self.isSelectHero then
    else
      self:createMaterialLayer()
    end
  else
    self:doSelectSlot()
  end
end

class.updateHeroIconUI = updateHeroIconUI

local function doClickEquip(self, i)
  if i == (self.EEclickEquipid or 0) then
    ed.endTeach("EEclickEquip")
  end
  self:saveDraglistPos()
  self:selectEquip(i)
end

class.doClickEquip = doClickEquip

local function doEquipTouch(self)
  local id
  
  local function handler(event, x, y)
    if not self.equips then
      return
    end
    if event == "began" then
      for i = 1, 6 do
        local equip = self.equips[i]
        if ed.containsPoint(equip.icon, x, y) then
          if not equip.has then
            return
          end
          id = i
          equip.icon:setScale(0.65)
        end
      end
    elseif event == "ended" then
      if id then
        local equip = self.equips[id]
        equip.icon:setScale(0.7)
        if ed.containsPoint(equip.icon, x, y) then
          lsr:report("clickEquip")
          self:doClickEquip(id)
        end
      end
      id = nil
    end
  end
  
  return handler
end

class.doEquipTouch = doEquipTouch

local function doHeroTouch(self)
  local isPress
  
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(self.ui.heroIcon, x, y) then
        isPress = true
      end
    elseif event == "ended" then
      if isPress and ed.containsPoint(self.ui.heroIcon, x, y) then
        lsr:report("clickHeroHead")
        self:doChangeHero()
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doHeroTouch = doHeroTouch

local function doSelectHeroTouch(self)
  local isPress
  local normal = self.ui.select_hero
  
  local function handler(event, x, y)
    if event == "began" then
      if ed.containsPoint(normal, x, y) then
        isPress = true
        normal:setScale(0.95)
      end
    elseif event == "ended" then
      if isPress and ed.containsPoint(normal, x, y) then
        lsr:report("clickSelectHero")
        self:doChangeHero()
        normal:setScale(1)
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doSelectHeroTouch = doSelectHeroTouch

local function doClickBack(self)
  ed.popScene()
end

class.doClickBack = doClickBack

local function doBackTouch(self)
  local isPress
  local button = self.ui.back
  local press = self.ui.back_press
  
  local function handler(event, x, y)
    if not button:isVisible() then
      return
    end
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          lsr:report("clickBack")
          self:doClickBack()
        end
      end
      isPress = nil
    end
  end
  
  return handler
end

class.doBackTouch = doBackTouch

local function doMainLayerTouch(self)
  local heroTouch = self:doHeroTouch()
  local backTouch = self:doBackTouch()
  local equipTouch = self:doEquipTouch()
  local selectHeroTouch = self:doSelectHeroTouch()
  local mbTouch = self:dombTouch()
  local strenTouch = self:doStrenTouch()
  local fastStrenTouch = self:doFastStrenTouch()
  
  local function handler(event, x, y)
    xpcall(function()
      heroTouch(event, x, y)
      equipTouch(event, x, y)
      selectHeroTouch(event, x, y)
      mbTouch(event, x, y)
      strenTouch(event, x, y)
      fastStrenTouch(event, x, y)
    end, EDDebug)
    return true
  end
  
  return handler
end

class.doMainLayerTouch = doMainLayerTouch

local function doShowMaxLevel(self)
  local slot = self.slot
  self:doShowmbPrompt(slot)
  self:setMaterialLayerVisible(false)
  local ui = self.strenui
  ui.money_icon:setVisible(false)
  ui.money:setVisible(false)
  ui.no_cost:setVisible(true)
  ed.setString(ui.no_cost, T("\229\183\178\233\153\132\233\173\148\229\136\176\233\161\182\231\186\167"))
  ed.setString(ui.no_fastcost, T("\229\183\178\233\153\132\233\173\148\229\136\176\233\161\182\231\186\167"))
  local ui = self.barui
  ui.b_lv:setVisible(false)
  ui.n_lv:setVisible(false)
  ed.setString(ui.ehc, T("\229\183\178\233\153\132\233\173\148\232\135\179\233\161\182\231\186\167"))
end

class.doShowMaxLevel = doShowMaxLevel

local function doSelectSlot(self, slot, heroChange)
  self.slot = slot
  local hc = heroChange
  if slot then
    self:createEquipAtt(slot)
    self:createExpBar(slot)
    self:createStrenButton(slot)
    self:initMaterialLayer()
    if hc then
      self:doShowmbPrompt(slot)
    elseif self.isSelectHero then
      self.ui.material_label:setVisible(false)
      self.ui.btn_material:setVisible(false)
    end
    if self:checkMaxLevel(slot) then
      self:doShowMaxLevel()
    end
  else
    self:createEquipAtt()
    self:createExpBar()
    self:doShowmbPrompt()
    self:createStrenButton()
  end
end

class.doSelectSlot = doSelectSlot

local function doShowmbPrompt(self, slot)
  if slot then
    self.ui.material_bg:setVisible(true)
    self.ui.bottom_bg:setVisible(false)
    self.ui.material_label:setVisible(true)
    self.ui.btn_material:setVisible(true)
    if self:checkMaxLevel(slot) then
      ed.setString(self.ui.material_label, T("\229\183\178\233\153\132\233\173\148\229\136\176\233\161\182\231\186\167"))
    else
      ed.setString(self.ui.material_label, T("\231\130\185\229\135\187\230\173\164\229\164\132\230\137\147\229\188\128\232\131\140\229\140\133\n\228\189\160\229\143\175\228\187\165\228\189\191\231\148\168\228\187\187\228\189\149\232\163\133\229\164\135\230\157\165\233\153\132\233\173\148"))
    end
  else
    self.ui.material_bg:setVisible(false)
    self.ui.bottom_bg:setVisible(true)
    self.ui.material_label:setVisible(false)
    self.ui.btn_material:setVisible(false)
  end
end

class.doShowmbPrompt = doShowmbPrompt

local function saveDraglistPos(self)
  if self.draglist then
    self.draglistPos = ccp(self.draglist:getListPos())
  end
end

class.saveDraglistPos = saveDraglistPos

local function createArrowButton(self)
  local container = self.container
  local ui = self.ui
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "left_arrow",
        res = "UI/alpha/1080P/common/herodetail_arrow_left.png",
        z = 16
      },
      layout = {
        position = ccp(38, ed.display.winSize.height / 2)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "right_arrow",
        res = "UI/alpha/1080P/common/herodetail_arrow_right.png",
        z = 16
      },
      layout = {
        position = ccp(ed.display.winSize.width - 38, ed.display.winSize.height / 2)
      },
      config = {}
    }
  }
  readnode:addNode(ui_info)
  for k, v in ipairs({
    ui.left_arrow,
    ui.right_arrow
  }) do
    local fo = CCFadeOut:create(1)
    local fi = CCFadeIn:create(1)
    local s = ed.readaction.create({
      t = "seq",
      fo,
      fi
    })
    v:runAction(CCRepeatForever:create(s))
  end
  print("createArrowButton")
  self:btRegisterRectClick({
    rect = CCRectMake(12, ed.display.winSize.height / 2 - 20, 55, 69),
    pressHandler = function()
      ui.left_arrow:setScale(0.95)
    end,
    cancelPressHandler = function()
      ui.left_arrow:setScale(1)
    end,
    clickHandler = function()
      self:turnPrePage()
    end,
    key = "left_arrow_button"
  })
  self:btRegisterRectClick({
    rect = CCRectMake(ed.display.winSize.width - 74, ed.display.winSize.height / 2 - 20, 55, 69),
    pressHandler = function()
      ui.right_arrow:setScale(0.95)
    end,
    cancelPressHandler = function()
      ui.right_arrow:setScale(1)
    end,
    clickHandler = function()
      self:turnNextPage()
    end,
    key = "right_arrow_button"
  })
end

class.createArrowButton = createArrowButton

local function turnPrePage(self)
  local index = self:getHeroIndex()
  if index then
    index = index - 1
    if index < 1 then
      index = #self.currentHeroList
    end
    self.hid = self.currentHeroList[index]
    self:updateHeroIconUI()
  end
end

class.turnPrePage = turnPrePage

local function turnNextPage(self)
  local index = self:getHeroIndex()
  print("turnNextPage")
  if index then
    index = index + 1
    if index > #self.currentHeroList then
      index = 1
    end
    self.hid = self.currentHeroList[index]
    self:updateHeroIconUI()
  end
end

class.turnNextPage = turnNextPage

local function create()
  local self = base.create("equipStrengthen", {noBottomButton = true})
  setmetatable(self, class.mt)
  local mainLayer = CCLayer:create()
  self.mainLayer = mainLayer
  self.scene:addChild(mainLayer)
  local container = CCLayer:create()
  self.container = container
  mainLayer:addChild(container)
  local fixScaleX = ed.display.winSize.width / 960
  local fixScaleY = ed.display.winSize.height / 540
  self.fixScaleX = fixScaleX
  self.fixScaleY = fixScaleY
  self.ui = {}
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/1080P/package/bg_normal.png",
        capInsets = CCRectMake(50, 200, 25, 250)
      },
      layout = {
        position = ccp(ed.display.winSize.width / 2, 242 * fixScaleY)
      },
      config = {
        scaleSize = CCSizeMake(783 * fixScaleX, 438 * fixScaleY)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "frame",
        res = "UI/alpha/1080P/battle/battle_prepare_9bg_big.png",
        capInsets = CCRectMake(240, 100, 1, 100),
        parent = "bg"
      },
      layout = {
        position = ccp(783 * fixScaleX / 2, 220 * fixScaleY)
      },
      config = {
        scaleSize = CCSizeMake(788 * fixScaleX, 443 * fixScaleY)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "heroIcon",
        res = "UI/alpha/1080P/common/frame/hero_icon_bg.png",
        parent = "bg"
      },
      layout = {
        position = ccp(80, 438 * fixScaleY - 95)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "heroIconFrame",
        res = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
        parent = "heroIcon"
      },
      layout = {
        position = ccp(45, 45)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "heroIconMask",
        res = "UI/alpha/1080P/equipupgrade/equipupgrade_hero_mark.png",
        parent = "heroIcon"
      },
      layout = {
        position = ccp(45, 45)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "select_hero",
        res = "UI/alpha/1080P/package/btn_package2.png",
        capInsets = CCRectMake(11, 0, 1, 1),
        parent = "bg"
      },
      layout = {
        position = ccp(80, 438 * fixScaleY - 165)
      },
      config = {
        scaleSize = CCSizeMake(100, 39)
      }
    },
    {
      t = "Label",
      base = {
        name = "select_hero_label",
        text = T("\233\128\137\230\139\169\232\139\177\233\155\132"),
        size = 16,
        parent = "select_hero"
      },
      layout = {
        position = ccp(50, 20)
      },
      config = {
        color = ccc3(254, 241, 169)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "material_bg",
        res = "UI/alpha/1080P/equipupgrade/equipupgrade_material_bg.png",
        capInsets = CCRectMake(10, 10, 1, 1),
        parent = "bg"
      },
      layout = {
        position = ccp(327.5 * fixScaleX, 102.5 + (438 * fixScaleY - 438) / 2)
      },
      config = {
        scaleSize = CCSizeMake(620 * fixScaleX, 175 + 438 * fixScaleY - 438)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "bottom_bg",
        res = "UI/alpha/1080P/equipupgrade/equipupgrade_material_bg.png",
        capInsets = CCRectMake(10, 10, 1, 1),
        parent = "bg"
      },
      layout = {
        position = ccp(783 * fixScaleX / 2, 102.5 + (438 * fixScaleY - 438) / 2)
      },
      config = {
        scaleSize = CCSizeMake(750 * fixScaleX, 175 + 438 * fixScaleY - 438)
      }
    },
    {
      t = "Label",
      base = {
        name = "label_noselected",
        text = T("\230\173\164\229\164\132\232\191\152\230\178\161\230\156\137\228\187\187\228\189\149\230\157\144\230\150\153\239\188\140\233\156\128\232\166\129\233\128\137\230\139\169\232\139\177\233\155\132\229\144\142\230\137\141\230\156\137\229\147\166"),
        size = 18,
        parent = "bottom_bg"
      },
      layout = {
        position = ccp(750 * fixScaleX / 2, (175 + 438 * fixScaleY - 438) / 2)
      },
      config = {
        color = ccc3(255, 251, 231)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "btn_material",
        res = "UI/alpha/1080P/equipupgrade/equipupgrade_openbag_bg.png",
        capInsets = CCRectMake(10, 10, 1, 1),
        parent = "material_bg"
      },
      layout = {
        position = ccp(310 * fixScaleX, (175 + 438 * fixScaleY - 438) / 2)
      },
      config = {
        scaleSize = CCSizeMake(310, 92.5)
      }
    },
    {
      t = "Label",
      base = {
        name = "material_label",
        text = T("\231\130\185\229\135\187\230\173\164\229\164\132\230\137\147\229\188\128\232\131\140\229\140\133\n\228\189\160\229\143\175\228\187\165\228\189\191\231\148\168\228\187\187\228\189\149\232\163\133\229\164\135\230\157\165\233\153\132\233\173\148"),
        size = 22,
        z = 1,
        parent = "material_bg"
      },
      layout = {
        position = ccp(310 * fixScaleX, (175 + 438 * fixScaleY - 438) / 2)
      },
      config = {
        color = ccc3(254, 241, 169)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "deco",
        res = "UI/alpha/1080P/battle/battle_prepare_fa_3.png",
        parent = "bg",
        z = 2
      },
      layout = {
        position = ccp(493 * fixScaleX, 438 * fixScaleY - 79)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "npc",
        res = "UI/alpha/1080P/equipupgrade/equipupgrade_npc_frame.png",
        parent = "bg",
        z = 2
      },
      layout = {
        position = ccp(693 * fixScaleX, 438 * fixScaleY - 79)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "npc_head",
        res = "UI/alpha/1080P/equipupgrade/equipupgrade_npc_head.png",
        parent = "npc",
        z = 2
      },
      layout = {
        position = ccp(83, 89)
      },
      config = {}
    }
  }
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
  self:setBackButton()
  self:setBackground("UI/alpha/1080P/bg/herolist_bg.png")
  local title = ed.createttf(T("\232\163\133\229\164\135\233\153\132\233\173\148"))
  ed.setLabelColor(title, ed.toccc3(16711642))
  ed.setLabelStroke(title, ed.toccc3(13794820), 1)
  self.container:addChild(title)
  ed.layout.layoutWithMagin(title, {top = 15, left = 90})
  self.pressId = 0
  self:createEquip(nil, true)
  self:doSelectSlot()
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, 0, false)
  self:doTalk(T("\232\175\183\233\128\137\230\139\169\232\139\177\233\155\132"))
  ed.player:recoverSuperTaskEquip()
  return self
end

class.create = create

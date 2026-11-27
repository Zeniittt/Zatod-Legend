module("ed.battleprepare", package.seeall)
Buttom = {}
Buttom.__index = Buttom

function Buttom:create(uiview)
  local obj = {}
  setmetatable(obj, self)
  obj:init(uiview)
  return obj
end

local buttomScope = {}

function Buttom:release()
  self.layer:removeFromParentAndCleanup(true)
  self.layer = nil
  self.ui = {}
  self.heros = {}
  CloseScope()
end

function Buttom:init(uiview)
  self.layer = CCLayer:create()
  self.ui = {}
  self.heros = {}
  self.lockedHeroList = {}
  self.uiview = uiview
  self.moving = false
  self.controller = uiview:getController()
  local controller = uiview:getController()
  self.maxNum = controller:getModel():getMaxNum()
  self.isLockedMove = controller:getModel():isLockedMove()
  self.teamNum = 0
  local readNode = ed.readnode.create(self.layer, self.ui)
  readNode:addNode(self:getUiInfo())
  self.auraHint = ed.AuraHint.create()
  self:createDragList()
  self:initDragList()
  self:registerWaitEvent()
end

function Buttom:addChild(node, z)
  self.layer:addChild(node, z or 0)
end

function Buttom:registerWaitEvent()
  WaitEvent("addHeroWithId", function(hid, pos, index, notAnim)
    if self:isVisible() then
      self:addHero(hid, pos, index, notAnim)
    end
  end)
  WaitEvent("removeHeroWithId", function(hid, pos, index, notAnim)
    if self:isVisible() then
      self:removeHero(hid, pos, index, notAnim)
    end
  end)
  WaitEvent("addMercenaryWithId", function(hid, pos, index)
    if self:isVisible() then
      self:addMercenary(hid, pos, index)
    end
  end)
  WaitEvent("removeMercenaryWithId", function(hid, pos, index)
    if self:isVisible() then
      self:removeMercenary(hid, pos, index)
    end
  end)
  WaitEvent("teamIsFull", function()
    if self:isVisible() then
      self:teamFull()
    end
  end)
  WaitEvent("clearAllSelectHero", function()
    for index, node in pairs(self.lockedHeroList) do
      local icon = node.bg
      icon:removeFromParentAndCleanup(true)
    end
    self.lockedHeroList = {}
  end)
end

function Buttom:getTeamMemberPos(index)
  local ox, oy = 605, 86
  local dx = 106
  return ccp(ox - dx * (index - 1), oy)
end

function Buttom:isMove()
  return self.moving
end

function Buttom:setMove(move)
  self.moving = move
end

function Buttom:setLabelTitle(title)
  ed.setString(self.ui.hero_num_title, title)
end

function Buttom:setLabelContent(content)
  ed.setString(self.ui.hero_num, content)
end

function Buttom:getView()
  return self.layer
end

function Buttom:removeScrollHero(hid, tpos, notAnim)
  local b = 0
  for k = 1, self.maxNum do
    local icon = self.heros[k]
    if icon.hid == hid then
      b = k
      break
    end
  end
  if b == 0 then
    return
  end
  local node = self.heros[b]
  if self.draglist:isNodeOutOfClipRect(node.bg) then
    self:confirmIconIsVisible(b, tpos)
  else
    self:moveOtherIcon(b, tpos)
  end
end

function Buttom:removeLockHero(hid, tpos, index, notAnim)
  if not index then
    self:setMove(false)
    return
  end
  local icon = self.lockedHeroList[index].bg
  local x, y = icon:getPosition()
  icon:removeFromParentAndCleanup(true)
  if self.auraHint then
    self.auraHint:RemoveAura(hid)
  end
  table.remove(self.lockedHeroList, index)
  for k = index, #self.lockedHeroList do
    local icon = self.lockedHeroList[k].bg
    local pos = self:getTeamMemberPos(k)
    Action:moveNodeTo(icon, pos)
  end
  
  local function callback()
    self:setMove(false)
  end
  
  if notAnim then
    callback()
  else
    local tpos = ccp((tpos.x + x) / 2, (tpos.y + y) / 2)
    Action:createHeroAndMoveTo(self.layer, hid, ccp(x, y), tpos, callback)
  end
end

function Buttom:removeHero(hid, tpos, index, notAnim)
  self:setMove(true)
  if self.isLockedMove then
    self:removeLockHero(hid, tpos, index, notAnim)
  else
    self:removeScrollHero(hid, tpos, notAnim)
  end
end

function Buttom:removeMercenaryHero(hid, tpos, index, notAnim)
  if not index then
    self:setMove(false)
    return
  end
  local hero = self.controller.mercenaryMode:getHero(hid)
  local icon = self.lockedHeroList[index].bg
  local x, y = icon:getPosition()
  icon:removeFromParentAndCleanup(true)
  if self.auraHint then
    self.auraHint:RemoveAura(hero._tid)
  end
  table.remove(self.lockedHeroList, index)
  for k = index, #self.lockedHeroList do
    local icon = self.lockedHeroList[k].bg
    local pos = self:getTeamMemberPos(k)
    Action:moveNodeTo(icon, pos)
  end
  
  local function callback()
    self:setMove(false)
  end
  
  if notAnim then
    callback()
  else
    local tpos = ccp((tpos.x + x) / 2, (tpos.y + y) / 2)
    Action:createHeroAndMoveTo(self.layer, hero._tid, ccp(x, y), tpos, callback)
  end
end

function Buttom:removeMercenary(hid, tpos, index)
  self:setMove(true)
  self:removeMercenaryHero(hid, tpos, index)
end

function Buttom:confirmIconIsVisible(index, tpos)
  local node = self.heros[index]
  local pos = self.draglist:getItemWorldPos(ccp(node.bg:getPosition()))
  local cliprect = self.draglist.cliprect
  local distance = math.min(math.abs(pos.x - cliprect.origin.x), math.abs(pos.x - (cliprect.origin.x + cliprect.size.width)))
  
  local function callback()
    self:moveOtherIcon(index, tpos)
  end
  
  local tpx, tpy = self.draglist.listLayer:getPosition()
  if pos.x < cliprect.origin.x then
    tpx = tpx + distance + 7 + node.bg:getContentSize().width / 2
  elseif pos.x > cliprect.origin.x + cliprect.size.width then
    tpx = tpx - distance - 7 - node.bg:getContentSize().width / 2
  end
  self.draglist.listLayer:setPosition(ccp(tpx, tpy))
  callback()
end

function Buttom:moveOtherIcon(b, tpos)
  local offset = 7
  local _, _, bgWidth, _ = self:getHeroIconBg()
  if b == self.maxNum then
    self:moveAction(b, tpos)
  else
    local offset = 7
    for i = b + 1, self.maxNum do
      local icon = self.heros[i].bg
      local pos = ccp(bgWidth / 2 + (bgWidth + offset) * (i - 2), 20)
      
      local function callback()
        if i == self.maxNum then
          self:moveAction(b, tpos)
        end
      end
      
      Action:moveNodeTo(icon, pos, callback)
    end
  end
end

function Buttom:moveAction(index, tpos)
  local offset = 7
  local node = self.heros[index]
  local hid = node.hid
  local pos = self.draglist:getItemWorldPos(ccp(node.bg:getPosition()))
  node.bg:removeFromParentAndCleanup(true)
  
  local function callback()
    local _, _, bgWidth, _ = self:getHeroIconBg()
    table.remove(self.heros, index)
    self:addList(self.maxNum)
    self.teamNum = self.teamNum - 1
    self.draglist:initListWidth(bgWidth * self.teamNum + offset * self.teamNum, false)
    self:setMove(false)
  end
  
  local tpos = ccp((tpos.x + pos.x) / 2, (tpos.y + pos.y) / 2)
  Action:createHeroAndMoveTo(self.layer, hid, pos, tpos, callback)
end

function Buttom:teamFull()
  for k = 1, self.maxNum do
    local light = self.heros[k].light
    Action:showLight(light)
  end
end

function Buttom:add2Team(icon, hid, pos)
  local function callback()
    local node = ed.readhero.createIconByID(hid, {state = "idle"})
    
    local _, _, bgWidth, bgHeight = self:getHeroIconBg()
    node.icon:setPosition(bgWidth * 0.5, bgHeight * 0.6)
    icon.bg:addChild(node.icon)
    Action:showLight(icon.light)
    self:setMove(false)
  end
  
  local tpos = self.draglist:getItemWorldPos(ccp(icon.bg:getPosition()))
  Action:createHeroAndMoveTo(self.layer, hid, pos, tpos, callback)
end

function Buttom:addLockHero(hid, pos, index, notAnim)
  for k = index, #self.lockedHeroList do
    local icon = self.lockedHeroList[k].bg
    local pos = self:getTeamMemberPos(k + 1)
    Action:moveNodeTo(icon, pos)
  end
  local tpos = self:getTeamMemberPos(index)
  
  local function callback()
    local node = ed.readhero.createIconByID(hid, {
      state = "idle",
      mealMode = self.uiview.SystemType
    })
    node.icon:setPosition(tpos)
    local temp = {
      bg = node.icon,
      hid = hid
    }
    table.insert(self.lockedHeroList, index, temp)
    self.layer:addChild(node.icon, 30)
    local icon = self.heros[self.maxNum - index + 1]
    Action:showLight(icon.light)
    self:setMove(false)
    self:showAwakeAura(hid, index, node)
  end
  
  if notAnim then
    callback()
  else
    Action:createHeroAndMoveTo(self.layer, hid, pos, tpos, callback)
  end
end

function Buttom:showAwakeAura(hid, index, node)
  self.auraHint:AddAura(hid, index, node.info.awake)
  local flag_impact = self.auraHint:CheckAuraImpactAll(hid)
  if flag_impact then
    local team = {}
    for k = index, #self.lockedHeroList do
      local node = self.lockedHeroList[k].bg
      local id = self.lockedHeroList[k].hid
      local member = {node = node, id = id}
      table.insert(team, member)
    end
    ListenTimer(Timer:Once(0.2), function()
      self.auraHint:Reset()
      self.auraHint:AddMemberHintWithNodeAndId(node.icon, hid)
      self.auraHint:AddTeamHintWithNodeAndIdByHero(team, hid)
      self.auraHint:Play()
    end, buttomScope)
  end
end

function Buttom:addScrollHero(hid, pos)
  local _, _, bgWidth, bgHeight = self:getHeroIconBg()
  local offset = 7
  local moveNum = 5
  if self.maxNum == 15 then
    moveNum = 4
  end
  if self.teamNum < self.maxNum then
    self.teamNum = self.teamNum + 1
    local k = self.teamNum
    local icon = self.heros[k]
    if not icon.hid then
      icon.hid = hid
      if moveNum < k and k ~= self.maxNum then
        local callback = CCCallFunc:create(function()
          ListenTimer(Timer:Once(0.1), function()
            self:add2Team(icon, hid, pos)
          end)
        end)
        local action = CCMoveTo:create(0.1, ccp(130 - (bgWidth + offset) * (k - moveNum), self.draglist.listLayer:getPositionY()))
        action = CCEaseSineOut:create(action)
        self.draglist.listLayer:stopAllActions()
        self.draglist.listLayer:runAction(ed.readaction.create({
          t = "sp",
          action,
          callback
        }))
      else
        self:add2Team(icon, hid, pos)
      end
      if 5 < self.maxNum then
        self.draglist:initListWidth(bgWidth * k + offset * (k - 1), false)
      end
      return
    end
  end
end

function Buttom:addHero(hid, pos, index, notAnim)
  if not index then
    return
  end
  self:setMove(true)
  if self.isLockedMove then
    self:addLockHero(hid, pos, index, notAnim)
  else
    self:addScrollHero(hid, pos)
  end
end

function Buttom:addMercenaryHero(hid, pos, index)
  for k = index, #self.lockedHeroList do
    local icon = self.lockedHeroList[k].bg
    local pos = self:getTeamMemberPos(k + 1)
    Action:moveNodeTo(icon, pos)
  end
  local tpos = self:getTeamMemberPos(index)
  local hero = self.controller.mercenaryMode:getHero(hid)
  
  local function callback()
    local node = ed.readhero.createIconByHero(hero)
    node.icon:setPosition(tpos)
    local temp = {
      bg = node.icon,
      hid = hero._tid,
      isMercenary = true,
      mercenaryid = hid
    }
    table.insert(self.lockedHeroList, index, temp)
    self.layer:addChild(node.icon, 30)
    local icon = self.heros[self.maxNum - index + 1]
    Action:showLight(icon.light)
    self:setMove(false)
  end
  
  Action:createHeroAndMoveTo(self.layer, hero._tid, pos, tpos, callback)
end

function Buttom:addMercenary(hid, pos, index)
  if not index then
    return
  end
  self:setMove(true)
  self:addMercenaryHero(hid, pos, index)
end

function Buttom:addList(index)
  local offset = 7
  local bg, bgLight, bgWidth, bgHeight = self:getHeroIconBg()
  bg:setPosition(ccp(bgWidth / 2 + (bgWidth + offset) * (index - 1), 20))
  self.draglist:addItem(bg)
  local temp = {bg = bg, light = bgLight}
  self.heros[index] = temp
end

function Buttom:setVisible(visible)
  self.layer:setVisible(visible)
end

function Buttom:isVisible()
  return self.layer:isVisible()
end

function Buttom:initDragList()
  self.draglist:clearList()
  self.heros = {}
  local offset = 7
  local bg, _, bgWidth, bgHeight = self:getHeroIconBg()
  bg:setPosition(ccp(bgWidth / 2 + (bgWidth + offset) * (self.maxNum - 1), 20))
  self.draglist:addItem(bg)
  for index = 1, self.maxNum do
    self:addList(index)
  end
end

function Buttom:canClick()
  return true
end

function Buttom:createDragList()
  local info = {
    cliprect = CCRectMake(135, 0, 516, 480),
    rect = CCRectMake(135, 30, 497, 100),
    container = self.layer,
    zorder = 20,
    position = ccp(130, 60),
    noshade = false,
    leftShade = "UI/alpha/HVGA/stagedone_left_shade.png",
    rightShade = "UI/alpha/HVGA/denfese/defense_hero_shade.png",
    doClickIn = self:doClickInList(),
    cancelClickIn = self:cancelClickInList(),
    doPressIn = self:doPressInList(),
    cancelPressIn = self:cancelPressInList()
  }
  self.draglist = ed.draglist.create(info)
end

function Buttom:doPressInList()
  local function handler(x, y)
    if self:isMove() then
      return
    end
    for k = 1, self.maxNum do
      local icon = self.heros[k]
      if self.isLockedMove then
        icon = self.lockedHeroList[k]
      end
      if not icon then
        return
      end
      if ed.containsPoint(icon.bg, x, y) and icon.hid then
        icon.bg:setScale(0.92)
        return k
      end
    end
  end
  
  return handler
end

function Buttom:doClickInList()
  local function handler(x, y, k)
    local icon = self.heros[k]
    
    if self.isLockedMove then
      icon = self.lockedHeroList[k]
    end
    icon.bg:setScale(0.95)
    if icon.hid and self:canClick() then
      if icon.isMercenary then
        self.uiview:clickMercenary(icon.mercenaryid)
      else
        self.uiview:clickHero(icon.hid)
      end
    end
  end
  
  return handler
end

function Buttom:cancelClickInList()
  local function handler(x, y, k)
    local icon = self.heros[k]
    
    if self.isLockedMove then
      icon = self.lockedHeroList[k]
    end
    icon.bg:setScale(0.95)
  end
  
  return handler
end

function Buttom:cancelPressInList()
  local function handler(x, y, k)
    local icon = self.heros[k]
    
    if self.isLockedMove then
      icon = self.lockedHeroList[k]
    end
    icon.bg:setScale(0.95)
  end
  
  return handler
end

function Buttom:touch(event, x, y)
  local function handler(event, x, y)
  end
  
  return handler
end

function Buttom:getHeroIconBg()
  local bg = ed.createSprite("UI/alpha/1080P/common/herobucket.png")
  local bgLight = ed.createSprite("UI/alpha/HVGA/herobucket-halo.png")
  bg:setScale(0.95)
  bg:addChild(bgLight)
  bgLight:setPosition(bg:getContentSize().width * 0.5, bg:getContentSize().height * 0.5 - 2)
  bgLight:setOpacity(0)
  return bg, bgLight, bg:getContentSize().width, bg:getContentSize().height
end

function Buttom:getUiInfo()
  local teamBgUI = {
    t = "Sprite",
    base = {
      name = "team_bg",
      res = "UI/alpha/HVGA/heroselected.png"
    },
    layout = {
      position = ccp(350, 60)
    },
    config = {}
  }
  if self.maxNum > 5 then
    teamBgUI = {
      t = "Scale9Sprite",
      base = {
        name = "team_bg",
        res = "UI/alpha/HVGA/heroselected.png",
        capInsets = CCRectMake(10, 20, 10, 15)
      },
      layout = {
        position = ccp(350, 78)
      },
      config = {
        scaleSize = CCSizeMake(622, 132)
      }
    }
  end
  local ui_info = {
    teamBgUI,
    {
      t = "Label",
      base = {
        name = "hero_num_title",
        text = T("\228\184\138\229\156\186\232\139\177\233\155\132"),
        size = 18
      },
      layout = {
        position = ccp(92, 80)
      },
      config = {
        color = ccc3(67, 59, 56),
        visible = true
      }
    },
    {
      t = "Label",
      base = {
        name = "hero_num",
        text = string.format("%d/%d", 0, 15),
        size = 18
      },
      layout = {
        position = ccp(95, 48)
      },
      config = {
        color = ccc3(241, 193, 113),
        visible = true
      }
    }
  }
  return ui_info
end

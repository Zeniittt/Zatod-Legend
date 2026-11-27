local class = {}
class.__index = class
ed.dragonBoatClass = class

function class.create(params)
  local self = {}
  setmetatable(self, class)
  self:init(params)
  return self
end

function class:init(params)
  self:initData(params)
  self:initUI()
  self:registerEvents()
end

function class:initData(params)
  self.skin = params.skin
  self.mgr = params.mgr
  self.container = params.container
  self.sceneSelf = params.sceneSelf
  self.oriPos = params.oriPos
  self.isSelf = params.isSelf
  self.rank = params.rank
  self.userInfo = params.userInfo
  self.name = params.userInfo._name
  self.roleId = params.userInfo._role_id
  self.starRank = params.starRank or 4
  self.stayInScreen = params.stayInScreen
  self.feet = params.feet or 0
  self.notFade = params.notFade
  if self.stayInScreen then
    self.sceneSelf:listenTimer(Timer:Once(self.mgr.accelerateTime), function()
      self.stayInScreen = false
    end)
  end
  self.boatSpeedScope = {}
  self.boatScope = {}
  self.boatSpeed = ed.dragonBoatMgr.getInstance().normalBgSpeed
end

function class:initUI()
  local spine = ed.createSpine("effect/eff_UI_DragonBoat_boat/eff_UI_DragonBoat_boat", 0.35)
  spine:setCascadeOpacityEnabled(true)
  spine:setAnimation(0, self.skin .. "_Idle", true)
  spine:setPosition(self.oriPos)
  self.container:addChild(spine)
  local showRank = self.starRank <= 1000
  local skin = self.skin <= 3 and self.skin or 3
  local rank = showRank and "haverank" or "norank"
  local res = string.format("UI/alpha/1080P/dragonboat/db_race/flag%d_%s.png", skin, rank)
  local nameBg = ed.createSprite(res)
  nameBg:setPosition(ccp(-64, 94))
  nameBg:setScale(0.8)
  spine:addChild(nameBg)
  nameBg:setCascadeOpacityEnabled(true)
  nameBg:setZOrder(-1)
  spine:setTimeScale(skin == 1 and 1 or skin == 2 and 1.1 or 1.2)
  if self.rank == 2 and not ed.dragonBoatMgr.getInstance().openMovie then
    local selfIconBg = ed.createSprite("UI/alpha/1080P/dragonboat/db_race/db_ziji_buttom.png")
    nameBg:addChild(selfIconBg)
    selfIconBg:setPosition(ccp(215, 83))
    local selfStr = ed.createLabelTTF(T("\232\135\170\n\229\183\177"), 16, ed.fontBold)
    ed.setLabelColor(selfStr, ed.toccc3(16777215))
    ed.setLabelStroke(selfStr, ed.toccc3(1606455), 2.5)
    nameBg:addChild(selfStr)
    selfStr:setPosition(ccp(212, 83))
  end
  local nameStr = ed.createLabelTTF(self.name, 16)
  ed.setLabelColor(nameStr, ed.toccc3(16776423))
  ed.setLabelStroke(nameStr, ed.toccc3(4598811), 2)
  nameBg:addChild(nameStr)
  nameStr:setPosition(ccp(130, 80))
  self.flagBg = nameBg
  if self.rankSprite then
    self.rankSprite:removeFromParentAndCleanup(true)
    self.rankSprite = nil
  end
  if showRank then
    if self.starRank < 4 then
      if self.rankNode then
        self.rankNode:removeFromParentAndCleanup(true)
        self.rankNode = nil
      end
      local res = {
        "rank_1st.png",
        "rank_2nd.png",
        "rank_3rd.png"
      }
      self.rankSprite = ed.createSpriteTools({
        res = "UI/alpha/1080P/toparena/rank/" .. res[self.starRank],
        parent = self.flagBg,
        pos = ccp(40, 85),
        scale = 0.75
      })
    elseif self.rankNode then
      ed.setLabelString(self.rankNode, self.starRank)
    else
      self.rankNode = ed.createLabelTTF(self.starRank, 21, ed.fontBold)
      ed.setLabelColor(self.rankNode, ed.toccc3(16771367))
      ed.setLabelStroke(self.rankNode, ed.toccc3(7953730), 2)
      self.flagBg:addChild(self.rankNode)
      self.rankNode:setPosition(ccp(40, 80))
    end
  elseif self.rankNode then
    self.rankNode:removeFromParentAndCleanup(true)
    self.rankNode = nil
  end
  self.feetLabel = ed.createLabelTools({
    txt = T("\229\189\147\229\137\141 %d \229\176\186", self.feet),
    size = 18,
    pos = ccp(-40, 145),
    color = ccc3(ed.colorToStr("#fffc84")),
    parent = spine,
    stroke = {
      ccc3(ed.colorToStr("#232323")),
      2
    }
  })
  self.spine = spine
  spine:setOpacity(0)
  if not self.stayInScreen then
    if not self.notFade then
      local rand = self.rank == 1 and 0.3 or self.rank == 2 and 0.45 or 0.55
      spine:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(rand), CCFadeTo:create(0.5, 255))))
      self.sceneSelf:listenTimer(Timer:Once(rand), function()
        if not tolua.isnull(self.spine) then
          self.spine:setAnimation(0, self.skin .. "_Idle", true)
          spine:setTimeScale(skin == 1 and 1 or skin == 2 and 1.1 or 1.2)
        end
      end)
    else
      spine:setOpacity(255)
    end
  else
    self.spineAppear = true
  end
  spine:setZOrder(9999 - self.oriPos.y)
  local touchArea = CCLayer:create()
  touchArea:setContentSize(CCSizeMake(200, 100))
  touchArea:setPosition(ccp(0, 50))
  spine:addChild(touchArea)
  self.touchArea = touchArea
end

function class:setSkin(skin)
  if self.skin and self.skin ~= skin then
    self.skin = skin
    self.spine:setAnimation(0, self.skin .. "_Idle", true)
    self.spine:setTimeScale(skin == 1 and 1 or skin == 2 and 1.1 or 1.2)
  end
end

function class:boating(destPos, time, destroy)
  if self.boatingAction then
    self.spine:stopAction(self.boatingAction)
    self.boatingAction = nil
  end
  if self.resetAction then
    self.spine:stopAction(self.resetAction)
    self.resetAction = nil
  end
  local array = ccArrayMake()
  if time then
    array:addObject(CCDelayTime:create(time))
    CloseScope(self.boatScope)
    self.isShow = true
    self.sceneSelf:listenTimer(Timer:Once(self.mgr.accelerateTime), function()
      self.isShow = nil
      self.stayInScreen = false
    end, self.boatScope)
  end
  array:addObject(CCCallFunc:create(function()
    local posX = self.spine:getPositionX()
    local length = math.abs(posX - destPos.x)
    local usedTime = length / 100
    local array1 = ccArrayMake()
    array1:addObject(CCMoveTo:create(usedTime, destPos))
    if destroy then
      array1:addObject(CCCallFunc:create(function()
        self:destroy()
      end))
    end
    self.resetAction = CCSequence:create(array1)
    self.spine:runAction(self.resetAction)
    local array2 = ccArrayMake()
    if destroy then
      array2:addObject(CCDelayTime:create(2))
      array2:addObject(CCFadeOut:create(0.5))
    else
      array2:addObject(CCDelayTime:create(usedTime - 1.5))
      array2:addObject(CCFadeTo:create(0.5, 255))
    end
    self.spine:runAction(CCSequence:create(array2))
  end))
  self.boatingAction = CCSequence:create(array)
  self.spine:runAction(self.boatingAction)
end

function class:destroy()
  CloseScope(self.boatScope)
  self.boatScope = nil
  self.stopCallBackFun = nil
  self.spine:removeFromParentAndCleanup(true)
  self.mgr.sceneSelf:removeUpdateHandler("boat" .. self.oriPos.y)
  self.mgr.yPositions[self.oriPos.y] = nil
  self.mgr.sceneSelf:btRemoveMainTouchHandler({
    key = "dragon_boat_boatTouch" .. self.roleId
  })
end

function class:stopCallBack()
  if self.stopCallBackFun then
    self.stopCallBackFun()
    self.stopCallBackFun = nil
  end
end

function class:accelerate(status)
  self.touchArea:stopAllActions()
  self.stopCallBackFun = nil
  if status == 1 then
    self.boatSpeed = ed.dragonBoatMgr.getInstance().normalBgSpeed * 5
    self.spine:setAnimation(0, self.skin .. "_Idle_fast", true)
    self.isShow = true
    
    function self.stopCallBackFun()
      if not tolua.isnull(self.spine) then
        self.spine:setAnimation(0, self.skin .. "_Idle", true)
        self.spine:setTimeScale(self.skin == 1 and 1 or self.skin == 2 and 1.1 or 1.2)
        self.boatSpeed = ed.dragonBoatMgr.getInstance().normalBgSpeed
        self.isShow = false
      end
    end
  elseif status == 2 then
    self.boatSpeed = ed.dragonBoatMgr.getInstance().normalBgSpeed * 3.3
    self.spine:setAnimation(0, self.skin .. "_Idle_fast", true)
    self.isShow = true
    self.touchArea:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(self.mgr.accelerateTime), CCCallFunc:create(function()
      self.spine:setAnimation(0, self.skin .. "_Idle", true)
      self.spine:setTimeScale(self.skin == 1 and 1 or self.skin == 2 and 1.1 or 1.2)
      self.boatSpeed = ed.dragonBoatMgr.getInstance().normalBgSpeed
      self.isShow = false
    end))))
  elseif status == 3 then
    self.boatSpeed = ed.dragonBoatMgr.getInstance().normalBgSpeed * 3.3
    self.isShow = true
    self.touchArea:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(self.mgr.accelerateTime), CCCallFunc:create(function()
      self.spine:setAnimation(0, self.skin .. "_Idle", true)
      self.boatSpeed = ed.dragonBoatMgr.getInstance().normalBgSpeed
      self.isShow = false
    end))))
  elseif status == 4 then
    self.boatSpeed = ed.dragonBoatMgr.getInstance().normalBgSpeed * 5
    self.spine:setAnimation(0, self.skin .. "_Idle_fast", true)
    self.isShow = true
    self.touchArea:runAction(CCSequence:create(ccArrayMake(CCDelayTime:create(self.mgr.accelerateTime), CCCallFunc:create(function()
      self.spine:setAnimation(0, self.skin .. "_Idle", true)
      self.spine:setTimeScale(self.skin == 1 and 1 or self.skin == 2 and 1.1 or 1.2)
      self.boatSpeed = ed.dragonBoatMgr.getInstance().normalBgSpeed
      self.isShow = false
    end))))
  end
  self.spine:setTimeScale(self.skin == 1 and 1.5 or self.skin == 2 and 1.6 or 1.7)
end

function class:update(dt)
  if self.stayInScreen then
    return
  end
  local deltaX = self.boatSpeed - ed.dragonBoatMgr.getInstance().bgSpeed
  local posX = self.spine:getPositionX() + deltaX * dt
  if self.isShow and self.rank < 4 then
    posX = math.max(0, math.min(ed.display.winSize.width, posX))
  end
  if self.rank == 1 and self.mgr.selfBoat and not tolua.isnull(self.mgr.selfBoat.spine) then
    posX = math.max(self.mgr.selfBoat.spine:getPositionX() - 50, posX)
  end
  self.spine:setPositionX(posX)
end

function class:registerEvents()
  self.mgr.sceneSelf:registerUpdateHandler("boat" .. self.oriPos.y, function(dt)
    self:update(dt)
  end)
  self.mgr.sceneSelf:btRegisterButtonClick({
    button = self.touchArea,
    key = "dragon_boat_boatTouch" .. self.roleId,
    clickHandler = function()
      if ed.dragonBoatMgr:getInstance().openMovie then
        return
      end
      if self.roleId ~= ed.getRoleId() then
        ed.UITool.openView("playerInfoPanel", self.roleId)
      else
        ed.ui.dragonBoatUseZongziPop.create({
          controller = self.mgr.sceneSelf
        }):popWindow()
      end
    end,
    clickInterval = 1
  })
end

function class:setStarRank(starRank)
  local oriShowRank = self.starRank < 1000
  local showRank = starRank < 1000
  local skin = self.skin <= 3 and self.skin or 3
  local rank = showRank and "haverank" or "norank"
  local res = string.format("UI/alpha/1080P/dragonboat/db_race/flag%d_%s.png", skin, rank)
  if oriShowRank or showRank then
    ed.setTexture(self.flagBg, res)
  end
  if self.rankSprite then
    self.rankSprite:removeFromParentAndCleanup(true)
    self.rankSprite = nil
  end
  if showRank then
    if starRank < 4 then
      if self.rankNode then
        self.rankNode:removeFromParentAndCleanup(true)
        self.rankNode = nil
      end
      local res = {
        "rank_1st.png",
        "rank_2nd.png",
        "rank_3rd.png"
      }
      self.rankSprite = ed.createSpriteTools({
        res = "UI/alpha/1080P/toparena/rank/" .. res[starRank],
        parent = self.flagBg,
        pos = ccp(40, 85),
        scale = 0.75
      })
    elseif self.rankNode then
      ed.setLabelString(self.rankNode, starRank)
    else
      self.rankNode = ed.createLabelTTF(starRank, 21, ed.fontBold)
      ed.setLabelColor(self.rankNode, ed.toccc3(16771367))
      ed.setLabelStroke(self.rankNode, ed.toccc3(7953730), 2)
      self.flagBg:addChild(self.rankNode)
      self.rankNode:setPosition(ccp(40, 80))
    end
  elseif self.rankNode then
    self.rankNode:removeFromParentAndCleanup(true)
    self.rankNode = nil
  end
  self.starRank = starRank
  self.spine:setOpacity(self.spine:getOpacity())
end

function class:refreshUI(info)
  local feet = info._feet
  self.feetLabel:setString(T("\229\189\147\229\137\141 %d \229\176\186", feet))
end

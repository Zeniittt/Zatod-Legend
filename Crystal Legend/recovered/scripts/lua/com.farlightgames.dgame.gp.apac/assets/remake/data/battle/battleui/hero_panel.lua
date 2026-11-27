local ed = ed
local FireEvent = FireEvent
local class = {
  mt = {}
}
ed.HeroPanel = class
class.mt.__index = class

local function HeroPanelCreate(unit, color, myHeroIndex)
  local mercenary = unit:isMercenary() and {} or nil
  local info = unit.info
  local portrait = ed.readhero.createIcon({
    id = unit.tid,
    rank = unit.rank,
    stars = unit.stars,
    fashion_id = unit.fashion_id,
    isHideFrame = false,
    mercenary = mercenary,
    summary = unit.proto,
    shard = (unit.proto or {})._shard
  })
  local self = {
    what = "HeroPanel",
    unit = unit,
    node = CCNode:create(),
    hp_bar = ed.HpBarCreate(unit, "HP", color),
    mp_bar = ed.HpBarCreate(unit, unit.info["MP Type"]),
    portrait = portrait.icon,
    redmask = ed.createSprite("UI/alpha/1080P/battle/battle_hero_head_litlight.png"),
    btn = nil,
    width = portrait.icon:getContentSize().width + 8,
    height = portrait.icon:getContentSize().height + 8,
    skill_ready = nil,
    skill_ready_timer = 0,
    ticks = -1,
    fca_switch = "eff_UI_battle_skill_can_switch",
    fca_ready = "eff_UI_battle_skill_will_ready",
    fca_cast = "eff_UI_battle_skill_cast",
    fca_trigger = "eff_UI_battle_skill_activate",
    fca_gainMp = "eff_UI_eatexp",
    fca_smallhead_switch = "eff_UI_Rubick_ult",
    fca_hp_cloud = "eff_UI_TitanMW_mist"
  }
  setmetatable(self, class.mt)
  self.hpcolor = color
  local res = "UI/alpha/1080P/common/battle_menu_click.png"
  local frame = CCMenuItemImage:create(res, res)
  frame:setContentSize(self.portrait:getContentSize())
  self.btn = frame
  local menu = CCMenu:createWithItem(frame)
  menu:setPosition(ccpAdd(frame:getAnchorPointInPoints(), ccp(-1, 0)))
  self.menu = menu
  self.portrait:addChild(menu)
  
  function self.castHandler()
    if ed.engine.running and not self.closeClick then
      if ed.engine.energyBean_mode then
        if self.state == nil and self.unit:unitCanGainMp() then
          if ed.engine.replayMode then
            return
          end
          ed.engine:manuallyGainMp(self.unit)
          self:play_gainMp_effect()
          self.mp_bar.goldBean_gainMp:setVisible(true)
        else
          ed.engine:manuallyCastSkill(self.unit)
          self:play_skill_cast_effect()
          FireEvent("ult_skill_touch", self.unit)
        end
      else
        self.state = "nil"
        ed.engine:manuallyCastSkill(self.unit)
        self.btn:setEnabled(false)
        self:play_skill_cast_effect()
        FireEvent("ult_skill_touch", self.unit)
      end
    end
  end
  
  self.btn:registerScriptTapHandler(function()
    xpcall(self.castHandler, EDDebug)
  end)
  if self.unit:unitCanGainMp() then
    self.btn:setEnabled(true)
  else
    self.btn:setEnabled(false)
  end
  local container = ed.createSprite("UI/alpha/1080P/common/herobucket.png")
  container:setPosition(ccpAdd(ccp(0, -7), self.portrait:getAnchorPointInPoints()))
  self.portrait:addChild(container, -2)
  local offsetY = self.mp_bar.background:getContentSize().height / 2 + 26 / ed.display.scaleFactor
  self.mp_bar.auto_hide = false
  self.mp_bar.node:setPosition(ccp(0, offsetY))
  self.node:addChild(self.mp_bar.node, 2)
  offsetY = offsetY + (self.mp_bar.background:getContentSize().height + self.hp_bar.background:getContentSize().height) / 2 + 3
  self.hp_bar.auto_hide = false
  self.hp_bar.node:setPosition(ccp(0, offsetY))
  self.node:addChild(self.hp_bar.node, 2)
  offsetY = offsetY + (self.hp_bar.background:getContentSize().height + self.height) / 2 + 5
  self.portrait:setPosition(ccp(0, offsetY))
  self.node:addChild(self.portrait, 0)
  if unit.displayBall then
    self.ball_bar = ed.BallBarCreate(unit)
    self.ball_bar.node:setPosition(ccp(0, 150))
    self.node:addChild(self.ball_bar.node, 2)
  end
  frame:addChild(self.redmask)
  self.redmask:setPosition(frame:getAnchorPointInPoints())
  self.redmask:setVisible(false)
  local action = CCRepeatForever:create(CCSequence:createWithTwoActions(CCFadeTo:create(0.8, 64), CCFadeTo:create(0.2, 255)))
  self.redmask:runAction(action)
  if ed.engine:manualBtMode() and myHeroIndex then
    local panel = ed.AtkManuakPanel.create({
      unit = unit,
      dir = myHeroIndex == 1 and "right" or "left"
    })
    self.node:addChild(panel.container)
    self.atkmanual_panel = panel
  end
  self.canClickUltSkill = true
  if ed.sceneui.closeHeroPanelClick then
    self.closeClick = true
  end
  return self
end

class.create = HeroPanelCreate
ed.HeroPanelCreate = HeroPanelCreate

local function setPortrait(self, res)
  local frame = ed.getSpriteFrame(res)
  if not frame then
    return
  end
  self.portrait:initWithSpriteFrame(frame)
end

class.setPortrait = setPortrait

local function setControlUnit(self, unit)
  local res = ed.getUnitPortrait(unit.tid)
  self:setPortrait(res)
  self.defaultUnit = self.unit
  self.unit = unit
  if self.c_hp_bar then
    self.c_hp_bar.node:removeFromParentAndCleanup(true)
  end
  if self.c_mp_bar then
    self.c_mp_bar.node:removeFromParentAndCleanup(true)
  end
  self.c_hp_bar = ed.HpBarCreate(unit, "HP", self.hpcolor)
  self.c_mp_bar = ed.HpBarCreate(unit, unit.info["MP Type"])
  self.hp_bar.node:setVisible(false)
  self.mp_bar.node:setVisible(false)
  self.c_hp_bar.auto_hide = false
  self.c_hp_bar.node:setPosition(ccp(0, 27))
  self.node:addChild(self.c_hp_bar.node, 2)
  self.c_mp_bar.auto_hide = false
  self.c_mp_bar.node:setPosition(ccp(0, 14))
  self.node:addChild(self.c_mp_bar.node, 2)
end

class.setControlUnit = setControlUnit

local function removeControlUnit(self, res)
  self:setPortrait(res)
  self.unit = self.defaultUnit
  self.defaultUnit = nil
  if self.c_hp_bar then
    if self.c_hp_bar then
      self.c_hp_bar.node:removeFromParentAndCleanup(true)
    end
    self.c_hp_bar = nil
  end
  if self.c_mp_bar then
    if self.c_mp_bar then
      self.c_mp_bar.node:removeFromParentAndCleanup(true)
    end
    self.c_mp_bar = nil
  end
  self.hp_bar.node:setVisible(true)
  self.mp_bar.node:setVisible(true)
end

class.removeControlUnit = removeControlUnit

local function createNextProtrait(self, res)
  local head, headicon = ed.createClippingNode(res, "UI/alpha/1080P/common/main_head_mask.png", nil, CCSizeMake(-10, -10))
  head:setScale(0.46)
  return head, headicon
end

local function setNextPortrait(self, res)
  local nextPortrait
  if res then
    nextPortrait = ed.createSprite()
    local head, headicon = createNextProtrait(self, res)
    nextPortrait:addChild(head)
    head:setPosition(ccp(40, 113))
    local sprite1 = ed.createSprite("UI/alpha/HVGA/rubick/rubick_ult_icon_point.png")
    sprite1:setAnchorPoint(ccp(0.5, 0.5))
    sprite1:setPosition(ccp(40, 110))
    nextPortrait:addChild(sprite1)
    local sprite2 = ed.createSprite("UI/alpha/HVGA/rubick/rubick_ult_icon_frame.png")
    sprite2:setAnchorPoint(ccp(0.5, 0.5))
    sprite2:setPosition(ccp(40, 110))
    nextPortrait:addChild(sprite2)
    self.portrait:addChild(nextPortrait)
    nextPortrait:setScaleY(0.76)
    nextPortrait:runAction(CCSequence:create(ccArrayMake(CCCallFunc:create(function()
      nextPortrait:setScaleY(1)
    end), CCMoveBy:create(0.55, ccp(0, 0)), CCCallFunc:create(function()
      self:play_smallhead_switch_effect()
    end), CCMoveBy:create(0.05, ccp(0, -10)), CCMoveBy:create(0.1, ccp(0, -20)), CCMoveBy:create(0.1, ccp(0, -34)))))
  end
  if self.nextPortrait then
    self.nextPortrait:removeFromParentAndCleanup(true)
  end
  self.nextPortrait = nextPortrait
end

class.setNextPortrait = setNextPortrait
local setVisible = CCNode.setVisible
local setEnabled = CCMenuItem.setEnabled
local max = math.max
local min = math.min

function class:checkManulCanCast()
  local canCast = self.unit.can_cast_manual and ed.engine.running
  if battle_tick.getRealTimePvp() and ed.engine.freeze_camp then
    return canCast and self.unit.camp == ed.engine.freeze_camp
  else
    return canCast
  end
end

function class:setHpCloudVisible(visible)
  if not self.hp_cloud then
    self:play_hp_cloud()
  end
  self.hp_cloud:setVisible(visible)
end

local function update(self, dt)
  if self.ticks ~= ed.engine.ticks and not ed.engine:arenaMode() and not ed.engine.replayMode and not self.closeClick then
    self.ticks = ed.engine.ticks
    if self.canClickUltSkill then
      local newState
      if self:checkManulCanCast() then
        newState = "cast"
      end
      if self.unit:canPanelTrigger() then
        newState = "trigger"
      end
      if newState == "cast" and self.unit:unitPanelIsSwitch() then
        newState = "switch"
      end
      if self.unit.controlledTarget then
        newState = nil
      end
      if not self.unit:unitCanGainMp() then
        setEnabled(self.btn, newState ~= nil)
      elseif ed.engine.energyBean_mode then
        setEnabled(self.btn, true)
      end
      if self.state ~= newState then
        if newState == "cast" then
          self:play_skill_ready(self.fca_ready)
          FireEvent(ed.guide.eventNames.USE_SKILL)
        elseif newState == "trigger" then
          self:play_skill_ready(self.fca_trigger)
          FireEvent(ed.guide.eventNames.USE_SKILL)
        elseif newState == "switch" then
          self:play_skill_ready(self.fca_switch)
          FireEvent(ed.guide.eventNames.USE_SKILL)
        else
          self:disable_cast()
          self.castSkillTutorialHandler = nil
          ed.guide.manager:stopGuide(38)
        end
        self.state = newState
      end
      if ed.scene.auto_combat then
        ed.guide.manager:stopGuide(38)
        if newState == "cast" or newState == "switch" then
          self.skill_ready_timer = self.skill_ready_timer + ed.tick_interval
          if self.skill_ready_timer > 0.5 and self.unit.manual_skill:willCast() then
            if self.unit.name == "Mor" and self.unit.mp < 1000 then
              self.btn:setEnabled(false)
              self.skill_ready_timer = 0
              return
            elseif self.unit.name == "Artemis" and self.unit.mp < 1000 then
              self.btn:setEnabled(false)
              self.skill_ready_timer = 0
              return
            elseif self.unit.name == "Naix" and self.unit.mp < 1000 then
              self.btn:setEnabled(false)
              self.skill_ready_timer = 0
              return
            elseif self.unit.name == "BR" and self.unit.mp < 1000 then
              self.btn:setEnabled(false)
              self.skill_ready_timer = 0
              return
            elseif self.unit.name == "TitanHS" and self.unit.mp < 1000 then
              self.btn:setEnabled(false)
              self.skill_ready_timer = 0
              return
            end
            self.castHandler()
            self.skill_ready_timer = 0
          end
        elseif newState == "trigger" and self.unit:shouldTrigger() then
          self.castHandler()
        elseif self.atkmanual_panel then
          self.atkmanual_panel:autoCastSkill()
        end
      end
    end
    self.redmask:setVisible(self.unit.hp_low)
    if not self.unit:isAlive() then
      self.redmask:setVisible(false)
      self.portrait:setColor(ccc3(100, 100, 100))
    end
  end
  for _, field in ipairs({
    "skill_ready",
    "skill_cast_anim",
    "gainMp",
    "smallhead_switch",
    "hp_cloud"
  }) do
    local anim = self[field]
    if anim then
      anim:update(dt)
      if anim:isTerminated() then
        anim:removeFromParentAndCleanup(true)
        self[field] = nil
      end
    end
  end
  if self.c_hp_bar and self.c_mp_bar then
    self.c_hp_bar:update(dt)
    self.c_mp_bar:update(dt)
  else
    self.hp_bar:update(dt)
    self.mp_bar:update(dt)
  end
  if self.ball_bar then
    self.ball_bar:update(dt)
  end
  if self.atkmanual_panel then
    self.atkmanual_panel:update(dt)
  end
end

class.update = update

local function play_skill_ready(self, res)
  if self.skill_ready then
    self.skill_ready:removeFromParentAndCleanup(true)
  end
  local effect = ed.createFcaNode(res)
  self.btn:addChild(effect)
  local btnSize = self.btn:getContentSize()
  effect:setPosition(ccp(btnSize.width / 2, 24))
  self.skill_ready = effect
  self.skill_ready_timer = 0
  if res == self.fca_ready then
    ed.playEffect(ed.sound.battle.cdOver)
    FireEvent("ult_skill_ready", self.unit)
  end
end

class.play_skill_ready = play_skill_ready

local function play_skill_cast_effect(self)
  self:disable_cast()
  if not self.skill_cast_anim then
    local effect = ed.createFcaNode(self.fca_cast)
    self.btn:addChild(effect)
    effect:setPosition(ccp(38, 33))
    self.skill_cast_anim = effect
  end
end

class.play_skill_cast_effect = play_skill_cast_effect

local function play_gainMp_effect(self)
  self:disable_cast()
  if not self.gainMp then
    local effect = ed.createFcaNode(self.fca_gainMp)
    self.btn:addChild(effect)
    effect:setPosition(ccp(35, 35))
    self.gainMp = effect
  end
end

class.play_gainMp_effect = play_gainMp_effect

local function play_smallhead_switch_effect(self)
  if not self.smallhead_switch then
    local effect = ed.createFcaNode(self.fca_smallhead_switch)
    self.btn:addChild(effect)
    effect:setPosition(ccp(40, 40))
    self.smallhead_switch = effect
  end
end

class.play_smallhead_switch_effect = play_smallhead_switch_effect

function class:play_hp_cloud()
  if not self.hp_cloud then
    self.hp_cloud = ed.createFcaNode(self.fca_hp_cloud)
    self.node:addChild(self.hp_cloud, 3)
    self.hp_cloud:setPosition(ccp(5, 27))
  end
end

local function disable_cast(self)
  if self.skill_ready then
    self.skill_ready:removeFromParentAndCleanup(true)
    self.skill_ready = nil
  end
  if self.skill_trigger_anim then
    self.skill_trigger_anim:removeFromParentAndCleanup(true)
    self.skill_trigger_anim = nil
  end
end

class.disable_cast = disable_cast

module("ed", package.seeall)
local setLength = CCNode.setScaleX
local setVisible = CCNode.setVisible
local epsilon = epsilon
local max = math.max
local min = math.min
HpBar = {}
HpBar.__index = HpBar

function HpBar.create(unit, _type, color)
  local self = {
    unit = unit,
    type = _type,
    node = CCNode:create(),
    background = ed.createScale9Sprite("UI/alpha/1080P/battle/battle_hero_progress_bg.png", CCRectMake(3, 3, 2, 2)),
    mask = CCSprite:create(),
    foreground = CCSprite:create(),
    midlayer = createSprite("UI/alpha/1080P/common/hp_yellow.png"),
    inc_speed = 0.5,
    auto_hide = true,
    fore_length = 1,
    mid_length = 1,
    percent = 1,
    effect = nil,
    state = "empty",
    hide_timer = 0
  }
  setmetatable(self, HpBar)
  if _type == "HP" then
    local res = "UI/alpha/1080P/battle/battle_hero_blood_progress.png"
    self.foreground:setDisplayFrame(getSpriteFrame(res))
    self.mask:setDisplayFrame(getSpriteFrame("UI/alpha/1080P/battle/battle_blood_lit_shade.png"))
  elseif _type == "Mana" then
    self.foreground:setDisplayFrame(getSpriteFrame("UI/alpha/1080P/common/mp_mana.png"))
    self.mask:setDisplayFrame(getSpriteFrame("UI/alpha/1080P/common/mp_mana_mask.png"))
    self.inc_speed = 2
  elseif _type == "Energy" then
    self.foreground:setDisplayFrame(getSpriteFrame("UI/alpha/1080P/common/mp_energy.png"))
    self.mask:setDisplayFrame(getSpriteFrame("UI/alpha/1080P/common/mp_mana_mask.png"))
    self.inc_speed = 2
  elseif _type == "Rage" then
    self.foreground:setDisplayFrame(getSpriteFrame("UI/alpha/1080P/battle/battle_hero_energy_progress.png"))
    self.mask:setDisplayFrame(getSpriteFrame("UI/alpha/1080P/battle/battle_energy_shade.png"))
    self.inc_speed = 2
    self.star = createFcaNode("eff_UI_battle_skill_cost")
    self.background:addChild(self.star, 3)
    self.star:setVisible(false)
    self.star:setPosition(ccp(75, 3))
    self.goldBean_gainMp = CCSprite:create("UI/alpha/1080P/common/herobucket_add_transform.png")
    self.goldBean_gainMp:setPosition(ccp(self.foreground:getContentSize().width * self.foreground:getScaleX() - 1, self.foreground:getContentSize().height / 2))
    self.goldBean_gainMp:setVisible(false)
    self.background:addChild(self.goldBean_gainMp, 3)
  end
  if _type == "HP" then
    self.percent = unit.hp / unit.attribs.HP
  else
    self.percent = unit.mp / unit.attribs.MP
  end
  self.foreground:setScaleX(self.percent)
  self.midlayer:setScaleX(self.percent)
  self.fore_length = self.percent
  self.mid_length = self.percent
  self.node:addChild(self.background)
  self.background:setPosition(ccpZero)
  self.background:setContentSize(self.foreground:getContentSize())
  self.background:addChild(self.mask, 3)
  self.mask:setAnchorPoint(ccpZero)
  self.mask:setVisible(false)
  local action = CCSequence:createWithTwoActions(CCFadeTo:create(0.5, 0), CCFadeTo:create(0.5, 255))
  action = CCRepeatForever:create(action)
  self.mask:runAction(action)
  self.background:addChild(self.midlayer, 1)
  self.midlayer:setAnchorPoint(ccpZero)
  self.background:addChild(self.foreground, 2)
  self.foreground:setAnchorPoint(ccpZero)
  return self
end

HpBarCreate = HpBar.create

function HpBar:updateEffect(dt)
  if self.type == "HP" then
    return
  end
  if self.percent >= 1 then
    if not self.effect then
      self.effect = ed.createFcaActor("eff_UI_full_power", 1, 0)
      self.node:addChild(self.effect)
      self.effect:setAction("Start")
      self.effect:setLoop(true)
    end
    if self.state ~= "full" then
      self.effect:setActionElapsed(0)
      self.state = "full"
    end
    self.effect:setVisible(true)
  elseif self.effect then
    self.effect:setVisible(false)
  end
  if self.effect and self.effect:isVisible() then
    self.effect:update(dt)
  end
end

function HpBar:customPercent()
end

function HpBar:update(dt)
  local node = self.node
  local model = self.unit
  local alive = model:isAlive()
  local mask = self.mask
  if not alive then
    self.percent = 0
    if mask then
      mask:setVisible(false)
    end
  elseif self.type == "HP" then
    self.percent = model.hp / model.attribs.HP
    if mask and not tolua.isnull(mask) then
      mask:setVisible(model.hp_low)
    end
  else
    self.percent = model.mp / model.attribs.MP
    if mask and model.manual_skill and not tolua.isnull(mask) then
      mask:setVisible(model.mp_low)
    end
  end
  local foreground = self.foreground
  local midlayer = self.midlayer
  local inc_speed = self.inc_speed
  local fore_length = self.fore_length
  local mid_length = self.mid_length
  local hide_timer = self.hide_timer
  local percent = self.percent
  percent = self:customPercent() or percent
  if fore_length < percent - epsilon then
    fore_length = fore_length + inc_speed * dt
    if percent < fore_length then
      fore_length = percent
    end
    fore_length = math.max(fore_length, 0)
    self.fore_length = fore_length
    setLength(foreground, fore_length)
    hide_timer = 1.5
  elseif fore_length > percent + epsilon then
    fore_length = math.max(percent, 0)
    self.fore_length = fore_length
    setLength(foreground, percent)
  end
  if mid_length < fore_length - epsilon then
    self.mid_length = math.max(mid_length, 0)
    setLength(midlayer, self.mid_length)
  elseif mid_length > fore_length then
    mid_length = math.max(mid_length - inc_speed * dt, 0)
    self.mid_length = mid_length
    setLength(midlayer, mid_length)
    hide_timer = 1.5
  end
  local star = self.star
  if star and star:isVisible() then
    star:setPosition(ccp(75 * foreground:getScaleX(), 3))
    star:update(dt)
  end
  local gainMp = self.goldBean_gainMp
  if gainMp and gainMp:isVisible() then
    gainMp:setPositionX(foreground:getContentSize().width * foreground:getScaleX() - 1)
    if percent < 0.1 or 1 <= percent then
      gainMp:setVisible(false)
    end
  end
  setVisible(node, not self.auto_hide or 0 < hide_timer)
  if not model:isAlive() then
    hide_timer = min(0.5, hide_timer)
  end
  self.hide_timer = hide_timer - dt
  self:updateEffect(dt)
end

BigHpBar = {}
BigHpBar.__index = BigHpBar

function BigHpBar:update(dt)
  local node = self.node
  local bRet, bloodIndex, bloodPercent, realBloodPercent = self:getBloodBarIndexAndPercent()
  if realBloodPercent <= 0 then
    node:removeFromParentAndCleanup(true)
    self.terminated = true
    return
  end
  if bRet then
    self.bloodPercent = bloodPercent
    self.percent = bloodPercent
    if self.bloodIndex ~= bloodIndex then
      if bloodIndex > self.bloodIndex then
        self.isMinBlood = true
        self.percent = 0
      else
        self.isMaxBlood = true
        self.percent = 1
      end
    else
    end
  end
  local foreground = self.foreground
  local midlayer = self.midlayer
  local inc_speed = self.inc_speed
  local fore_length = self.fore_length
  local mid_length = self.mid_length
  local percent = self.percent
  if fore_length < percent - epsilon then
    fore_length = fore_length + inc_speed * dt
    if percent < fore_length then
      fore_length = percent
    end
    self.fore_length = fore_length
    self:setBarPercent(self.foregroundClipLayer, foreground, fore_length)
  elseif fore_length > percent + epsilon then
    fore_length = percent
    self.fore_length = fore_length
    self:setBarPercent(self.foregroundClipLayer, foreground, percent)
  end
  if mid_length < fore_length - epsilon then
    self.mid_length = fore_length
    self:setBarPercent(self.midClipLayer, midlayer, fore_length)
  elseif mid_length > fore_length then
    mid_length = mid_length - inc_speed * dt
    self.mid_length = mid_length
    self:setBarPercent(self.midClipLayer, midlayer, mid_length)
  end
  if percent == 0 and self.isMinBlood then
    if fore_length >= mid_length then
      self:resetBloodState()
      self.percent = self.bloodPercent
      self:setBarPercent(self.foregroundClipLayer, foreground, self.percent)
      self:setBarPercent(self.midClipLayer, midlayer, 1)
      self.fore_length = self.percent
      self.mid_length = 1
      self.bloodIndex = bloodIndex
      self.isMinBlood = false
    end
  elseif percent == 1 and self.isMaxBlood and fore_length >= percent - epsilon then
    self:resetBloodState()
    self.percent = self.bloodPercent
    self:setBarPercent(self.midClipLayer, midlayer, 0)
    self:setBarPercent(self.foregroundClipLayer, foreground, 0)
    self.fore_length = 0
    self.mid_length = 0
    self.bloodIndex = bloodIndex
    self.isMaxBlood = false
  end
  if ed.isElementInTable(ed.scene:getCurrentMode(), {"awakeStage"}) then
    local perc = ed.engine:getAwakeStageProgress()
    perc = ed.engine:convertAwakeStageProgressToShow(perc)
    ed.setString(self.stagePercLabel, math.floor(perc / 100) .. "%")
  elseif ed.isElementInTable(ed.scene:getCurrentMode(), {"hadesHeat", "rogueMode"}) then
    local perc = math.floor(100 - realBloodPercent * 100)
    perc = math.max(perc, 0)
    ed.setString(self.stagePercLabel, string.format("%s%%", perc))
  end
end

function BigHpBar:getBloodBarRcsAndPercent(count)
  local ret = {}
  for i = count, 1, -1 do
    local index = math.mod(i, 3)
    local name = ""
    if index == 1 then
      name = "UI/alpha/1080P/common/guildraid_hpbar_boss_red.png"
    elseif index == 2 then
      name = "UI/alpha/1080P/common/guildraid_hpbar_boss_purple.png"
    elseif index == 0 then
      name = "UI/alpha/1080P/common/guildraid_hpbar_boss_blue.png"
    end
    local item = {
      name,
      1 / count
    }
    table.insert(ret, item)
  end
  return ret
end

function BigHpBar:getBloodBarRcs(index)
  local ind = math.mod(index, 3)
  local name = ""
  if ind == 1 then
    name = "UI/alpha/1080P/common/guildraid_hpbar_boss_red.png"
  elseif ind == 2 then
    name = "UI/alpha/1080P/common/guildraid_hpbar_boss_purple.png"
  elseif ind == 0 then
    name = "UI/alpha/1080P/common/guildraid_hpbar_boss_blue.png"
  end
  return name
end

function BigHpBar:getBloodBarIndexAndPercent()
  local bRet = false
  local bloodIndex = 0
  local bloodPercent = 0
  local realBloodPercent = 0
  if self.unit then
    realBloodPercent = self.unit.hp / self.unit.attribs.HP
    local totalPercent = 1 - realBloodPercent
    bloodIndex = math.ceil(totalPercent / self.bloodBarInfo[2])
    bloodPercent = (bloodIndex * self.bloodBarInfo[2] - totalPercent) / self.bloodBarInfo[2]
    bRet = true
  end
  return bRet, bloodIndex, bloodPercent, realBloodPercent
end

function BigHpBar:resetForegroundAndDecration()
  local foregroundRcsName = self:getBloodBarRcs(self.bloodIndex)
  local decrationRcsName
  if self.bloodIndex < self.bloodBarInfo[1] then
    decrationRcsName = self:getBloodBarRcs(self.bloodIndex + 1)
    self.decration:setVisible(true)
  else
    self.decration:setVisible(false)
  end
  if decrationRcsName then
    self.decration:setDisplayFrame(getSpriteFrame(decrationRcsName))
  end
  if foregroundRcsName then
    self.foreground:setDisplayFrame(getSpriteFrame(foregroundRcsName))
  end
end

function BigHpBar:resetBloodState()
  local bRet, bloodIndex, bloodPercent = self:getBloodBarIndexAndPercent()
  if bRet then
    self.bloodIndex = bloodIndex
    self.bloodPercent = bloodPercent
  end
  self:resetForegroundAndDecration()
end

function BigHpBar:setBarPercent(clipLayer, node, percent)
  if clipLayer and node then
    local size = node:getTextureRect().size
    local scale = self.background:getScaleX()
    local startPosX = size.width * scale * (1 - percent)
    clipLayer:setClipRect(CCRectMake(startPosX, 0, size.width * 1.3, size.height * 1.3))
  end
end

function BigHpBar.create(unit, length, icon_offset, count, param)
  local self = {
    unit = unit,
    type = "HP",
    what = "BigHpBar",
    node = CCNode:create(),
    background = createSprite("UI/alpha/1080P/common/guildraid_hpbar_boss_bg.png"),
    midlayer = createSprite("UI/alpha/1080P/common/guildraid_hpbar_transition.png"),
    midClipLayer = CCLayer:create(),
    decration = CCSprite:create(),
    foreground = CCSprite:create(),
    foregroundClipLayer = CCLayer:create(),
    bossIconFrameNode = createSprite("UI/alpha/1080P/common/boss_frame.png"),
    bossIconNode = createSprite(unit.bossIconName),
    inc_speed = 0.3,
    auto_hide = false,
    fore_length = 1,
    mid_length = 1,
    percent = 1,
    isMinBlood = false,
    isMaxBlood = false,
    hide_timer = 0
  }
  setmetatable(self, BigHpBar)
  self.bloodBarInfo = {
    [1] = count or unit.hpLayer,
    [2] = 1 / (count or unit.hpLayer)
  }
  self:resetBloodState()
  self.percent = self.bloodPercent
  self.fore_length = self.percent
  self.mid_length = self.percent
  self.param = param or {}
  local iconFrameSize = self.bossIconFrameNode:getTextureRect().size
  local backgroundSize = self.background:getTextureRect().size
  local midlayerSize = self.midlayer:getTextureRect().size
  local foregroundSize = self.foreground:getTextureRect().size
  local hpBarLength = length - iconFrameSize.width
  local scale = math.min(hpBarLength * 0.9 / backgroundSize.width, 1)
  self.bossIconNode:setScale(1.8)
  self.bossIconFrameNode:setScale(self.param.iconFrameScale or 1)
  local offsetX = backgroundSize.width - (backgroundSize.width - midlayerSize.width) / 2
  local offsetY = backgroundSize.height / 2
  local offsetXLeft = (backgroundSize.width - midlayerSize.width) / 2
  local offsetYDown = (backgroundSize.height - midlayerSize.height) / 2
  self.node:addChild(self.background)
  self.background:setScaleX(scale)
  self.background:setPosition(ccpZero)
  self.background:setAnchorPoint(ccp(0.5, 0.5))
  self.background:addChild(self.decration, 0)
  self.decration:setAnchorPoint(ccp(1, 0.5))
  self.decration:setPosition(ccp(offsetX, offsetY))
  self.midClipLayer:setAnchorPoint(ccpZero)
  self.midClipLayer:setClipRect(CCRectMake(0, 0, midlayerSize.width, midlayerSize.height))
  self.midClipLayer:addChild(self.midlayer)
  self.midlayer:setAnchorPoint(ccpZero)
  self.background:addChild(self.midClipLayer, 1)
  self.midClipLayer:setPosition(ccp(offsetXLeft, offsetYDown))
  self.foregroundClipLayer:setAnchorPoint(ccpZero)
  self.foregroundClipLayer:setClipRect(CCRectMake(0, 0, foregroundSize.width, foregroundSize.height))
  self.foregroundClipLayer:addChild(self.foreground)
  self.foreground:setAnchorPoint(ccpZero)
  self.background:addChild(self.foregroundClipLayer, 1)
  self.foregroundClipLayer:setPosition(ccp(offsetXLeft, offsetYDown))
  self.node:addChild(self.bossIconFrameNode)
  self.bossIconFrameNode:setAnchorPoint(ccp(0, 0.5))
  if icon_offset then
    self.bossIconFrameNode:setPosition(ccp(foregroundSize.width * scale / 2 - 10 + icon_offset.x, icon_offset.y))
  else
    self.bossIconFrameNode:setPosition(ccp(foregroundSize.width * scale / 2 - 10, 0))
  end
  self.bossIconFrameNode:addChild(self.bossIconNode, 1)
  self.bossIconNode:setAnchorPoint(ccp(0.5, 0.5))
  self.bossIconNode:setPosition(iconFrameSize.width / 2, iconFrameSize.height / 2)
  self:setBarPercent(self.midClipLayer, self.midlayer, self.percent)
  self:setBarPercent(self.foregroundClipLayer, self.foreground, self.percent)
  if ed.isElementInTable(ed.scene:getCurrentMode(), {
    "awakeStage",
    "hadesHeat",
    "rogueMode"
  }) then
    local stageProgress = ed.createSprite("UI/alpha/1080P/dungeon/dungeon_battle_progress1.png")
    local title = ed.createttf(T("\229\135\187\232\180\165\232\191\155\229\186\166"), 14, ed.fontBold)
    title:setColor(ed.toccc3(16763503))
    title:setStroke(ed.toccc3(5574152), 1.5)
    title:setPosition(45, 38)
    stageProgress:addChild(title)
    title:limitWidthByScale(80)
    local label = ed.createttf("0%", 25, ed.fontBold)
    label:setColor(ed.toccc3(16763503))
    label:setStroke(ed.toccc3(5574152), 1.5)
    label:setPosition(48, 15)
    self.stagePercLabel = label
    stageProgress:addChild(label)
    self.node:addChild(stageProgress, -1)
    stageProgress:setScale(self.param.stageProgressScale or 1)
    ed.right2(stageProgress, self.bossIconFrameNode, -8)
  end
  return self
end

BigHpBarCreate = BigHpBar.create
BigHpBarNoIcon = {}
BigHpBarNoIcon.__index = BigHpBarNoIcon

function BigHpBarNoIcon:update(dt)
  local node = self.node
  local bRet, bloodIndex, bloodPercent, realBloodPercent = self:getBloodBarIndexAndPercent()
  if realBloodPercent <= 0 then
    node:removeFromParentAndCleanup(true)
    self.terminated = true
    return
  end
  if bRet then
    self.bloodPercent = bloodPercent
    self.percent = bloodPercent
    if self.bloodIndex ~= bloodIndex then
      if bloodIndex > self.bloodIndex then
        self.isMinBlood = true
        self.percent = 0
      else
        self.isMaxBlood = true
        self.percent = 1
      end
    else
    end
  end
  local foreground = self.foreground
  local midlayer = self.midlayer
  local inc_speed = self.inc_speed
  local fore_length = self.fore_length
  local mid_length = self.mid_length
  local percent = self.percent
  if fore_length < percent - epsilon then
    fore_length = fore_length + inc_speed * dt
    if percent < fore_length then
      fore_length = percent
    end
    self.fore_length = fore_length
    self:setBarPercent(self.foregroundClipLayer, foreground, fore_length)
  elseif fore_length > percent + epsilon then
    fore_length = percent
    self.fore_length = fore_length
    self:setBarPercent(self.foregroundClipLayer, foreground, percent)
  end
  if mid_length < fore_length - epsilon then
    self.mid_length = fore_length
    self:setBarPercent(self.midClipLayer, midlayer, fore_length)
  elseif mid_length > fore_length then
    mid_length = mid_length - inc_speed * dt
    self.mid_length = mid_length
    self:setBarPercent(self.midClipLayer, midlayer, mid_length)
  end
  if percent == 0 and self.isMinBlood then
    if fore_length >= mid_length then
      self:resetBloodState()
      self.percent = self.bloodPercent
      self:setBarPercent(self.foregroundClipLayer, foreground, self.percent)
      self:setBarPercent(self.midClipLayer, midlayer, 1)
      self.fore_length = self.percent
      self.mid_length = 1
      self.bloodIndex = bloodIndex
      self.isMinBlood = false
    end
  elseif percent == 1 and self.isMaxBlood and fore_length >= percent - epsilon then
    self:resetBloodState()
    self.percent = self.bloodPercent
    self:setBarPercent(self.midClipLayer, midlayer, 0)
    self:setBarPercent(self.foregroundClipLayer, foreground, 0)
    self.fore_length = 0
    self.mid_length = 0
    self.bloodIndex = bloodIndex
    self.isMaxBlood = false
  end
end

function BigHpBarNoIcon:getBloodBarRcsAndPercent(count)
  local ret = {}
  for i = count, 1, -1 do
    local index = math.mod(i, 3)
    local name = ""
    if index == 1 then
      name = "UI/alpha/1080P/common/guildraid_hpbar_boss_red.png"
    elseif index == 2 then
      name = "UI/alpha/1080P/common/guildraid_hpbar_boss_purple.png"
    elseif index == 0 then
      name = "UI/alpha/1080P/common/guildraid_hpbar_boss_blue.png"
    end
    local item = {
      name,
      1 / count
    }
    table.insert(ret, item)
  end
  return ret
end

function BigHpBarNoIcon:getBloodBarIndexAndPercent()
  local bRet = false
  local bloodIndex = 0
  local bloodPercent = 0
  local realBloodPercent = 0
  if self.unit then
    realBloodPercent = self.unit.hp / self.unit.attribs.HP
    local totalPercent = 1 - realBloodPercent
    bloodIndex = math.ceil(totalPercent / self.bloodBarInfo[2])
    bloodPercent = (bloodIndex * self.bloodBarInfo[2] - totalPercent) / self.bloodBarInfo[2]
    bRet = true
  end
  return bRet, bloodIndex, bloodPercent, realBloodPercent
end

function BigHpBarNoIcon:resetForegroundAndDecration()
  local foregroundRcsName = self:getBloodBarRcs(self.bloodIndex)
  local decrationRcsName
  if self.bloodIndex < self.bloodBarInfo[1] then
    decrationRcsName = self:getBloodBarRcs(self.bloodIndex + 1)
    self.decration:setVisible(true)
  else
    self.decration:setVisible(false)
  end
  if decrationRcsName then
    self.decration:setDisplayFrame(getSpriteFrame(decrationRcsName))
  end
  if foregroundRcsName then
    self.foreground:setDisplayFrame(getSpriteFrame(foregroundRcsName))
  end
end

function BigHpBarNoIcon:resetBloodState()
  local bRet, bloodIndex, bloodPercent = self:getBloodBarIndexAndPercent()
  if bRet then
    self.bloodIndex = bloodIndex
    self.bloodPercent = bloodPercent
  end
  self:resetForegroundAndDecration()
end

function BigHpBarNoIcon:setBarPercent(clipLayer, node, percent)
  if clipLayer and node then
    local size = node:getTextureRect().size
    local scale = self.background:getScaleX()
    local startPosX = size.width * scale * (1 - percent)
    clipLayer:setClipRect(CCRectMake(startPosX, 0, size.width, size.height))
  end
end

function BigHpBarNoIcon.create(unit, length, count)
  local self = {
    unit = unit,
    type = "HP",
    what = "BigHpBar",
    node = CCNode:create(),
    background = createSprite("UI/alpha/1080P/common/guildraid_hpbar_boss_bg.png"),
    midlayer = createSprite("UI/alpha/1080P/common/guildraid_hpbar_transition.png"),
    midClipLayer = CCLayer:create(),
    decration = CCSprite:create(),
    foreground = CCSprite:create(),
    foregroundClipLayer = CCLayer:create(),
    bossIconFrameNode = createSprite("UI/alpha/1080P/common/boss_frame.png"),
    bossIconNode = createSprite(unit.bossIconName),
    inc_speed = 0.3,
    auto_hide = false,
    fore_length = 1,
    mid_length = 1,
    percent = 1,
    isMinBlood = false,
    isMaxBlood = false,
    hide_timer = 0
  }
  setmetatable(self, BigHpBar)
  self.bloodBarInfo = {
    [1] = count or unit.hpLayer,
    [2] = 1 / (count or unit.hpLayer)
  }
  self:resetBloodState()
  self.percent = self.bloodPercent
  self.fore_length = self.percent
  self.mid_length = self.percent
  local iconFrameSize = self.bossIconFrameNode:getTextureRect().size
  local backgroundSize = self.background:getTextureRect().size
  local midlayerSize = self.midlayer:getTextureRect().size
  local foregroundSize = self.foreground:getTextureRect().size
  local hpBarLength = length - iconFrameSize.width
  local scale = math.min(hpBarLength * 0.9 / backgroundSize.width, 1)
  local offsetX = backgroundSize.width - (backgroundSize.width - midlayerSize.width) / 2
  local offsetY = backgroundSize.height / 2
  local offsetXLeft = (backgroundSize.width - midlayerSize.width) / 2
  local offsetYDown = (backgroundSize.height - midlayerSize.height) / 2
  self.node:addChild(self.background)
  self.background:setScaleX(scale)
  self.background:setPosition(ccpZero)
  self.background:setAnchorPoint(ccp(0.5, 0.5))
  self.background:addChild(self.decration, 0)
  self.decration:setAnchorPoint(ccp(1, 0.5))
  self.decration:setPosition(ccp(offsetX, offsetY))
  self.midClipLayer:setAnchorPoint(ccpZero)
  self.midClipLayer:setClipRect(CCRectMake(-50, 0, midlayerSize.width * 1.3, midlayerSize.height * 1.3))
  self.midClipLayer:addChild(self.midlayer)
  self.midlayer:setAnchorPoint(ccpZero)
  self.background:addChild(self.midClipLayer, 1)
  self.midClipLayer:setPosition(ccp(offsetXLeft, offsetYDown))
  self.foregroundClipLayer:setAnchorPoint(ccpZero)
  self.foregroundClipLayer:setClipRect(CCRectMake(0, 0, foregroundSize.width, foregroundSize.height))
  self.foregroundClipLayer:addChild(self.foreground)
  self.foreground:setAnchorPoint(ccpZero)
  self.background:addChild(self.foregroundClipLayer, 1)
  self.foregroundClipLayer:setPosition(ccp(offsetXLeft, offsetYDown))
  self.node:addChild(self.bossIconFrameNode)
  self.bossIconFrameNode:setVisible(false)
  self.bossIconFrameNode:setAnchorPoint(ccp(0, 0.5))
  if icon_offset then
    self.bossIconFrameNode:setPosition(ccp(foregroundSize.width * scale / 2 - 10 + icon_offset.x, icon_offset.y))
  else
    self.bossIconFrameNode:setPosition(ccp(foregroundSize.width * scale / 2 - 10, 0))
  end
  self.bossIconFrameNode:addChild(self.bossIconNode, 1)
  self.bossIconNode:setAnchorPoint(ccp(0.5, 0.5))
  self.bossIconNode:setPosition(iconFrameSize.width / 2, iconFrameSize.height / 2)
  self:setBarPercent(self.midClipLayer, self.midlayer, self.percent)
  self:setBarPercent(self.foregroundClipLayer, self.foreground, self.percent)
  return self
end

BigHpBarNoIconCreate = BigHpBarNoIcon.create
local floating_bar_settings = {
  HP = {
    background = "UI/alpha/1080P/common/hp_black_small.png",
    midlayer = "UI/alpha/1080P/common/hp_yellow_small.png",
    foreground = {
      [1] = "UI/alpha/1080P/common/hp_green_small.png",
      [-1] = "UI/alpha/1080P/common/hp_red_small.png",
      [0] = "UI/alpha/1080P/common/hp_red_small.png"
    },
    inc_speed = 0.8,
    auto_hide = true,
    foreground_pos = ccpZero,
    midlayer_pos = ccpZero
  },
  MP = {
    background = "UI/alpha/1080P/common/hp_shield_bg.png",
    midlayer = "UI/alpha/1080P/common/hp_yellow_shield.png",
    foreground = {
      [1] = "UI/alpha/1080P/common/hp_shield.png",
      [-1] = "UI/alpha/1080P/common/hp_shield.png",
      [0] = "UI/alpha/1080P/common/hp_shield.png"
    },
    inc_speed = 0.8,
    auto_hide = true,
    foreground_pos = ccpZero,
    midlayer_pos = ccpZero
  },
  Shield = {
    background = "UI/alpha/1080P/common/hp_shield_bg.png",
    midlayer = "UI/alpha/1080P/common/hp_yellow_shield.png",
    foreground = {
      [1] = "UI/alpha/1080P/common/hp_shield.png",
      [-1] = "UI/alpha/1080P/common/hp_shield.png",
      [0] = "UI/alpha/1080P/common/hp_shield.png"
    },
    inc_speed = 1,
    auto_hide = true,
    foreground_pos = ccpZero,
    midlayer_pos = ccpZero
  },
  ShieldBoss = {
    background = "UI/alpha/1080P/common/guildraid_hpbar_boss_shield_bg.png",
    midlayer = "UI/alpha/1080P/common/guildraid_hpbar_transition_shield.png",
    foreground = {
      [1] = "UI/alpha/1080P/common/guildraid_hpbar_boss_shield.png",
      [-1] = "UI/alpha/1080P/common/guildraid_hpbar_boss_shield.png",
      [0] = "UI/alpha/1080P/common/guildraid_hpbar_boss_shield.png"
    },
    inc_speed = 0.5,
    auto_hide = false,
    foreground_pos = ccpZero,
    midlayer_pos = ccpZero
  },
  Fury = {
    background = "UI/alpha/1080P/common/hp_shield_bg.png",
    midlayer = "UI/alpha/1080P/common/hp_yellow_shield.png",
    foreground = {
      [1] = "UI/alpha/1080P/common/san_point.png",
      [-1] = "UI/alpha/1080P/common/san_point.png",
      [0] = "UI/alpha/1080P/common/san_point.png"
    },
    inc_speed = 1,
    auto_hide = true,
    foreground_pos = ccpZero,
    midlayer_pos = ccpZero
  }
}
FloatingBar = {}
FloatingBar.__index = FloatingBar

function FloatingBar.create(unit, type)
  local bar = {
    what = "FloatingBar",
    unit = unit,
    type = type or "HP",
    inc_speed = floating_bar_settings[type].inc_speed,
    auto_hide = floating_bar_settings[type].auto_hide,
    fore_length = 1,
    mid_length = 1,
    percent = 1,
    force_hide = false,
    hide_timer = 0
  }
  setmetatable(bar, FloatingBar)
  bar.proto = FloatingBarType[type]
  if bar.proto == nil then
    EDDebug("FloatingBar type '" .. tostring(type) .. "' not found!")
    return nil
  end
  bar.node = CCNode:create()
  bar.background = createSprite(floating_bar_settings[type].background)
  bar.midlayer = createSprite(floating_bar_settings[type].midlayer)
  bar.foreground = createSprite(floating_bar_settings[type].foreground[unit.camp])
  bar.percent = bar:CallInterface("InitValuePercent")
  bar.foreground:setScaleX(bar.percent)
  bar.midlayer:setScaleX(bar.percent)
  bar.fore_length = bar.percent
  bar.mid_length = bar.percent
  bar.node:addChild(bar.background)
  bar.background:setPosition(ccpZero)
  bar.background:addChild(bar.midlayer, 0)
  bar.midlayer:setAnchorPoint(ccpZero)
  bar.midlayer:setPosition(floating_bar_settings[type].midlayer_pos)
  bar.background:addChild(bar.foreground, 1)
  bar.foreground:setAnchorPoint(ccpZero)
  bar.foreground:setPosition(floating_bar_settings[type].foreground_pos)
  return bar
end

function FloatingBar:CallInterface(func_name, ...)
  local func = self.proto[func_name]
  if func ~= nil and type(func) == "function" then
    return func(self, ...)
  end
end

local hide_delay = 1.5

function FloatingBar:customPercent()
end

function FloatingBar:update(dt)
  local node = self.node
  local unit = self.unit
  if not unit:isAlive() then
    self.percent = 0
  else
    self:RefreshPercent()
  end
  local foreground = self.foreground
  local midlayer = self.midlayer
  local inc_speed = self.inc_speed
  local fore_length = self.fore_length
  local mid_length = self.mid_length
  local hide_timer = self.hide_timer
  local percent = self.percent
  percent = self:customPercent() or percent
  if fore_length < percent - epsilon then
    fore_length = fore_length + inc_speed * dt
    if percent < fore_length then
      fore_length = percent
    end
    self.fore_length = fore_length
    setLength(foreground, fore_length)
    hide_timer = hide_delay
  elseif fore_length > percent + epsilon then
    fore_length = percent
    self.fore_length = fore_length
    setLength(foreground, percent)
  end
  if mid_length < fore_length - epsilon then
    self.mid_length = fore_length
    setLength(midlayer, fore_length)
  elseif mid_length > fore_length then
    mid_length = mid_length - inc_speed * dt
    self.mid_length = mid_length
    setLength(midlayer, mid_length)
    hide_timer = hide_delay
  end
  if percent == 0 then
    hide_timer = 0
    setVisible(node, false)
  end
  if not unit:isAlive() then
    hide_timer = min(0.5, hide_timer)
  end
  self.hide_timer = hide_timer - dt
  return hide_timer
end

function FloatingBar:CanBeSeen()
  if self.force_hide then
    return false
  end
  return self.percent ~= 0
end

function FloatingBar:forceHide(val)
  self.force_hide = val
  setVisible(self.node, not val)
end

function FloatingBar:RefreshPercent()
  self.value = self:CallInterface("GetValue") or self.value or 0
  self.value_max = self:CallInterface("GetValueMax") or self.value_max or 1
  if self.value_max == 0 then
    self.percent = 0
    return
  end
  self.percent = self.value / self.value_max
  if 1 < self.percent then
    self.percent = 1
  end
end

FloatingBarGroup = {}
FloatingBarGroup.__index = FloatingBarGroup

function FloatingBarGroup.create()
  local floating_bar_group = {}
  floating_bar_group.what = "FloatingBarGroup"
  floating_bar_group.bars = {}
  setmetatable(floating_bar_group, FloatingBarGroup)
  return floating_bar_group
end

function FloatingBarGroup:AddBar(name, bar)
  if bar.what ~= "FloatingBar" then
    EDDebug("FloatingBarGroup:AddBar - Wrong target type!")
  end
  self.bars[name] = bar
end

function FloatingBarGroup:SplitGroupUpdate(dt, elements, isContain)
  local function condition(name)
    if isContain then
      return ed.isElementInTable(name, elements)
    else
      return not ed.isElementInTable(name, elements)
    end
  end
  
  local hide_timer = 0
  for name, bar in pairs(self.bars) do
    if condition(name) then
      local current_hide_timer = bar:update(dt)
      hide_timer = max(hide_timer, current_hide_timer)
    end
  end
  for name, bar in pairs(self.bars) do
    if condition(name) and bar:CanBeSeen() then
      setVisible(bar.node, not bar.auto_hide or 0 < hide_timer)
    end
  end
end

function FloatingBarGroup:update(dt)
  self:SplitGroupUpdate(dt, {"Fury"}, false)
  self:SplitGroupUpdate(dt, {"Fury"}, true)
end

module("ed.FloatingBarType.HP", package.seeall)

function InitValuePercent(bar)
  bar.value = bar.unit.hp
  bar.value_max = bar.unit.attribs.HP
  local percent = bar.value / bar.value_max
  if 1 < percent then
    percent = 1
  end
  bar.percent = percent
  return percent
end

function GetValue(bar)
  return bar.unit.hp
end

function GetValueMax(bar)
  return bar.unit.attribs.HP
end

module("ed.FloatingBarType.MP", package.seeall)

function InitValuePercent(bar)
  bar.value = bar.unit.mp
  bar.value_max = bar.unit.attribs.MP
  local percent = bar.value / bar.value_max
  if 1 < percent then
    percent = 1
  end
  bar.percent = percent
  return percent
end

function GetValue(bar)
  return bar.unit.mp
end

function GetValueMax(bar)
  return bar.unit.attribs.MP
end

module("ed.FloatingBarType.Shield", package.seeall)

function InitValuePercent(bar)
  bar.value = 0
  bar.value_max = 0
  bar.percent = 0
  return 0
end

function GetValue(bar)
  local shield_value_total = 0
  local buff_list = bar.unit.buff_list
  for i, buff in ipairs(buff_list) do
    local shield_value = buff.shield or 0
    shield_value_total = shield_value_total + shield_value
  end
  return shield_value_total
end

function GetValueMax(bar)
  if bar.value > bar.value_max then
    local delta = bar.value - bar.value_max
    bar.value_max = bar.value_max + delta
  elseif bar.value == 0 then
    bar.value_max = 0
  end
  return bar.value_max
end

module("ed.FloatingBarType.ShieldBoss", package.seeall)

function InitValuePercent(bar)
  bar.value = 0
  bar.value_max = 0
  bar.percent = 0
  return 0
end

function GetValue(bar)
  local shield_value_total = 0
  local buff_list = bar.unit.buff_list
  for i, buff in ipairs(buff_list) do
    local shield_value = buff.shield or 0
    shield_value_total = shield_value_total + shield_value
  end
  return shield_value_total
end

function GetValueMax(bar)
  return bar.unit.maxShield or bar.unit.attribs.HP
end

module("ed.FloatingBarType.Fury", package.seeall)

function InitValuePercent(bar)
  bar.value = 1000
  bar.value_max = 1000
  bar.percent = 1
  bar.force_hide = true
  return 0
end

function GetValue(bar)
  return bar.unit:getFuryValue() or 0
end

function GetValueMax(bar)
  return bar.value_max
end

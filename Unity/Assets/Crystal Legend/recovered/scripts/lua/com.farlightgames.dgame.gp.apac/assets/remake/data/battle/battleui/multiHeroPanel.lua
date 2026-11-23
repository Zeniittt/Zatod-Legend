local class = newclass("g")
ed.ui.multiHeroPanel = class

function class.create()
  local self = setmetatable({}, {__index = class})
  self:init()
  return self
end

function class:init()
  self.rebornTime = ed.engine.stage_info["Reborn Time"] or 0
  self.unitIconList = {}
  self:initView()
end

function class:initView()
  local container = ed.createSprite()
  local _, ui = ed.editorui(ed.uieditor.multi_hero_panel, {container = container})
  container:setContentSize(ui.image_bg:getContentSize())
  ed.layout.centerInParent(ui.image_bg)
  self.ui = ui
  self.container = container
  self:adaptUI()
  ed.setLabelStroke(self.ui.label_left, ed.toccc3(3152916), 1)
  ed.setLabelStroke(self.ui.label_right, ed.toccc3(3152916), 1)
  ed.setLabelDimensions(self.ui.label_left, CCSizeMake(15, 0))
  ed.setLabelDimensions(self.ui.label_right, CCSizeMake(15, 0))
end

function class:adaptUI()
end

function class:initHeroList()
  local col = 8
  local playerUnit = 0
  local enemyUnit = 0
  local panelSize = self.ui.panel_hero_list_left:getContentSize()
  local iconSize = CCSizeMake(50, 50)
  self.iconSize = iconSize
  for i, unit in ipairs(ed.engine.unit_list) do
    if not unit.config.is_summoned then
      local camp = unit.camp
      local unique_id = unit.unique_id
      local heroIcon = self:createHeroIcon(unit)
      if camp == ed.emCampPlayer then
        self.ui.panel_hero_list_left:addChild(heroIcon)
        heroIcon:setPosition(ccp(iconSize.width * (playerUnit % col) + iconSize.width / 2, panelSize.height - math.floor(playerUnit / col) * iconSize.height - iconSize.height / 2))
        playerUnit = playerUnit + 1
      elseif camp == ed.emCampEnemy then
        self.ui.panel_hero_list_right:addChild(heroIcon)
        heroIcon:setPosition(ccp(iconSize.width * (enemyUnit % col) + iconSize.width / 2, panelSize.height - math.floor(enemyUnit / col) * iconSize.height - iconSize.height / 2))
        enemyUnit = enemyUnit + 1
      end
      heroIcon.unit = unit
      table.insert(self.unitIconList, heroIcon)
    end
  end
end

function class:createHeroIcon(unit)
  local bg = ed.createSprite()
  local bgSize = self.iconSize
  bg:setContentSize(bgSize)
  local icon = ed.readhero.getIcon({
    id = unit.tid,
    level = unit.level,
    stars = unit.stars,
    length = 45,
    rank = unit.rank,
    fashion_id = unit.fashion_id,
    summary = unit.proto,
    shard = unit.proto._shard
  })
  icon:setScale(0.55)
  icon:setPosition(ccp(bgSize.width / 2, bgSize.height / 2))
  bg:addChild(icon)
  local mask = CCLayerColor:create(ccc4(0, 0, 0, 178))
  mask:setContentSize(bgSize)
  mask:setPosition(ccp(0, 0))
  bg:addChild(mask)
  mask:setVisible(false)
  local label_cd = ed.createLabelTTF("", 17)
  label_cd:setColor(ccc3(184, 184, 184))
  label_cd:setStroke(ccc3(0, 0, 0), 1)
  mask:addChild(label_cd)
  label_cd:setPosition(ccp(bgSize.width / 2, bgSize.height / 2))
  if unit.displayBall then
    bg.ball_bar = ed.BallBarCreate(unit)
    bg.ball_bar.node:setPosition(ccp(0, 150))
    bg:addChild(bg.ball_bar.node, 2)
  end
  bg.icon = icon
  bg.mask = mask
  bg.label_cd = label_cd
  return bg
end

function class:update(dt)
  for index, heroIcon in ipairs(self.unitIconList) do
    local unit = heroIcon.unit
    if unit.reborn_unique_id then
      unit = self:findUnit(unit.reborn_unique_id)
      heroIcon.unit = unit
    end
    if unit then
      self:refreshHeroIcon(unit, heroIcon, dt)
      if unit.camp == ed.emCampPlayer then
        self:refreshCastSkill(unit, heroIcon)
      end
    end
  end
end

function class:checkManulCanCast(unit)
  local canCast = unit.can_cast_manual and ed.engine.running
  if ed.battle_tick.getRealTimePvp() and ed.engine.freeze_camp then
    return canCast and unit.camp == ed.engine.freeze_camp
  else
    return canCast
  end
end

function class:refreshCastSkill(unit, heroIcon)
  local newState
  if self:checkManulCanCast(unit) then
    newState = "cast"
  end
  if unit:canPanelTrigger() then
    newState = "trigger"
  end
  if newState == "cast" and unit:unitPanelIsSwitch() then
    newState = "switch"
  end
  if unit.controlledTarget then
    newState = nil
  end
  if heroIcon.state ~= newState then
    if newState == "cast" then
      heroIcon.skill_ready_timer = 0
    elseif newState == "trigger" then
      heroIcon.skill_ready_timer = 0
    elseif newState == "switch" then
      heroIcon.skill_ready_timer = 0
    end
    heroIcon.state = newState
  end
  if newState == "cast" or newState == "switch" then
    heroIcon.skill_ready_timer = heroIcon.skill_ready_timer + ed.tick_interval
    if heroIcon.skill_ready_timer > 0.5 and unit.manual_skill:willCast() then
      heroIcon.state = "nil"
      self:castHandler(unit)
      heroIcon.skill_ready_timer = 0
    end
  elseif newState == "trigger" and unit:shouldTrigger() then
    heroIcon.state = "nil"
    self:castHandler(unit)
  end
end

function class:castHandler(unit)
  ed.engine:manuallyCastSkill(unit)
end

function class:findUnit(unique_id)
  for index, unit in ipairs(ed.engine.unit_list) do
    if unique_id == unit.unique_id then
      if unit.reborn_unique_id then
        return self:findUnit(unit.reborn_unique_id)
      else
        return unit
      end
    end
  end
end

function class:refreshHeroIcon(unit, heroIcon, dt)
  if heroIcon.ball_bar then
    heroIcon.ball_bar:update(dt)
  end
  if not unit:isAlive() then
    heroIcon.mask:setVisible(true)
    if self.rebornTime > 0 then
      heroIcon.label_cd:setVisible(true)
      local die_tick = unit.die_tick or 0
      local ticks = ed.engine.ticks
      local leftTime = self.rebornTime - (ticks - die_tick) * ed.tick_interval
      leftTime = math.max(leftTime, 0)
      ed.setLabelString(heroIcon.label_cd, math.floor(leftTime))
    else
      heroIcon.label_cd:setVisible(false)
    end
  else
    heroIcon.mask:setVisible(false)
    heroIcon.label_cd:setVisible(false)
  end
end

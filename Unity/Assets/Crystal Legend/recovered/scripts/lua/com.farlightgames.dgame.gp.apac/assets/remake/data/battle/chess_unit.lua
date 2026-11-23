local base = ed.Unit
local ChessUnit = {
  mt = {}
}
ChessUnit.mt.__index = ChessUnit
setmetatable(ChessUnit, base.mt)
ed.ChessUnit = ChessUnit

function ChessUnit.mt:__tostring()
  local cdesc = string.format("%.1f", self.global_cd or 0)
  for i, skill in ipairs(self.skill_list or {}) do
    cdesc = string.format("%s|%.1f", cdesc, skill.cd_remaining)
  end
  local ballInfo = ""
  if self.deliveredBalls then
    for k, v in pairs(self.deliveredBalls) do
      ballInfo = ballInfo .. " " .. v.balltype
    end
  end
  local myballinfo = ""
  if self.energy_ball_manager then
    for k, v in pairs(self.energy_ball_manager.slots) do
      myballinfo = myballinfo .. " " .. v.ballType
    end
  end
  return string.format("%s*%dL%d\tHP:%.30f/%d\tMP:%d\t(%d, %d)\t%s\t@%s:%.1f [%s] %s%s%s%s%s%s  Ball:%s MyBalls:%s\n", self:display(), self.stars or 0, self.level or 0, self.hp or 0, self.attribs.HP or 0, self.mp or 0, self.position[1], self.position[2], ed.state_to_string[self.state] or "nil", self.action_name or "nil", self.action_elapsed or 0, cdesc, self.buff_effects.silence and "S" or "", self.buff_effects.disarm and "D" or "", self.buff_effects.immoblilize and "I" or "", (self.buff_effects.building or self.buff_effects.building_notfix) and "B" or "", self.buff_effects.stable and "ST" or "", self.buff_effects.fix and "F" or "", ballInfo, myballinfo)
end

local function getChessUnitInfo(hid)
  local uinfo = ed.lookupDataTable("ChessUnit", nil, hid)
  local info = {}
  for k, v in pairs(uinfo) do
    info[k] = v
  end
  info.rankInfo = nil
  info.nextRankInfo = nil
  return info
end

local function ChessUnitCreate(proto, camp, config, extraData)
  local self = ed.Entity.create()
  config = config or {}
  self.what = config.what or "ChessUnit"
  setmetatable(self, ChessUnit.mt)
  config.hp_mod = config.hp_mod or 1
  config.dps_mod = config.dps_mod or 1
  config.arm_mod = config.arm_mod or 1
  config.mr_mod = config.mr_mod or 1
  local scale = ed.engine.unitScale or 1
  config.size_mod = config.size_mod or scale
  config.money = config.money or 0
  self.mealParam = config.meal
  self.config = config
  self.dynaData = extraData
  self.proto = proto
  self.tid = proto._tid
  self.stars = 1
  self.level = 1
  self.insid = proto._insid or 0
  self.rank_ratio = 0
  self.still_show = proto.still_show or false
  self.show_tag = proto.show_tag or false
  self.show_pet = proto.show_pet or false
  self.pid = proto.pid
  self.info = getChessUnitInfo(proto._tid)
  self.rank = self.info["Chess Stars"]
  self.name = self.info.Name
  self.camp = camp or ed.emCampPlayer
  self.foecamp = -self.camp
  self.radius = self.info["Collide Radius"] * config.size_mod
  self.money = config.money
  self.equips = {}
  local current_puppet = self.info.Puppet
  self.puppet_stack = {current_puppet}
  self.previous_position = {0, 0}
  self.walk_v = {0, 0}
  self.fearVelocity = {0, 0}
  self.state = ed.emUnitStateBase
  self.buff_effects = {}
  self.fury_stack = {}
  self.knockup_time = -1
  self.knockup_v = {0, 0}
  self.attribs = {}
  self.region_list = {}
  self.orig_attribs = {}
  self.hp = 0
  self.mp = 0
  self.san_point = 1000
  self.walk_speed_multiplier = 1
  self.ai = ed.createChessAIForUnit(self)
  self.global_cd = 0
  self.current_skill = nil
  self.last_stolen_skill = nil
  self.last_stolen_skill_puppet = nil
  self.idleName = "Idle"
  self.manually_casting = false
  self.action_name = nil
  self.action_loop = false
  self.action_duration = 0
  self.action_elapsed = 0
  self.push_interval_tick = 4
  self.speeder = 1
  self.buff_list = {}
  self.buffManager = ed.BuffManagerCreate(self)
  self.hp_low = false
  self.mp_low = false
  self.actor = nil
  self.can_cast_manual = false
  self.walk_time = 0
  self.pet = nil
  self.hpLayer = self.info["HP Layers"]
  self.bossIconName = self.info["Boss Portrait"]
  self.actionStageId = self.info["Period Group"]
  self.dPSStatisticsRatio = self.info["DPS Statistics Ratio"] or 1
  self.battledata = battledata:new()
  self.killer = nil
  self.taunter = nil
  self.detaunter = nil
  self.firstManualCast = true
  self.controlTarget = nil
  self.controlCamp = nil
  self.controlledTarget = nil
  self:initChessPet()
  self:initSkill()
  self:rebuild("rebuild", self.mealParam)
  self:applyBuffEffects()
  self:initHpMpInfo()
  if not config.pre_select then
    local script = ed.getChessUnitScript(self.tid)
    if script then
      local init_func = require(script)
      if overwrite_unit_script[self.tid] then
        local func = overwrite_unit_script[self.tid]
        func()
      end
      self = init_func(self)
    end
  end
  self:idle()
  if self.actionStageId ~= nil then
    self:getActionStageInfo()
  end
  return self
end

function ChessUnit:initChessPet(...)
  local pet = self.proto._pet
  if not pet then
    return
  end
  self.pet = ed.chessPetCreate(pet, self.camp, {owner = self}, nil)
end

ChessUnit.create = ChessUnitCreate
ed.ChessUnitCreate = ChessUnitCreate

function ChessUnit:onUnitExitBattle(withEffect)
  self.state = ed.emUnitState_Dying
  self.terminated = true
  if self.current_skill then
    self.current_skill:interrupt()
  end
  if self.manually_casting then
    self.manually_casting = false
    ed.engine:unfreeze()
  end
  self:removeSignedBuffer()
  self.can_cast_manual = false
  self.walk_v = {0, 0}
  self.hp = 0
  self.mp = 0
  self.action_name = nil
  self.action_loop = false
  self.action_duration = 0
  self.action_elapsed = 0
  local origin = {
    self.position[1],
    self.position[2]
  }
  if ed.run_with_scene and false then
    local effect_name = "eff_point_mirror_die.cha"
    if effect_name then
      ed.scene:playEffectOnScene(effect_name, origin, {
        self.direction * 0.85,
        0.85
      }, nil, 1)
    end
  end
  ed.engine:onUnitExit(self)
  if self.actor then
    self.actor:onUnitExit()
  end
  if self.pet then
    local actor = self.pet.actor
    local is = actor and actor.node:setVisible(false)
  end
end

function ChessUnit:initSkill()
  self.manual_skill = nil
  self.skill_list = {}
  self.passive_skill_list = {}
  self.aura_skill_list = {}
  self.effect_enemy_aura_skill_list = {}
  self.skills = {}
  self.attack_range = 0
  local config = self.config
  local info = self.info
  local skill_list = self.skill_list
  local skills = self.skills
  local uid = self.info["Hero ID"]
  local rankInfo = info.rankInfo
  local SKL = rankInfo and rankInfo.SKL or 0
  for slot, group in pairs(ed.getDataTable("ChessSkillGroup")[uid]) do
    for _, v in pairs(group) do
      group = v
    end
    local unlock = group.Unlock
    if config.is_monster then
      unlock = group["Unlock For Monster"]
    end
    if config.is_summoned_by_DS then
      unlock = group["Unlock For summoned_by_DS"]
    end
    if unlock > self.rank then
    else
      local skill_level = 0
      if config.estimate_max_rank then
        skill_level = math.floor(self.level) + SKL
      elseif config.estimate_skill then
        skill_level = math.floor(self.level)
      elseif self.proto._skill_levels then
        skill_level = (self.proto._skill_levels[slot] or 0) + SKL
        local parentSkill = group["Subordinate To"]
        if parentSkill ~= 0 then
          local newSlot = ed.getSkillSlotId(uid, parentSkill)
          skill_level = (self.proto._skill_levels[newSlot] or 0) + SKL
        end
      end
      if group["Skill Group ID"] == info["Basic Skill"] then
        skill_level = 1
      end
      if skill_level <= 0 then
      else
        local skill_info = ed.Skill.getChessSkillInfo(group, self.rank)
        if skill_info["Not For PutdownMode"] and (ed.engine:isTowerWarsMode() or ed.IsMultiArena()) then
        else
          local active_type = skill_info["Active Type"]
          if active_type == "active" then
            local skill = ed.SkillCreate(skill_info, self, skill_level)
            table.insert(skill_list, skill)
            skills[skill.info["Skill Group ID"]] = skill
            skills[skill.info["Skill Name"]] = skill
            if skill_info.Manual then
              self.manual_skill = skill
            end
          elseif active_type == "passive" then
            table.insert(self.passive_skill_list, skill_info)
          elseif active_type == "aura" then
            table.insert(self.aura_skill_list, skill_info)
          elseif active_type == "negative_aura" then
            table.insert(self.effect_enemy_aura_skill_list, skill_info)
          end
        end
      end
    end
  end
  if self.what == "petUnit" then
  else
    local basic_skill = skills[info["Basic Skill"]]
    self.basic_skill = basic_skill
    self.attack_range = basic_skill.info["Max Range"] - 5
  end
  self:sortActiveSkill()
end

function ChessUnit:enterActionStage(nStage)
  if self.actionStageId then
    local stageData = ed.lookupDataTable("ChessPeriod", nil, self.actionStageId, nStage)
    if stageData then
      print("enterActionStage nStage -> " .. nStage)
      local puppetName = stageData["Puppet ID"]
      self:rewritePuppetStack(1, puppetName)
      self:resetSkillList(stageData)
      local translationActionName = stageData["Enter Action"]
      if translationActionName and translationActionName ~= "" then
        self:setAction(translationActionName)
      end
    end
  end
end

function ChessUnit:getActionStageInfo()
  if self.actionStageId then
    local nStage = 1
    self.actionStageInfos = {}
    while true do
      local stageData = ed.lookupDataTable("ChessPeriod", nil, self.actionStageId, nStage)
      if stageData then
        table.insert(self.actionStageInfos, stageData)
        nStage = nStage + 1
      else
        break
      end
    end
  end
end

local gravity = -1800

function ChessUnit:update(dt)
  local attribs = self.attribs
  local MSPD = attribs.MSPD
  if self.manually_casting or self.current_skill and self.current_skill.info["No Speeder"] then
    MSPD = 0
  end
  if self.config.is_boss and MSPD < -75 then
    attribs.MSPD = -75
  end
  MSPD = attribs.MSPD
  local speeder = 0 <= MSPD and (MSPD + 100) / 100 or 100 / (100 - MSPD)
  self.speeder = speeder
  local dt_action = dt * speeder
  self.dt_action = dt_action
  local action_end = false
  if self.action_name and not self.action_loop then
    local elapsed = self.action_elapsed + dt_action
    local duration = self.action_duration
    if 0 < duration and elapsed > duration then
      action_end = true
      elapsed = elapsed - duration
      self:onActionFinished()
    end
    self.action_elapsed = elapsed
  end
  if not self:isAlive() then
    return
  end
  if self.state == ed.emUnitState_Walk and self.controlledTarget then
    self.walk_time = self.walk_time - dt_action
    if 0 > self.walk_time then
      self:onActionFinished()
    end
  end
  local movable = not self.buff_effects.immoblilize
  if self.buff_effects.fear and movable and not self.buff_effects.stable then
    self:fearWalk()
  end
  local pos = self.position
  self.previous_position[1] = self.position[1]
  self.previous_position[2] = self.position[2]
  local v1 = movable and self.walk_v or ed.edpZero
  local v2 = self.knockup_v
  local v = self.velocity
  v[1] = v1[1] + v2[1]
  v[2] = v1[2] + v2[2]
  if self.buff_effects.fix then
    self.direction = self:getFixDir()
  else
    local direction = 0
    if movable and v1[1] ~= 0 then
      direction = v1[1]
    elseif self.current_skill and self.current_skill.target and not self.current_skill.casterDirectionLocked then
      direction = self.current_skill.target.position[1] - pos[1]
    end
    if 0 > direction * self.direction then
      self.direction = self.direction * -1
    end
  end
  if 0 < self.knockup_time then
    self.knockup_time = self.knockup_time - dt
    if 0 >= self.knockup_time then
      self.knockup_v = {0, 0}
    end
  end
  local h = self.height
  if self.zSpeed then
    h = self.height + self.zSpeed * dt
    self.zSpeed = self.zSpeed + gravity * dt
    if h < 0 then
      self.zSpeed = nil
      h = 0
    end
    self.height = h
  end
  local stage_rect = ed.engine.stage_rect
  if not self.manual_moving and (pos[1] > stage_rect.maxX - 50 and 0 < v[1] or pos[1] < stage_rect.minX + 50 and 0 > v[1]) then
    v[1] = 0
  end
  pos[1] = pos[1] + v[1] * dt_action
  pos[2] = pos[2] + v[2] * dt_action
  self:checkPush()
  do
    local HAST = attribs.HAST
    if self.config.is_boss and HAST < -50 then
      attribs.HAST = -50
    end
    HAST = attribs.HAST
    local dt_cd = dt * (0 < HAST and (100 + HAST) / 100 or 100 / (100 - HAST))
    self.global_cd = self.global_cd - dt_cd
    local skill_list = self.skill_list
    for i = 1, #skill_list do
      skill_list[i]:update(dt_action, dt_cd)
    end
  end
  if action_end and self.state == ed.emUnitState_Attack then
    self.current_skill:onPhaseFinished()
  end
  self:updateActionStage()
  local buff_effects = self.buff_effects
  local enable_ai = self.state == ed.emUnitState_Idle or self.state == ed.emUnitState_Walk
  local enable_skill_ai
  if self.SpecialCheckEnableAi and self:SpecialCheckEnableAi() then
    enable_skill_ai = true
  end
  enable_ai = enable_ai and not buff_effects.disableAI
  enable_ai = enable_ai and ed.engine.freeze_level == 0
  enable_skill_ai = enable_skill_ai and not buff_effects.disableAI
  enable_skill_ai = enable_skill_ai and ed.engine.freeze_level == 0
  if enable_ai then
    self.ai:update(dt)
  elseif enable_skill_ai then
    self.ai:updateSkillAi(dt)
  end
  for _, buff in ipairs(self.buff_list) do
    buff:update(dt)
  end
  if not self:isAlive() then
    return
  end
  local mp_regen = attribs.MPR
  self:setMP(self.mp + mp_regen * dt * ed.engine.mp_bonus)
  if not self.buff_effects.noHPR then
    local hp_regen = attribs.HPR
    if self.what == "lordUnit" then
      hp_regen = hp_regen * self.heal_ratio
    end
    if self.Reverse_Heal == true and 0 < hp_regen then
      hp_regen = hp_regen * -1 * self.ReverseHealRatio
    end
    if hp_regen < 0 or not self.buff_effects.unheal then
      self:setHP(self.hp + hp_regen * dt)
    end
  end
  if self.hp == 0 then
    self.hp = 1
  end
  self.hp_low = self.hp / attribs.HP < 0.2
  if self.manual_skill then
    local target = self.ai.target
    local why
    self.can_cast_manual, why = self.manual_skill:canCastWithTarget(target)
  end
  if self.summon_oldcamp and self.config.summoner and not self.config.summoner.controlledTarget then
    self.camp = self.summon_oldcamp
  end
  if ed.engine.multiplayerMode or ed.engine.multistageTeamwork_mode or ed.engine.multi_mode then
    for _, skill in ipairs(self.skill_list) do
      local target = self.ai.target
      if target then
        skill:canCastWithTarget(target)
      end
    end
  end
  if self.interRuptSkill then
    self:skillInterRupt(self.interRuptSkill)
    self.interRuptSkill = nil
  end
  if self.pet then
    self.pet:update(dt)
  end
end

local class = ed.UnitActor

function class:onUnitExit()
  self.node:setVisible(false)
  self.is_terminated = true
  self.offline = true
  self.puppet:setLoop(false)
  self.velocity = {0, 0}
end

function class:removeStarNode()
  if self.starNode and not tolua.isnull(self.starNode) then
    self.starNode:removeFromParentAndCleanup(true)
  end
end

function class:addStarNode()
  if self.model.rank > 1 then
    self.starNode = CCNode:create()
    local offsetX = 10
    for i = 1, self.model.rank do
      local star = ed.createSprite("UI/alpha/1080P/common/detail_star.png")
      local starSize = star:getContentSize()
      star:setScale(0.4)
      star:setPositionX(offsetX)
      self.starNode:addChild(star)
      if i < 3 then
        offsetX = offsetX + starSize.width * 0.4
      end
    end
    self.starNode:setPosition(ccp(-offsetX / 2, 90))
    self.node:addChild(self.starNode, 999)
  end
end

function class:addTagNode()
  if self.model.show_tag then
    self.tagNodes = {}
    local tagNode = CCNode:create()
    local raceTags = ed.getChessUnitRaceTags(self.model.tid)
    local scale = 0.6
    local offsetX = 15
    for _, tag in pairs(raceTags) do
      local tagData = ed.getDataTable("ChessTags")[tag]
      local tagSprite = ed.createSprite(tagData.Sign)
      local tagSize = tagSprite:getContentSize()
      tagSprite:setAnchorPoint(ccp(0.5, 0.5))
      tagSprite:setPosition(ccp(offsetX, 0))
      tagSprite:setScale(scale)
      tagNode:addChild(tagSprite)
      self.tagNodes[tag] = tagSprite
      offsetX = offsetX + tagSize.width * scale
    end
    local abilityTags = ed.getChessUnitAbilityTags(self.model.tid)
    for _, tag in pairs(abilityTags) do
      local tagData = ed.getDataTable("ChessTags")[tag]
      local tagSprite = ed.createSprite(tagData.Sign)
      local tagSize = tagSprite:getContentSize()
      tagSprite:setAnchorPoint(ccp(0.5, 0.5))
      tagSprite:setPosition(ccp(offsetX, 0))
      tagSprite:setScale(scale)
      tagNode:addChild(tagSprite)
      self.tagNodes[tag] = tagSprite
      offsetX = offsetX + tagSize.width * scale
    end
    tagNode:setPosition(ccp(-offsetX / 2, 70))
    self.node:addChild(tagNode, 999)
  end
end

function class:addPetNode()
  if self.model.show_pet and self.model.pid then
    local petId = self.model.pid
    local petNode = CCNode:create()
    local petIcon = ed.readpet.createChessIcon({type = petId})
    petIcon.icon:setScale(0.2)
    petIcon.icon:setPosition(ccp(-26, 90))
    petNode:addChild(petIcon.icon)
    self.node:addChild(petNode, 999)
  end
end

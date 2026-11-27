module("ed.battlehero", package.seeall)
local ed = ed
ChessDOOM = {}
ChessDOOM.name = "DOOM"

function ChessDOOM.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  if ed.run_with_scene then
    local effect_night = "eff_point_DOOM_ult.cha"
    local origin = {400, 0}
    ed.scene:playEffectOnScene(effect_night, origin, nil, nil, -1)
  end
end

function ChessDOOM.ult_buff_onRemoved(basefunc, buff)
  basefunc(buff)
end

function ChessDOOM.ult_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.owner and buff.owner.hp <= 1 then
    for i, tbuff in ipairs(buff.owner.buff_list) do
      if tbuff.info.ID == 7009 then
        local ownerPopupPervious = buff.owner.notPopupBattleInfo
        buff.owner.notPopupBattleInfo = true
        local hprPerDt = -buff.info.HPR * dt
        buff.owner:takeDamage(hprPerDt, "Holy", "hp", buff.caster, nil, 0, true)
        buff.owner.notPopupBattleInfo = ownerPopupPervious
        break
      end
    end
  end
end

function ChessDOOM.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  return buff
end

function ChessDOOM.skillult_selectTarget(basefunc, self, default)
  local target_type = self.info["Target Type"]
  local selector = self:target_selector()
  if target_type == "target" then
    if default then
      self.target = default
    else
      local t, distanceSQ = self.caster.ai:searchTarget()
      if distanceSQ <= self.max_range_sq then
        self.target = t
      else
        self.target = nil
      end
    end
  elseif target_type == "self" then
    self.target = self.caster
  elseif selector then
    local max = -math.huge
    local chosen
    local caster = self.caster
    local caster_position = caster.position
    local enchanted = caster.buff_effects.enchanted
    for unit in ed.engine:foreachAliveUnit(self:targetCamp()) do
      local undoom
      if unit then
        for i, tbuff in ipairs(unit.buff_list) do
          if tbuff.info.ID == 7009 then
            undoom = 1
            break
          end
        end
      end
      if undoom then
      elseif unit.buff_effects.untargetable then
      elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
      elseif unit.buff_effects.invulnerable then
      elseif enchanted and unit == caster then
      else
        local distanceSQ = (unit.position[1] - caster_position[1]) ^ 2 + (unit.position[2] - caster_position[2]) ^ 2
        if distanceSQ >= self.min_range_sq and distanceSQ <= self.max_range_sq then
          local v = selector(unit)
          if not unit.config.is_summoned and chosen and chosen.config.is_summoned then
            max = v
            chosen = unit
          elseif v > max then
            max = v
            chosen = unit
          end
        end
      end
    end
    self.target = chosen
  else
    EDDebug("Unkonwn target type: " .. target_type)
  end
  return self.target
end

function ChessDOOM.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  local undoom
  if target then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 7009 then
        undoom = 1
        break
      end
    end
  end
  if not basefunc(skill, target) or hero.name == "DOOM" and hero.mp < 1000 or hero.manually_casting or undoom then
    return false
  end
  return true
end

function ChessDOOM.init_hero(hero)
  local skillult = hero.skills.DOOM_ult
  if skillult then
    skillult.createBuff = override(skillult.createBuff, ChessDOOM.skillult_createBuff)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, ChessDOOM.skillult_canCastWithTarget)
    skillult.selectTarget = override(skillult.selectTarget, ChessDOOM.skillult_selectTarget)
    skillult.start = override(skillult.start, ChessDOOM.skillult_start)
  end
  return hero
end

return ChessDOOM.init_hero

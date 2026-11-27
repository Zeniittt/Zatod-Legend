module("ed.battlehero", package.seeall)
local ed = ed
TitanBarbarian = {}

function TitanBarbarian.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillatk2 = hero.skills.TitanBarbarian_atk2
  hero.TitanBarbarian_atk3buff = nil
end

function TitanBarbarian.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanBarbarian_atk4
  local dmg, hit = basefunc(skill, target, source, shift)
  local base_ratio = skillatk4.info["Script Arg2"] * 0.01
  local extra_ratio = 0
  local d_str = caster.attribs.STR - target.attribs.STR
  if d_str >= caster.attribs.STR * 0.2 then
    extra_ratio = 1
  elseif 0 < d_str then
    extra_ratio = d_str / (caster.attribs.STR * 0.4)
  end
  local ratio = not (not target or target.config.is_boss) and math.min(1, extra_ratio + base_ratio) or 0.33
  if hit and ratio > ed.rand() and target:isAlive() then
    if target.current_skill then
      target.current_skill:interrupt()
    end
    if target.actor and target.actor.puppet then
      target.actor.puppet:interruptSound()
    end
    target:setAction("Damaged", false, true)
    target.state = ed.emUnitState_Hurt
    target.walk_v = {0, 0}
    target:takeDamage(skillatk4.info["Script Arg3"] * (0.8 + ed.rand() * 0.4), "Holy", "hp", caster)
    local bid = 4511
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, caster)
    if caster.TitanBarbarian_hasArcana and caster.TitanBarbarian_hasArcana > 3 and target:isAlive() then
      target:takeDamage(150, "Holy", "mp", caster)
    end
  end
end

function TitanBarbarian.getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source)
  local lost = basefunc(hero, damage, immunity, damage_type, source)
  if lost and 0 < lost and hero.TitanBarbarian_atk3buff and hero.TitanBarbarian_atk3shield then
    local resist_value = hero.TitanBarbarian_atk3shield
    if lost >= resist_value then
      lost = lost - resist_value
      hero.TitanBarbarian_atk3shield = 0
      hero:removeBuff(hero.TitanBarbarian_atk3buff)
    else
      hero.TitanBarbarian_atk3shield = hero.TitanBarbarian_atk3shield - lost
      lost = 0
      if hero.actor then
        local color = hero.camp == ed.emCampPlayer and "blue" or "red"
        ed.PopupCreate("immune", color, hero.actor, nil, "text")
      end
    end
  end
  return lost
end

function TitanBarbarian.skillatk2_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 0 then
    basefunc(skill)
  elseif attack_counter == 1 and caster.TitanBarbarian_hasArcana and 1 < caster.TitanBarbarian_hasArcana then
    local bid = 4512
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
  end
end

function TitanBarbarian.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4509
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanBarbarian.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4509 then
      tbuff.timer = 0
    end
  end
end

function TitanBarbarian.skillatk3_onAttackFrame(basefunc, skill)
  local attack_counter = skill.attack_counter
  local caster = skill.caster
  if attack_counter == 0 then
    basefunc(skill)
  end
end

function TitanBarbarian.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local shield = skill.info["Script Arg2"] + caster.attribs.STR * 8.5
  caster.TitanBarbarian_atk3buff = buff
  caster.TitanBarbarian_atk3shield = math.min(400000, shield)
  buff.onRemoved = override(buff.onRemoved, TitanBarbarian.skillatk3_buff_onRemoved)
  return buff
end

function TitanBarbarian.skillatk3_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local skillatk3 = caster.skills.TitanBarbarian_atk3
  caster.TitanBarbarian_atk3buff = nil
  if caster.TitanBarbarian_atk3shield > 0 and caster:isAlive() then
    local extra_heal = skillatk3.info["Script Arg3"]
    caster:takeHeal(extra_heal + caster.TitanBarbarian_atk3shield, "hp", caster)
    caster.TitanBarbarian_atk3shield = 0
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_heal.cha", caster.position, {1, 1}, nil, 1)
    end
  end
end

function TitanBarbarian.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local skillults = caster.skills.TitanBarbarian_ults
  basefunc(skill)
  if caster.TitanBarbarian_hasArcana and caster.TitanBarbarian_hasArcana > 2 and skillults then
    skillults:takeEffectAt(caster.position, caster)
  end
end

function TitanBarbarian.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function TitanBarbarian.skillult_takeEffectOn(basefunc, skill, target, source)
  local result = basefunc(skill, target, source)
  local caster = skill.caster
  local hpadd = skill.info["Script Arg2"] + caster.attribs.STR * 3.5
  if not result or target:isAlive() then
  end
end

function TitanBarbarian.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local hpadd = skill.info["Script Arg2"] + caster.attribs.STR * 3.5
  if target and not target.TitanBarbarian_ult_rank then
    target.TitanBarbarian_ult_rank = 1
  elseif target then
    target.TitanBarbarian_ult_rank = target.TitanBarbarian_ult_rank + 1
  end
  if not target or target.TitanBarbarian_ult_rank then
  end
  buff.update = override(buff.update, TitanBarbarian.skillult_buff_update)
  return buff
end

function TitanBarbarian.skillult_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillult = caster.skills.TitanBarbarian_ult
  local hpadd = math.min(skillult.info["Script Arg2"] + caster.attribs.STR * 3.5, 200000)
  if owner.TitanBarbarian_ult_rank and not owner.config.is_summoned and owner.TitanBarbarian_ult_rank ~= owner.TitanBarbarian_ult_lastrank then
    buff:setAttribute("HP", hpadd * math.min(owner.TitanBarbarian_ult_rank, 3))
    owner.TitanBarbarian_ult_lastrank = owner.TitanBarbarian_ult_rank
    owner:resetBuffApply(buff)
    owner:takeHeal(hpadd * 2, "hp", caster)
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_BR_ult_lvup.cha", owner.position, {1, 1}, nil, 1)
    end
  end
end

function TitanBarbarian.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4509
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function TitanBarbarian.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4509 then
      tbuff.timer = 0
    end
  end
end

function TitanBarbarian.getRuntimeScale(basefunc, self)
  if self.isScaleActionRunning then
    local dt = self.dt_action
    self.scaleActionRunningTime = self.scaleActionRunningTime + dt
    if self.scaleActionRunningTime > self.scaleActionDuration then
      local scale = self.scaleActionScaleValue
      return self.direction * scale, scale
    else
      local scale = self.scaleActionRunningTime / self.scaleActionDuration * (self.scaleActionScaleValue - 1) + 1
      return self.direction * scale, scale
    end
  end
  if not self.isScaleActionRunning then
    local m = self.manually_casting
    return self.direction * (m and 1 or 1), m and 1 or 1
  end
end

function TitanBarbarian.init_hero(hero)
  local skillult = hero.skills.TitanBarbarian_ult
  local skillults = hero.skills.TitanBarbarian_ults
  local skillatk = hero.skills.TitanBarbarian_atk
  local skillatk2 = hero.skills.TitanBarbarian_atk2
  local skillatk3 = hero.skills.TitanBarbarian_atk3
  local skillatk4 = hero.skills.TitanBarbarian_atk4
  hero.TitanBarbarian_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk and skillatk4 then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, TitanBarbarian.skillatk_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, TitanBarbarian.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanBarbarian.skillatk3_start)
    skillatk3.finish = override(skillatk3.finish, TitanBarbarian.skillatk3_finish)
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, TitanBarbarian.skillatk3_onAttackFrame)
    skillatk3.createBuff = override(skillatk3.createBuff, TitanBarbarian.skillatk3_createBuff)
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, TitanBarbarian.getLostHPAfterImmunity)
  end
  if skillult then
    skillult.createBuff = override(skillult.createBuff, TitanBarbarian.skillult_createBuff)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanBarbarian.skillult_onAttackFrame)
    skillult.takeEffectOn = override(skillult.takeEffectOn, TitanBarbarian.skillult_takeEffectOn)
    skillult.start = override(skillult.start, TitanBarbarian.skillult_start)
    skillult.finish = override(skillult.finish, TitanBarbarian.skillult_finish)
    hero.getRuntimeScale = override(hero.getRuntimeScale, TitanBarbarian.getRuntimeScale)
  end
  if skillults then
    skillults.createBuff = override(skillults.createBuff, TitanBarbarian.skillults_createBuff)
  end
  hero.reset = override(hero.reset, TitanBarbarian.hero_reset)
  return hero
end

return TitanBarbarian.init_hero

module("ed.battlehero", package.seeall)
local ed = ed
TitanGC = {}
TitanGC.skillult_stunBid = 4676
TitanGC.charge_speed = 250

function TitanGC.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  basefunc(skill, target)
  if caster and target then
    local bid = TitanGC.skillult_stunBid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = target:addBuff(binfo, caster)
    local bid = 4680
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
  end
end

function TitanGC.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  if caster and buff and caster.TitanGC_hasArcana and caster.TitanGC_hasArcana >= 4 then
    buff.timer = buff.timer + 2
  end
  return buff
end

function TitanGC.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillult = skill
  local attackCounter = skill.attack_counter
  local target = skill.target
  if skill and caster then
    if attackCounter == 0 and target then
      if target.position[1] >= caster.position[1] then
        caster.charge_direction = 1
      else
        caster.charge_direction = -1
      end
      caster.orig_walkV = caster.walk_v
      local target_pos = target.position
      caster:setPosition({
        target_pos[1] - 200 * caster.charge_direction,
        target_pos[2]
      })
      if skill.caster.manually_casting then
        ed.engine:unfreeze()
        skill.caster.manually_casting = false
      end
      skill.attack_counter = skill.attack_counter + 1
    end
    if attackCounter == 1 and target then
      local target_pos = target.position
      if target then
        skillult:takeEffectAt(target_pos, caster)
      end
      caster.walk_v = caster.orig_walkV
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function TitanGC.skillult_finish(basefunc, skill)
  local caster = skill.caster
  local target = skill.target
  if target then
    local target_pos = caster.position
    caster:setPosition({
      target_pos[1] + 200 * caster.direction,
      target_pos[2]
    })
  end
  if caster then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 4680 then
        tbuff.timer = -1
      end
    end
  end
  caster.walk_v = caster.orig_walkV
  basefunc(skill)
end

function TitanGC.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = buff.caster
  buff.onDamaged = override(buff.onDamaged, TitanGC.atk3Buff_ondamaged)
  return buff
end

function TitanGC.atk3Buff_ondamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local caster = buff.caster
  local owner = buff.owner
  if damage and source and not transferred and damage_type and damage_type ~= "Holy" then
    local skillatk3 = caster.skills.TitanGC_atk3
    local MP_Lost = skillatk3.info["Script Arg2"]
    local MP_ratio = skillatk3.info["Script Arg3"]
    source:takeDamage(MP_Lost, "Holy", "mp", caster, 1, 1, true)
    owner:takeHeal(MP_Lost * MP_ratio, "mp", caster)
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred)
end

function TitanGC.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster then
    local bid = 4680
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = caster:addBuff(binfo, caster)
  end
end

function TitanGC.skillatk4_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanGC_atk4
  local Damage_rato = skillatk4.info["Script Arg2"]
  if caster.atk4_iscasting == true then
    if caster.TitanGC_hasArcana and caster.TitanGC_hasArcana >= 3 then
      Damage_rato = Damage_rato * 1.2
    end
    power = (power + caster.atk4_tauntDamage) * Damage_rato
  end
  return power, i
end

function TitanGC.skillatk4_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanGC_atk4
  local skillatk4a = caster.skills.TitanGC_atk4a
  local attack_counter = skill.attack_counter
  if attack_counter == 0 and skillatk4a then
    basefunc(skill)
    skillatk4a.target = caster
    local TitanGC_region = skillatk4a:createRegion()
    TitanGC_region.position = caster.position
    caster.TitanGC_region = TitanGC_region
    ed.engine:addRegion(TitanGC_region)
    caster.atk4_iscasting = true
  elseif attack_counter == 1 then
    skillatk4:takeEffectAt(caster.position, caster)
    if caster.TitanGC_hasArcana and caster.TitanGC_hasArcana < 3 and not caster.config.is_boss then
      caster:takeHeal(caster.atk4_tauntDamage, "hp", caster)
    end
    caster.atk4_iscasting = false
    caster.atk4_tauntDamage = 0
  end
end

function TitanGC.skillatk4_finish(basefunc, skill, reason)
  basefunc(skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.TitanGC_atk4
  if reason == "interrupt" then
    skillatk4:takeEffectAt(caster.position, caster)
  end
  caster.atk4_iscasting = false
  caster.atk4_tauntDamage = 0
  if caster then
    for i, tbuff in ipairs(caster.buff_list) do
      if tbuff.info.ID == 4680 then
        tbuff.timer = -1
      end
    end
  end
end

function TitanGC.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local damage, bc = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local skillatk4 = self.skills.TitanGC_atk4
  if skillatk4 and self.atk4_iscasting and damage and not transferred then
    self.atk4_tauntDamage = damage + self.atk4_tauntDamage
    self.atk4_tauntDamage = math.min(self.atk4_tauntDamage, 300000)
    if self.TitanGC_hasArcana and self.TitanGC_hasArcana >= 3 and not self.config.is_boss then
      self:takeHeal(damage, "hp", self)
    end
  end
  return damage, bc
end

function TitanGC.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillult = hero.skills.TitanGC_ult
  local skillatk2 = hero.skills.TitanGC_atk2
  local skillatk3 = hero.skills.TitanGC_atk3
  local skillatk4 = hero.skills.TitanGC_atk4
  if not hero.TitanGC_startTime then
    hero.TitanGC_startTime = 0
  end
  hero.TitanGC_startTime = hero.TitanGC_startTime and hero.TitanGC_startTime + dt or dt
  if hero.TitanGC_startTime == dt and skillatk3 and skillult then
    if hero.TitanGC_hasArcana and hero.TitanGC_hasArcana >= 2 then
      skillatk3:takeEffectOn(hero)
    end
    if hero.TitanGC_hasArcana and hero.TitanGC_hasArcana >= 4 then
      local originfo = skillult.info
      skillult.info = ed.wraptable(originfo, {
        ["No Dodge"] = true,
        ["Shape Arg1"] = 335
      })
    else
      local originfo = skillult.info
      skillult.info = ed.wraptable(originfo, {
        ["No Dodge"] = true
      })
    end
  end
end

function TitanGC.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.atk4_iscasting = false
  hero.atk4_tauntDamage = 0
  hero.TitanGC_startTime = 0
end

function TitanGC.init_hero(hero)
  local skillult = hero.skills.TitanGC_ult
  local skillatk2 = hero.skills.TitanGC_atk2
  local skillatk3 = hero.skills.TitanGC_atk3
  local skillatk4 = hero.skills.TitanGC_atk4
  hero.TitanGC_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  hero.reset = override(hero.reset, TitanGC.hero_reset)
  hero.update = override(hero.update, TitanGC.hero_update)
  hero.takeDamage = override(hero.takeDamage, TitanGC.hero_takeDamage)
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, TitanGC.skillatk3_createBuff)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, TitanGC.skillatk4_start)
    skillatk4.power = override(skillatk4.power, TitanGC.skillatk4_power)
    skillatk4.finish = override(skillatk4.finish, TitanGC.skillatk4_finish)
    skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanGC.skillatk4_onAttackFrame)
  end
  if skillult then
    hero.ultOriginfo = skillult.info
    skillult.start = override(skillult.start, TitanGC.skillult_start)
    skillult.createBuff = override(skillult.createBuff, TitanGC.skillult_createBuff)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanGC.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, TitanGC.skillult_finish)
  end
  return hero
end

return TitanGC.init_hero

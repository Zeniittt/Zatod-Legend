module("ed.battlehero", package.seeall)
local ed = ed
GuildMountSF = {}
GuildMountSF.ultEvobuff = 10037303
GuildMountSF.atk2fear = 10037304

function GuildMountSF.update(basefunc, self, dt)
  basefunc(self, dt)
end

function GuildMountSF.reset(basefunc, unit)
  basefunc(unit)
  unit.dyingTimer_SF = nil
  local skillatk2 = unit.skills.SF_atk2
  if skillatk2 then
    skillatk2.currentNum = 0
  end
end

function GuildMountSF.skillatk2_finish(basefunc, skill)
  skill.currentNum = skill.currentNum + 1
  if skill.currentNum >= 3 then
    skill.currentNum = 0
    skill.cd_remaining = 15
  else
    skill.caster:castSkill(skill)
  end
  basefunc(skill)
end

function GuildMountSF.skillatk2_takeEffectAt(basefunc, skill, location, source)
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["X Shift"] = originfo["X Shift"] + skill.currentNum * 100
  })
  basefunc(skill, location, source)
  skill.info = originfo
end

function GuildMountSF.skillatk2_takeEffectOn(basefunc, skill, target)
  local isHit, dmg = basefunc(skill, target)
  local caster = skill.caster
  local rand = ed.rand()
  if isHit and caster:isAlive() then
    local skillatk3 = caster.skills.GuildMountSF_atk3
    local skillatk3s = caster.skills.GuildMountSF_atk3s
    if skillatk3 and not target.config.is_summoned then
      skillatk3:takeEffectOn(caster, caster)
    end
    if skillatk3 and target.camp ~= caster.camp and target.config.is_summoned and target.proto._tid ~= 194 and target.proto._tid ~= 205 and target.proto._tid ~= 212 and target.proto._tid ~= 206 then
      skillatk3s:takeEffectOn(caster, caster)
    end
    if 0.5 <= rand then
      local bid1 = GuildMountSF.atk2fear
      local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
      local buff1 = ed.BuffCreate(binfo1, target, caster)
      buff1:setAttribute("fearrange", 5)
      target:addBuff(buff1, caster)
    end
  end
  return isHit, dmg
end

function GuildMountSF.skillult_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local hero = self.caster
  local distance = ((target.position[1] - hero.position[1]) ^ 2 + (target.position[2] - hero.position[2]) ^ 2) ^ 0.5
  local distanceMAX = 400
  local SFultRatio = distanceMAX / distance
  local MaxRatio = 2
  if SFultRatio > MaxRatio then
    SFultRatio = MaxRatio
  elseif SFultRatio < 1 then
    SFultRatio = 1
  end
  local power = power * SFultRatio
  if hero.dyingTimer_SF then
    power = power * 0.8
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function GuildMountSF.skillult_takeEffectOn(basefunc, skill, target)
  local isHit, dmg = basefunc(skill, target)
  local caster = skill.caster
  if isHit and caster:isAlive() then
    local skillatk3 = caster.skills.GuildMountSF_atk3
    local skillatk3s = caster.skills.GuildMountSF_atk3s
    if skillatk3 and not target.config.is_summoned then
      skillatk3:takeEffectOn(caster, caster)
    end
    if skillatk3 and target.camp ~= caster.camp and target.config.is_summoned and target.proto._tid ~= 194 and target.proto._tid ~= 205 and target.proto._tid ~= 212 and target.proto._tid ~= 206 then
      skillatk3s:takeEffectOn(caster, caster)
    end
  end
  return isHit, dmg
end

function GuildMountSF.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function GuildMountSF.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local ad = buff.info.AD
  return buff
end

function GuildMountSF.init_hero(hero)
  if hero.name == "GuildMountSF" then
    hero.update = override(hero.update, GuildMountSF.update)
    hero.reset = override(hero.reset, GuildMountSF.reset)
  end
  local skillult = hero.skills.GuildMountSF_ult
  local skillatk2 = hero.skills.GuildMountSF_atk2
  local skillatk3 = hero.skills.GuildMountSF_atk3
  local skillemaura = hero.effect_enemy_aura_skill_list[1]
  if skillatk2 then
    skillatk2.takeEffectAt = override(skillatk2.takeEffectAt, GuildMountSF.skillatk2_takeEffectAt)
    skillatk2.finish = override(skillatk2.finish, GuildMountSF.skillatk2_finish)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, GuildMountSF.skillatk2_takeEffectOn)
    skillatk2.currentNum = 0
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, GuildMountSF.skillatk3_createBuff)
  end
  if skillult then
    skillult.getDamage = override(skillult.getDamage, GuildMountSF.skillult_getDamage)
    skillult.takeEffectOn = override(skillult.takeEffectOn, GuildMountSF.skillult_takeEffectOn)
    skillult.createBuff = override(skillult.createBuff, GuildMountSF.skillult_createBuff)
  end
  return hero
end

return GuildMountSF.init_hero

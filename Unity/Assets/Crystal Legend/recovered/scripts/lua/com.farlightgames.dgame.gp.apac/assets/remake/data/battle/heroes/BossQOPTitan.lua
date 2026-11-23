module("ed.battlehero", package.seeall)
local ed = ed
BossQOPTitan = {}

function BossQOPTitan.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local TotalDamage, bc = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  self.Gender = nil
  if type(struct_table) == "table" then
    if struct_table.source and struct_table.source.info.Gender == T("\231\148\183") then
      self.Gender = T("\231\148\183")
      if self.Gender == T("\231\148\183") then
        local rand = ed.rand()
        if 0.5 <= rand then
          TotalDamage = 0
          if do_battle_log then
            btlog("%s: %s --> %s (Miss!)", self:display(), self:display(), struct_table.source:display())
          end
          local bid = 4654
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          struct_table.source:addBuff(binfo, self)
        end
      end
    end
  elseif source and source.info.Gender == T("\231\148\183") then
    self.Gender = T("\231\148\183")
    if self.Gender == T("\231\148\183") then
      local rand = ed.rand()
      if 0.5 <= rand then
        TotalDamage = 0
        if do_battle_log then
          btlog("%s: %s --> %s (Miss!)", self:display(), self:display(), source:display())
        end
        local bid = 4654
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        source:addBuff(binfo, self)
      end
    end
  end
  return TotalDamage, bc
end

function BossQOPTitan.skill_getLostHPAfterImmunity(basefunc, self, damage, immunity)
  if self.Gender == T("\231\148\183") then
    local reduce = 0.3
    damage = damage * (1 - reduce)
  end
  return basefunc(self, damage, immunity)
end

function BossQOPTitan.skillult_power(basefunc, self, source, target, damage_type)
  local originfo = self.info
  local debuff_count = 0
  for _, buff in ipairs(target.buff_list) do
    if buff.caster and buff.caster.camp == self.caster.camp then
      debuff_count = debuff_count + 1
    end
  end
  if 10 < debuff_count then
    debuff_count = 10
  end
  self.info = ed.wraptable(originfo, {
    ["Basic Num"] = originfo["Basic Num"] + self.info["Script Arg2"] * debuff_count
  })
  local power, ret = basefunc(self, source, target, damage_type)
  if power and target and target.info.Gender and target.info.Gender == T("\231\148\183") then
    power = power * 1.3
  end
  self.info = originfo
  return power, ret
end

function BossQOPTitan.skillult_takeEffectAt(basefunc, self, location, source)
  local info = self.info
  local aoe = self.info["AOE Origin"]
  local direction = self.caster.direction
  self.curSkillCount = 0
  self.isEffectAt = true
  if aoe == "self" then
    location = self.caster.position
  end
  local origin = {
    location[1] + info["X Shift"] * direction,
    location[2]
  }
  local shape = info["AOE Shape"]
  local arg1 = info["Shape Arg1"]
  local arg2 = info["Shape Arg2"]
  for unit in ed.engine:foreachAliveUnit(self:affectedCamp()) do
    if (info["Damage Type"] == "AD" or info["Damage Type"] == "AP") and unit == self.caster then
    else
      local p2 = ed.edpSub(unit.position, origin)
      p2[1] = p2[1] * direction
      if ed.Skill.testPointInShape(p2, shape, arg1, arg2) then
        for _, buff in ipairs(unit.buff_list) do
          if buff.caster and buff.caster.camp == self.caster.camp then
            buff.timer = buff.timer + buff.info.Time * 0.25
          end
        end
      end
    end
  end
  return basefunc(self, location, source)
end

function BossQOPTitan.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4620
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function BossQOPTitan.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4620 then
      tbuff.timer = 0
    end
  end
end

function BossQOPTitan.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillults = caster.skills.BossQOPTitan_ults
  skillults:takeEffectAt(caster.position)
end

function BossQOPTitan.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function BossQOPTitan.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local bid = 71
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  caster:addBuff(binfo, caster)
end

function BossQOPTitan.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  if power and target and target.info.Gender and target.info.Gender == T("\231\148\183") then
    power = power * 1.3
  end
  return power
end

function BossQOPTitan.skillatk3_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local target_hasBadBuff = false
  if target then
    for _, buff in ipairs(target.buff_list) do
      if buff.caster and buff.caster.camp == skill.caster.camp then
        target_hasBadBuff = true
      end
    end
    if target_hasBadBuff and caster then
      local bid = 4653
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster:addBuff(binfo, caster)
      target:takeDamage(20000, "AP", "hp", caster)
    end
  end
end

function BossQOPTitan.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local lost = buff.info.HPR
  local caster = skill.caster
  if buff and target and target.info.Gender and target.info.Gender == T("\231\148\183") then
    buff:setAttribute("HPR", (lost + caster.attribs.AP * 0.08) * 1.3)
  else
    buff:setAttribute("HPR", lost + caster.attribs.AP * 0.08)
  end
  return buff
end

function BossQOPTitan.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  if power and target and target.info.Gender and target.info.Gender == T("\231\148\183") then
    power = power * 1.3
  end
  return power
end

function BossQOPTitan.skillatk2_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  local target_hasBadBuff = false
  if target then
    for _, buff in ipairs(target.buff_list) do
      if buff.caster and buff.caster.camp == skill.caster.camp then
        target_hasBadBuff = true
      end
    end
    if target_hasBadBuff and caster then
      local bid = 4653
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      caster:addBuff(binfo, caster)
      target:takeDamage(20000, "AP", "hp", caster)
    end
  end
end

function BossQOPTitan.init_hero(hero)
  local skillult = hero.skills.BossQOPTitan_ult
  local skillatk2 = hero.skills.BossQOPTitan_atk2
  local skillatk3 = hero.skills.BossQOPTitan_atk3
  local skillatk4 = hero.skills.BossQOPTitan_atk4
  local skillults = hero.skills.BossQOPTitan_ults
  hero.takeDamage = override(hero.takeDamage, BossQOPTitan.hero_takeDamage)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, BossQOPTitan.skill_getLostHPAfterImmunity)
  if skillatk2 then
    skillatk2.power = override(skillatk2.power, BossQOPTitan.skillatk2_power)
    skillatk2.createBuff = override(skillatk2.createBuff, BossQOPTitan.skillatk2_createBuff)
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, BossQOPTitan.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, BossQOPTitan.skillatk3_start)
    skillatk3.power = override(skillatk3.power, BossQOPTitan.skillatk3_power)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, BossQOPTitan.skillatk3_takeEffectOn)
  end
  if skillult then
    skillult.start = override(skillult.start, BossQOPTitan.skillult_start)
    skillult.finish = override(skillult.finish, BossQOPTitan.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, BossQOPTitan.skillult_onAttackFrame)
    skillult.power = override(skillult.power, BossQOPTitan.skillult_power)
    skillult.takeEffectAt = override(skillult.takeEffectAt, BossQOPTitan.skillult_takeEffectAt)
  end
  if skillults then
    skillults.createBuff = override(skillults.createBuff, BossQOPTitan.skillults_createBuff)
  end
  return hero
end

return BossQOPTitan.init_hero

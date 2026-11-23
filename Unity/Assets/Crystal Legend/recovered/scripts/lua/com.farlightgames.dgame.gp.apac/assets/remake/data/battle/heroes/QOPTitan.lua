module("ed.battlehero", package.seeall)
local ed = ed
QOPTitan = {}
QOPTitan.QOPTitan_fashionID = 101491

function QOPTitan.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  local bid = 71
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  caster:addBuff(binfo, caster)
end

function QOPTitan.hero_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  self.Gender = nil
  local damage, bc = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  if type(struct_table) == "table" then
    if struct_table.source then
      local source = struct_table.source
      if struct_table.source.info.Gender == T("\231\148\183") then
        self.Gender = T("\231\148\183")
      end
      if damage and bc and QOPTitan.QOPTitan_fashionID and QOPTitan.QOPTitan_fashionID == self.fashion_id and self.fashionSKillcanCast then
        local bid = 4718
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = source:addBuff(binfo, self)
        if struct_table.source.info.Gender == T("\231\148\183") then
          source:takeDamage(damage * 0.3, "AP", "hp", self, 1, 1)
        end
        self.fashionSKillcanCast = false
      end
    end
  elseif source then
    if source.info.Gender == T("\231\148\183") then
      self.Gender = T("\231\148\183")
    end
    if damage and bc and QOPTitan.QOPTitan_fashionID and QOPTitan.QOPTitan_fashionID == self.fashion_id and self.fashionSKillcanCast then
      local bid = 4718
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = source:addBuff(binfo, self)
      if source.info.Gender == T("\231\148\183") then
        source:takeDamage(damage * 0.3, "AP", "hp", self, 1, 1)
      end
      self.fashionSKillcanCast = false
    end
  end
  return damage, bc
end

function QOPTitan.skill_getLostHPAfterImmunity(basefunc, self, damage, immunity)
  if self.Gender == T("\231\148\183") then
    local reduce = 0.3
    damage = damage * (1 - reduce)
  end
  return basefunc(self, damage, immunity)
end

function QOPTitan.skillult_power(basefunc, self, source, target, damage_type)
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

function QOPTitan.skillult_takeEffectAt(basefunc, self, location, source)
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

function QOPTitan.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local bid = 4620
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
end

function QOPTitan.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4620 then
      tbuff.timer = 0
    end
  end
end

function QOPTitan.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillults = caster.skills.QOPTitan_ults
  skillults:takeEffectAt(caster.position)
end

function QOPTitan.skillults_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function QOPTitan.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  if power and target and target.info.Gender and target.info.Gender == T("\231\148\183") then
    power = power * 1.3
  end
  return power
end

function QOPTitan.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  if power and target and target.info.Gender and target.info.Gender == T("\231\148\183") then
    power = power * 1.3
  end
  return power
end

function QOPTitan.skillatk2_createBuff(basefunc, skill, target)
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

function QOPTitan.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if QOPTitan.QOPTitan_fashionID and QOPTitan.QOPTitan_fashionID == hero.fashion_id then
    if not hero.fashionSKillCD then
      hero.fashionSKillCD = 0
    end
    if not hero.fashionSKillcanCast then
      hero.fashionSKillcanCast = true
    end
    if hero.fashionSKillCD and not hero.fashionSKillcanCast then
      hero.fashionSKillCD = hero.fashionSKillCD + dt
    end
    if hero.fashionSKillCD and hero.fashionSKillCD > 5 then
      hero.fashionSKillcanCast = true
      hero.fashionSKillCD = 0
    end
  end
end

function QOPTitan.init_hero(hero)
  local skillult = hero.skills.QOPTitan_ult
  local skillatk = hero.skills.QOPTitan_atk
  local skillatk2 = hero.skills.QOPTitan_atk2
  local skillatk3 = hero.skills.QOPTitan_atk3
  local skillatk4 = hero.skills.QOPTitan_atk4
  local skillults = hero.skills.QOPTitan_ults
  hero.takeDamage = override(hero.takeDamage, QOPTitan.hero_takeDamage)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, QOPTitan.skill_getLostHPAfterImmunity)
  if QOPTitan.QOPTitan_fashionID and QOPTitan.QOPTitan_fashionID == hero.fashion_id then
    hero.update = override(hero.update, QOPTitan.hero_update)
    if skillatk then
      local originfo = skillatk.info
      skillatk.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_QOPTitan_skin_atk.cha"
      })
    end
    if skillatk2 then
      local originfo = skillatk2.info
      skillatk2.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_QOPTitan_skin_atk2.cha"
      })
    end
  end
  if skillatk2 then
    skillatk2.power = override(skillatk2.power, QOPTitan.skillatk2_power)
    skillatk2.createBuff = override(skillatk2.createBuff, QOPTitan.skillatk2_createBuff)
  end
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, QOPTitan.skillatk3_start)
    skillatk3.power = override(skillatk3.power, QOPTitan.skillatk3_power)
  end
  if skillult then
    skillult.start = override(skillult.start, QOPTitan.skillult_start)
    skillult.finish = override(skillult.finish, QOPTitan.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, QOPTitan.skillult_onAttackFrame)
    skillult.power = override(skillult.power, QOPTitan.skillult_power)
    skillult.takeEffectAt = override(skillult.takeEffectAt, QOPTitan.skillult_takeEffectAt)
  end
  if skillults then
    skillults.createBuff = override(skillults.createBuff, QOPTitan.skillults_createBuff)
  end
  return hero
end

return QOPTitan.init_hero

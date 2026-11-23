module("ed.battlehero", package.seeall)
local ed = ed
ExPhoenix = {}

function ExPhoenix.skillpasv_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  if owner:isAlive() then
    owner:setHP(owner.attribs.HP * (owner.config.hp_mod or 1))
  end
  local owner = buff.owner
  owner.unitonDying = false
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 10006509 then
      local buff = tbuff
      buff.timer = 0
      for n, nbuff in ipairs(owner.buff_list) do
        if nbuff.info.ID == 10006503 then
          nbuff.timer = 0
          for o, obuff in ipairs(buff.owner.buff_list) do
            if obuff.info.ID == 10006508 then
              obuff.timer = 0
              break
            end
          end
          break
        end
      end
      break
    end
  end
  owner.isDandan = false
  return basefunc(buff)
end

function ExPhoenix.skillpasv_buff5OnRemoved(basefunc, buff)
  local owner = buff.owner
  local skillatk3 = owner.skills.ExPhoenix_atk3
  if skillatk3 and not owner.isDandan then
    owner:castSkill(skillatk3, skillatk3.target)
  end
  return basefunc(buff)
end

function ExPhoenix.shieldbuff_onDamaged(basefunc, buff, damage, damage_type)
  local owner = buff.caster
  local shieldbuff
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 158 then
      shieldbuff = tbuff
    end
  end
  if shieldbuff and shieldbuff.shield > 0 then
    shieldbuff.shield = shieldbuff.shield - 1
    if owner.actor then
      local str = "-" .. 1
      local color = "orange"
      ed.PopupCreate(str, color, owner.actor, 1)
    end
    return 0
  else
    local damage = basefunc(buff, damage, damage_type)
    return damage
  end
end

function ExPhoenix.die(basefunc, self, killer)
  local skill = self.skills.ExPhoenix_pasv
  if not self.isDandan then
    self.isDandan = true
    if self.custom_data == nil then
      self.custom_data = 1
    else
      self.custom_data = self.custom_data + 1
    end
    local bidinv = 10005209
    local binfoinv = ed.lookupDataTable("Buff", nil, bidinv)
    local buffinv = self:addBuff(binfoinv, self)
    local list = self.buff_list
    local debuff_list = {}
    for i = 1, #list do
      local buff = list[i]
      if buff and buff.caster ~= self then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      debuff_list[i].timer = -1
    end
    for i, tbuff in ipairs(self.buff_list) do
      if tbuff.info.ID == 128 then
        local buff = tbuff
        buff.timer = -1
      end
    end
    self.unitonDying = true
    local bid = 162
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = self:addBuff(binfo, self)
    self.can_cast_manual = false
    self.walk_v = {0, 0}
    self.hp = 1
    local bid = 158
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, self, self)
    local stype = buff.info["Shield Value"]
    if self.level <= 25 then
      stype = 8
    elseif self.level <= 36 then
      stype = 9
    elseif self.level <= 47 then
      stype = 10
    elseif self.level <= 55 then
      stype = 11
    elseif self.level <= 60 then
      stype = 12
    elseif self.level <= 70 then
      stype = 18
    elseif self.level <= 75 then
      stype = 22
    elseif self.level <= 80 then
      stype = 24
    elseif self.level <= 85 then
      stype = 26
    elseif self.level <= 90 then
      stype = 28
    elseif self.level > 90 then
      stype = 32
    end
    buff.shield = math.floor(stype)
    buff.info["No Pass"] = true
    buff.onDamaged = override(buff.onDamaged, ExPhoenix.shieldbuff_onDamaged)
    self:addBuff(buff, self)
    self.mp = 0
    local bid = 10005206
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = self:addBuff(binfo, self)
    if buff then
      buff.onRemoved = override(buff.onRemoved, ExPhoenix.skillpasv_buffOnRemoved)
    end
    local bid2 = 10005203
    local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
    local buff2 = self:addBuff(binfo2, self)
    local bid3 = 10005207
    local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
    local buff3 = self:addBuff(binfo3, self)
    local bid4 = 10006509
    local binfo4 = ed.lookupDataTable("Buff", nil, bid4)
    local buff4 = self:addBuff(binfo4, self)
    local bid5 = 10005208
    local binfo5 = ed.lookupDataTable("Buff", nil, bid5)
    local buff5 = self:addBuff(binfo5, self)
    if buff5 then
      buff5.onRemoved = override(buff5.onRemoved, ExPhoenix.skillpasv_buff5OnRemoved)
    end
    self.state = ed.emUnitState_Birth
    local skillatk4 = self.skills.ExPhoenix_pasv
    if skillatk4 then
      self:castSkill(skillatk4, skillatk4.target)
    end
  else
    self.custom_data = 0
    basefunc(self, killer)
  end
end

function ExPhoenix.skill_getLostHPAfterImmunity(basefunc, self, damage, immunity)
  for i, tbuff in ipairs(self.buff_list) do
    if tbuff.info.ID == 158 then
      return basefunc(self, damage, immunity)
    end
  end
  for i, tbuff in ipairs(self.buff_list) do
    if tbuff.info.ID == 129 then
      return 1
    end
  end
  return basefunc(self, damage, immunity)
end

function ExPhoenix.skillult_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    coefficient = 0.25,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function ExPhoenix.skill2_buffOnRemoved(basefunc, buff)
  local skill = buff.caster.skills.ExPhoenix_atk
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["Tile Art"] = "eff_tile_Lina_atk.cha",
    ["AOE Origin"] = false,
    ["AOE Shape"] = "circle",
    ["Shape Arg1"] = "0",
    ["Point Effect"] = false,
    ["Damage Type"] = "AD",
    ["Plus Attr"] = "AD",
    ["Plus Ratio"] = "3"
  })
  return basefunc(buff)
end

function ExPhoenix.skill2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onRemoved = override(buff.onRemoved, ExPhoenix.skill2_buffOnRemoved)
  local skill = buff.caster.skills.ExPhoenix_atk
  local originfo = skill.info
  skill.info = ed.wraptable(originfo, {
    ["Tile Art"] = "eff_tile_Phoenix_atk2.cha",
    ["AOE Origin"] = "target",
    ["AOE Shape"] = "circle",
    ["Shape Arg1"] = "100",
    ["Point Effect"] = "eff_point_burst.cha",
    ["Damage Type"] = "AP",
    ["Plus Attr"] = "AP",
    ["Plus Ratio"] = "1.4"
  })
  return buff
end

function ExPhoenix.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local owner = skill.caster
  local attack_counter = skill.attack_counter
  local stype = -owner.attribs.HP * 0.15
  if attack_counter == 1 then
    local bid = 128
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    buff:setAttribute("HPR", stype)
    owner:addBuff(buff, owner)
  end
  if owner.hp == 1 then
    local buff
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == 31 then
        buff = tbuff
      end
    end
    if buff then
      local absorption = stype * 0.8
      if absorption < buff.shield then
        buff.shield = buff.shield - absorption
        return
      else
        absorption = buff.shield
        buff.shield = 0
        buff.owner:removeBuff(buff)
        if not owner.isDandan then
          owner:die()
        end
      end
    end
    if not owner.isDandan then
      owner:die()
    end
  end
end

function ExPhoenix.skillult_finish(basefunc, skill)
  basefunc(skill)
  local owner = skill.caster
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 128 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
    if tbuff.info.ID == 163 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function ExPhoenix.skill3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local owner = skill.caster
  local bid = 125
  local binfo3 = ed.lookupDataTable("Buff", nil, bid)
  local buff3 = owner:addBuff(binfo3, owner)
end

function ExPhoenix.skill3_canCastWithTarget(basefunc, skill, target)
  if not basefunc(skill, target) then
    return false
  end
  local caster = skill.caster
  if caster.atk2Buff then
    return false, "atk2Buff"
  end
  return true
end

function ExPhoenix.reset(basefunc, hero)
  basefunc(hero)
  local bid = 162
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff2 = hero:addBuff(binfo, hero)
end

function ExPhoenix.skillult_start(basefunc, skill, target)
  local owner = skill.caster
  local bid = 163
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff2 = owner:addBuff(binfo, owner)
  basefunc(skill, target)
end

function ExPhoenix.update(basefunc, self, dt)
  for i, tbuff in ipairs(self.buff_list) do
    if tbuff.info.ID == 152 then
      self.uncontroll = true
    else
      self.uncontroll = false
    end
  end
  if self.uncontroll == false then
    local bid = 152
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = self:addBuff(binfo, self)
  end
  basefunc(self, dt)
end

function ExPhoenix.init_hero(hero)
  local stype
  if hero.level <= 25 then
    stype = 8
  elseif hero.level <= 36 then
    stype = 9
  elseif hero.level <= 47 then
    stype = 10
  elseif hero.level <= 55 then
    stype = 11
  elseif hero.level <= 60 then
    stype = 12
  elseif hero.level <= 70 then
    stype = 18
  elseif hero.level <= 75 then
    stype = 22
  elseif hero.level <= 80 then
    stype = 24
  elseif hero.level <= 85 then
    stype = 26
  elseif hero.level <= 90 then
    stype = 28
  elseif hero.level > 90 then
    stype = 32
  end
  hero.maxShield = stype
  hero.update = override(hero.update, ExPhoenix.update)
  local skill2 = hero.skills.ExPhoenix_atk2
  if skill2 then
    hero:preloadEffect("eff_point_burst.cha")
    hero:preloadEffect("eff_tile_Phoenix_atk2.cha")
    skill2.createBuff = override(skill2.createBuff, ExPhoenix.skill2_createBuff)
  end
  local skill = hero.skills.ExPhoenix_pasv
  if skill then
    hero.die = override(hero.die, ExPhoenix.die)
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, ExPhoenix.skill_getLostHPAfterImmunity)
  end
  local skillult = hero.skills.ExPhoenix_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, ExPhoenix.skillult_onAttackFrame)
    skillult.getDamage = override(skillult.getDamage, ExPhoenix.skillult_getDamage)
    skillult.finish = override(skillult.finish, ExPhoenix.skillult_finish)
    skillult.start = override(skillult.start, ExPhoenix.skillult_start)
  end
  local skill3 = hero.skills.ExPhoenix_atk3
  if skill3 then
    skill3.onAttackFrame = override(skill3.onAttackFrame, ExPhoenix.skill3_onAttackFrame)
    skill3.canCastWithTarget = override(skill3.canCastWithTarget, ExPhoenix.skill3_canCastWithTarget)
  end
  hero.reset = override(hero.reset, ExPhoenix.reset)
  return hero
end

return ExPhoenix.init_hero

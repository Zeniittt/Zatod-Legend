module("ed.battlehero", package.seeall)
local ed = ed
ChessPhoenix = {}

function ChessPhoenix.skill_buffOnRemoved(basefunc, buff)
  local owner = buff.owner
  local skill = owner.skills.Phoenix_ultb
  if owner:isAlive() then
    owner:setHP(skill.info["Script Arg2"] * (owner.config.hp_mod or 1))
  end
  local owner = buff.owner
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 203 then
      local buff = tbuff
      buff.timer = 0
      for n, nbuff in ipairs(owner.buff_list) do
        if nbuff.info.ID == 197 then
          nbuff.timer = 0
          for o, obuff in ipairs(buff.owner.buff_list) do
            if obuff.info.ID == 202 then
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
  owner.isDandan_Phoenix = false
  return basefunc(buff)
end

function ChessPhoenix.skill_buff2OnRemoved(basefunc, buff)
  local owner = buff.owner
  local skillatk3
  if skillatk3 then
    owner:castSkill(skillatk3, skillatk3.target)
  end
  return basefunc(buff)
end

function ChessPhoenix.onDying(basefunc, self, killer)
  if not self:isAlive() then
    return
  end
  local skill = self.skills.Phoenix_ultb
  if not self.isDandan_Phoenix and self.custom_data ~= 1 then
    self.isDandan_Phoenix = true
    if self.custom_data == nil then
      self.custom_data = 1
    else
      self.custom_data = self.custom_data + 1
    end
    self:removeAllBuffs()
    self.can_cast_manual = false
    self.walk_v = {0, 0}
    if self.custom_data == 1 then
      self.hp = 4
    elseif self.custom_data == 2 then
      self.hp = 3
    elseif self.custom_data == 3 then
      self.hp = 2
    end
    self.mp = 0
    local bid = 129
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = self:addBuff(binfo, self)
    if buff then
      buff.onRemoved = override(buff.onRemoved, ChessPhoenix.skill_buffOnRemoved)
    end
    local bid = 126
    local binfo2 = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = self:addBuff(binfo2, self)
    if buff2 then
      buff2.onRemoved = override(buff2.onRemoved, ChessPhoenix.skill_buff2OnRemoved)
    end
    local bid = 135
    local binfo2 = ed.lookupDataTable("Buff", nil, bid)
    local buff2 = self:addBuff(binfo2, self)
    local bid4 = 203
    local binfo4 = ed.lookupDataTable("Buff", nil, bid4)
    local buff4 = self:addBuff(binfo4, self)
    self.state = ed.emUnitState_Birth
    local skillatk4 = self.skills.Phoenix_ultb
    if skillatk4 then
      self:castSkill(skillatk4, skillatk4.target)
    end
  else
    self.custom_data = 0
    basefunc(self, killer)
  end
end

function ChessPhoenix.skill_getLostHPAfterImmunity(basefunc, self, damage, immunity)
  for i, tbuff in ipairs(self.buff_list) do
    if tbuff.info.ID == 129 then
      return 1
    end
  end
  return basefunc(self, damage, immunity)
end

function ChessPhoenix.skillult_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
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

function ChessPhoenix.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local owner = skill.caster
  local attack_counter = skill.attack_counter
  if attack_counter == 1 then
    local bid = 128
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, owner)
    local stype = buff.info.HPR
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
      local stype = buff.info.HPR
      local absorption = stype * 0.8
      if absorption < buff.shield then
        buff.shield = buff.shield - absorption
        return
      else
        absorption = buff.shield
        buff.shield = 0
        buff.owner:removeBuff(buff)
        if not owner.isDandan then
          owner:onDying()
        end
      end
    end
    if not owner.isDandan then
      owner:onDying()
    end
  end
end

function ChessPhoenix.skillult_finish(basefunc, skill)
  basefunc(skill)
  local owner = skill.caster
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 128 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
end

function ChessPhoenix.init_hero(hero)
  local skill = hero.skills.Phoenix_ultb
  if skill then
    hero.onDying = override(hero.onDying, ChessPhoenix.onDying)
    hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, ChessPhoenix.skill_getLostHPAfterImmunity)
  end
  local skillult = hero.skills.Phoenix_ultb
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, ChessPhoenix.skillult_onAttackFrame)
    skillult.getDamage = override(skillult.getDamage, ChessPhoenix.skillult_getDamage)
    skillult.finish = override(skillult.finish, ChessPhoenix.skillult_finish)
  end
  return hero
end

return ChessPhoenix.init_hero

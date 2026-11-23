module("ed.battlehero", package.seeall)
local ed = ed
Lantern = {}

function Lantern.atk2buff_onDamaged(basefunc, buff, damage, damage_type, source, skill)
  local owner = buff.owner
  local defence, dd, dc, immunity, crit
  local level = owner.level
  if damage_type == "AD" then
    defence = math.max(0, owner.attribs.ARM - source.attribs.ARMP)
    crit = source.attribs.CRIT
    immunity = owner.attribs.PIMU or 0
    dd = defence * 8
    dc = defence * 8
  elseif damage_type == "AP" then
    defence = math.max(0, owner.attribs.MR - source.attribs.MRI)
    crit = source.attribs.MCRIT
    immunity = owner.attribs.MIMU or 0
    dd = defence * 12
    dc = defence * 2.5
  elseif damage_type == "Holy" then
    defence = 0
    crit = 0
    immunity = 0
    dd = 0
    dc = 0
  else
    EDDebug("Unknown Damage Type '" .. damage_type .. "'")
  end
  immunity = immunity + owner.attribs.ALLIMU
  local lastdamage = owner:getLostHPAfterImmunity(damage, immunity, damage_type)
  local oridmg = basefunc(buff, damage, damage_type, source, skill)
  local hasMagicianBuff = false
  if source.info.Name == "Magician" then
    local Magician_ult_caster = source
    for _, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.ID == Magician.ultTargetInviBuff and tbuff.caster == Magician_ult_caster then
        hasMagicianBuff = true
      end
    end
  end
  if lastdamage >= owner.attribs.HP * 0.2 and not hasMagicianBuff then
    oridmg = 0
    buff.timer = 0
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_buff_Lantern_atk2_destroy.cha", {
        owner.position[1],
        owner.position[2] - 2
      }, {
        owner.direction,
        1
      }, nil, 0)
    end
  end
  return oridmg
end

function Lantern.atk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, Lantern.atk2buff_onDamaged)
  return buff
end

function Lantern.new_caterSkill(basefunc, self, skill, target)
  local newskill = skill
  local newtarget = target
  if skill == self.skills.Lantern_atk4 then
    if self.hp >= 0.8 * self.attribs.HP then
      newskill = skill
      newtarget = target
    elseif self.hp >= 0.6 * self.attribs.HP then
      newskill = self.skills.Lantern_atk4a
      newtarget = newskill:selectTarget(nil)
      skill.cd_remaining = skill.info.CD
    else
      newskill = self.skills.Lantern_atk4b
      newtarget = newskill:selectTarget(nil)
      skill.cd_remaining = skill.info.CD
    end
  end
  basefunc(self, newskill, newtarget)
end

function Lantern.skillawake_willCast(basefunc, skill)
  local caster = skill.caster
  if caster.hp >= 0.4 * caster.attribs.HP then
    return false
  end
end

function Lantern.hero_update(basefunc, self, dt)
  basefunc(self, dt)
  local skillawake = self.skills.Lantern_awake
  local skillult = self.skills.Lantern_ult
  if skillawake and skillawake.cd_remaining <= 0 and self.hp < 0.4 * self.attribs.HP then
    if not self.current_skill then
      self:castSkill(skillawake, self)
    elseif self.current_skill and self.current_skill ~= skillult then
      self.current_skill:interrupt()
      self:castSkill(skillawake, self)
    end
  end
end

function Lantern.init_hero(hero)
  hero.update = override(hero.update, Lantern.hero_update)
  hero.castSkill = override(hero.castSkill, Lantern.new_caterSkill)
  local skillatk2 = hero.skills.Lantern_atk2
  local skillawake = hero.skills.Lantern_awake
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, Lantern.atk2_createBuff)
  end
  if skillawake then
    skillawake.willCast = override(skillawake.willCast, Lantern.skillawake_willCast)
  end
  return hero
end

return Lantern.init_hero

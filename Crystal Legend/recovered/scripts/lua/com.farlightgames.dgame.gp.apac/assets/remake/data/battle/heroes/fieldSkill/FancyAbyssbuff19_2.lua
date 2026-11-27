module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff19_2 = {}

function FancyAbyssbuff19_2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff19_2.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff19_2.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  local sourceap
  if source and source.fancy19count and damage_type == "Holy" and field == "hp" then
    dmg = dmg * 1.5
    source.fancy19count = source.fancy19count + 1
    if source.f19enhance then
      dmg = dmg * source.f19enhance
    end
  end
  return dmg
end

function FancyAbyssbuff19_2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff19_2.createBuff)
  return skill
end

return FancyAbyssbuff19_2.init_fieldSkill

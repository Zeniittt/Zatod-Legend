module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff13 = {}

function FancyAbyssbuff13.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff13.Buff_onDamaged)
  buff.update = override(buff.update, FancyAbyssbuff13.Buff_update)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff13.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if source and damage_type == "AD" then
    dmg = dmg * (1 + source.attribs.HIT / 100)
  end
  if source.needfancy13buff1 == false and damage_type == "AD" then
    dmg = dmg * 1.25
  end
  if source.needfancy13buff2 == false and damage_type == "AD" then
    dmg = dmg * 1.5
  end
  return dmg
end

function FancyAbyssbuff13.Buff_update(basefunc, buff, dt)
end

function FancyAbyssbuff13.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff13.createBuff)
  return skill
end

return FancyAbyssbuff13.init_fieldSkill

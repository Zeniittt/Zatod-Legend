module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff12 = {}

function FancyAbyssbuff12.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff12.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff12.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if source and damage_type == "AD" and source.needfancy12eff == false then
    dmg = dmg * ((source.hpenhanceratio - 1) / 2 + 1)
  end
  if source and source.info["Main Attrib"] == "STR" then
    dmg = dmg * 1.4
  end
  if source and source.fancy12count and skill then
    if skill.info["Knock Back"] > 0 then
      dmg = dmg * source.hpenhanceratio
    end
    if skill.info["Knock Back"] > 0 and source.fancy12count < 15 then
      source.fancy12count = source.fancy12count + 1
    end
  end
  return dmg
end

function FancyAbyssbuff12.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff12.createBuff)
  return skill
end

return FancyAbyssbuff12.init_fieldSkill

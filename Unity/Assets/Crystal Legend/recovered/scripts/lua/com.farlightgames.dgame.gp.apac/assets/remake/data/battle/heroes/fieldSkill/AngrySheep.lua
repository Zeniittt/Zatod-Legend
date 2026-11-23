module("ed.battlehero", package.seeall)
local ed = ed
AngrySheep = {}

function AngrySheep.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, AngrySheep.Monster_dmgBuff_onDamaged)
  return buff
end

function AngrySheep.Monster_dmgBuff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred)
  local owner = buff.owner
  if dmg and owner and damage_type ~= "Holy" then
    dmg = dmg / 2
  end
  return dmg
end

function AngrySheep.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, AngrySheep.createBuff)
  return skill
end

return AngrySheep.init_fieldSkill

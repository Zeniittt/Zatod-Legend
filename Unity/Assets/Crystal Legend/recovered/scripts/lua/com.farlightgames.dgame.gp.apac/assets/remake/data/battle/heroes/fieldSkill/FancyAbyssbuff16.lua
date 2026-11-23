module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff16 = {}

function FancyAbyssbuff16.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff16.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff16.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if source and source.fancy16count and damage_type == "AP" then
    if source.fancy16count < 75 then
      source.fancy16count = source.fancy16count + 1
    end
    dmg = dmg + 0.02 * source.fancy16count * source.attribs.AP
  end
  return dmg
end

function FancyAbyssbuff16.Buff_update(basefunc, buff, dt)
end

function FancyAbyssbuff16.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff16.createBuff)
  return skill
end

return FancyAbyssbuff16.init_fieldSkill

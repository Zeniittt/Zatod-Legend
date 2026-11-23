module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff33 = {}

function FancyAbyssbuff33.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff33.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff33.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if source and source.config.is_summoned and source.config.summoner and source.config.summoner.info["Main Attrib"] == "INT" and source.info.ID ~= 224 and source.info.ID ~= 210 and field == "hp" then
    dmg = dmg * 3
  end
  return dmg
end

function FancyAbyssbuff33.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff33.createBuff)
  return skill
end

return FancyAbyssbuff33.init_fieldSkill

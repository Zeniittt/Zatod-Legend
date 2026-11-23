module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff23 = {}

function FancyAbyssbuff23.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff23.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff23.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if source and source.info["Main Attrib"] == "INT" and skill and field == "hp" then
    dmg = dmg * 1.25
    for unit in ed.engine:foreachAliveUnit(source.camp) do
      if unit.info.ID == 53 then
        dmg = dmg * 1.6
      end
    end
  end
  return dmg
end

function FancyAbyssbuff23.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff23.createBuff)
  return skill
end

return FancyAbyssbuff23.init_fieldSkill

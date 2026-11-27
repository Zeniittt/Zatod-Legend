module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff7 = {}

function FancyAbyssbuff7.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff7.Buff_onDamaged)
  return buff
end

function FancyAbyssbuff7.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  if skill then
    if damage_type == "AP" then
      local caster = skill.caster
      if caster and not caster.config.is_summoned then
        if caster.attribs.INT < 1700 then
          damage = damage * (1 + caster.attribs.INT / 5000)
        else
          damage = damage * (1 + caster.attribs.INT / 3500)
        end
      end
      return basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
    else
      return basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
    end
  else
    return basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  end
end

function FancyAbyssbuff7.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff7.createBuff)
  return skill
end

return FancyAbyssbuff7.init_fieldSkill

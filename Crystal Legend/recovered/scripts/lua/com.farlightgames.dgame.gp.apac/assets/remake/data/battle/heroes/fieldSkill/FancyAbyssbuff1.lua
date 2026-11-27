module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff1 = {}

function FancyAbyssbuff1.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff1.Buff_onDamaged)
  return buff
end

function FancyAbyssbuff1.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local skilldpult = source.skills.DP_ult
  if skill and skill.current_phase and skill.current_phase.event_list then
    local counter = #skill.current_phase.event_list
    if source then
      local main = source.info["Main Attrib"]
      if main == "INT" and (counter and 1 < counter or skilldpult and skill == skilldpult) then
        dmg = dmg * 1.8
      else
      end
    end
  end
  return dmg
end

function FancyAbyssbuff1.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff1.createBuff)
  return skill
end

return FancyAbyssbuff1.init_fieldSkill

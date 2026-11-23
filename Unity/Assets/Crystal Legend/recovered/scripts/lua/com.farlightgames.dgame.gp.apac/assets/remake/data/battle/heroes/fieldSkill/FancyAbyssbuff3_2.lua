module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff3_2 = {}

function FancyAbyssbuff3_2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  if owner.config.is_boss then
    buff:setAttribute("Control Effects", {
      "uncontrollable"
    })
    if owner.level > 80 then
      buff:setAttribute("DODG", 70)
    end
  end
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff3_2.Buff_onDamaged)
  return buff
end

function FancyAbyssbuff3_2.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local skillHuskar = source.skills.Huskar_atk2
  local skillMed = source.skills.Med_atk2
  local skillTroll = source.skills.Troll_atk3
  local skillLYC = source.skills.LYC_atk2b
  local skillPA = source.skills.PA_atk
  local caster = buff.caster
  local owner = buff.owner
  if source and source.buff_list then
    for i, tbuff in ipairs(source.buff_list) do
      if tbuff.info.ID == 6160 and tbuff.shield and tbuff.shield > source.attribs.HP * 0.5 and skill and (skill.info.Slot == 5 or skill == skillHuskar or skill == skillMed or skill == skillTroll or skill == skillLYC or skill == skillPA) then
        owner:takeDamage(owner.attribs.HP * 0.015, "Holy", "hp", source)
      end
    end
  end
  return dmg
end

function FancyAbyssbuff3_2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff3_2.createBuff)
  return skill
end

return FancyAbyssbuff3_2.init_fieldSkill

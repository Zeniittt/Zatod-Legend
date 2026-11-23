module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff28 = {}

function FancyAbyssbuff28.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff28.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff28.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if source and source.camp == owner.foecamp and damage_type == "Holy" and 0 < dmg and field == "hp" then
    dmg = dmg + source.attribs.AGI * 10
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanLoong_atk2.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, owner.position, nil, nil, 1)
      end
    end
  end
  if source and source.camp == owner.foecamp and source.info["Main Attrib"] == "AGI" then
    dmg = dmg * 1.3
  end
  return dmg
end

function FancyAbyssbuff28.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff28.createBuff)
  return skill
end

return FancyAbyssbuff28.init_fieldSkill

module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff10 = {}

function FancyAbyssbuff10.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff10.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff10.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  local caster = buff.caster
  if source and damage_type == "AD" and source.fancy10atkcount then
    source.fancy10atkcount = source.fancy10atkcount + 1
  end
  if source and source.fancy10atkcount and source.fancy10atkcount == 5 then
    dmg = dmg + owner.attribs.HP * 0.1
    if ed.run_with_scene then
      local effect_name = "eff_point_TitanLoong_atk2.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, owner.position, nil, nil, 1)
      end
    end
    source.fancy10atkcount = 0
  end
  return dmg
end

function FancyAbyssbuff10.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff10.createBuff)
  return skill
end

return FancyAbyssbuff10.init_fieldSkill

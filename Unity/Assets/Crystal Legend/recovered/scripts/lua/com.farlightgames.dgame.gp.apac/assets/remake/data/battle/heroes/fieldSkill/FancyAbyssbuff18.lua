module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff18 = {}

function FancyAbyssbuff18.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff18.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff18.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local skillsbatk2 = source.skills.SB_atk2
  local skillsbatk3 = source.skills.SB_atk3
  local owner = buff.owner
  local sourceap
  if source then
    if source.summoner then
      sourceap = source.summoner.attribs.AP
    else
      sourceap = source.attribs.AP
    end
    if skill and (skill.info["Knock Up"] > 0 or skillsbatk2 and skill == skillsbatk2 or skillsbatk3 and skill == skillsbatk3) then
      dmg = dmg + sourceap * 1
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanLoong_atk2.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, owner.position, nil, nil, 1)
        end
      end
    end
  end
  return dmg
end

function FancyAbyssbuff18.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff18.createBuff)
  return skill
end

return FancyAbyssbuff18.init_fieldSkill

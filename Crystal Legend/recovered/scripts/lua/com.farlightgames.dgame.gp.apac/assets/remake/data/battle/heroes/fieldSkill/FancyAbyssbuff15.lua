module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff15 = {}

function FancyAbyssbuff15.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.update = override(buff.update, FancyAbyssbuff15.Buff_update)
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff15.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff15.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if source and source.info["Main Attrib"] == "AGI" and field == "hp" then
    dmg = dmg * 1.6
    if owner.direction == 1 and source.direction == 1 and owner.position[1] > source.position[1] or owner.direction == -1 and source.direction == -1 and owner.position[1] < source.position[1] then
      if owner.name == "BB" then
        if owner.ultBuff_BB then
        else
          dmg = dmg * 2
          if ed.run_with_scene then
            local effect_name = "eff_point_TitanLoong_atk2.cha"
            if effect_name then
              ed.scene:playEffectOnScene(effect_name, owner.position, nil, nil, 1)
            end
          end
        end
      else
        dmg = dmg * 2
        if ed.run_with_scene then
          local effect_name = "eff_point_TitanLoong_atk2.cha"
          if effect_name then
            ed.scene:playEffectOnScene(effect_name, owner.position, nil, nil, 1)
          end
        end
      end
    elseif owner.name == "BB" and owner.ultBuff_BB then
      dmg = dmg * 2
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

function FancyAbyssbuff15.Buff_update(basefunc, buff, dt)
end

function FancyAbyssbuff15.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff15.createBuff)
  return skill
end

return FancyAbyssbuff15.init_fieldSkill

module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff9 = {}

function FancyAbyssbuff9.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff9.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff9.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if source and damage_type == "AD" then
    local initpuppet = source.info.Puppet
    initpuppet = source.fashion_id and ed.lookupDataTable("Fashion", "Puppet", source.fashion_id) or initpuppet
    if source.puppet_stack[1] ~= initpuppet or source.ultBuff_TB == 1 then
      dmg = dmg + owner.attribs.HP * math.min(source.attribs.ARM / 20000, 0.1)
      if ed.run_with_scene then
        local effect_name = "eff_impact_burst.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, owner.position, nil, nil, 1)
        end
      end
    end
  end
  return dmg
end

function FancyAbyssbuff9.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff9.createBuff)
  return skill
end

return FancyAbyssbuff9.init_fieldSkill

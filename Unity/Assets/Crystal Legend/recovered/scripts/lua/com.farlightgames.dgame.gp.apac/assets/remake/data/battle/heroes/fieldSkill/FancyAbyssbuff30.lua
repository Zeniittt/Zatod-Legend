module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff30 = {}

function FancyAbyssbuff30.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.fancy30EffectList = {
    "eff_buff_rogue1201_1.cha",
    "eff_buff_rogue1201_2.cha",
    "eff_buff_rogue1201_3.cha",
    "eff_buff_rogue1201_4.cha",
    "eff_buff_rogue1201_5.cha",
    "eff_buff_rogue1201_6.cha",
    "eff_buff_rogue1201_7.cha",
    "eff_buff_rogue1201_8.cha",
    "eff_buff_rogue1201_9.cha",
    "eff_buff_rogue1201_10.cha",
    "eff_tile_TS_atk2.cha"
  }
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff30.Buff_onDamaged)
  buff.update = override(buff.update, FancyAbyssbuff30.Buff_update)
  buff.unremoveable = true
  owner.fancy30Count = 0
  return buff
end

function FancyAbyssbuff30.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if source and source.camp == owner.foecamp and damage_type == "AD" and 0 < dmg and field == "hp" then
    owner.fancy30Count = owner.fancy30Count + 1
    if ed.run_with_scene and owner and owner.actor then
      if not owner.fancy30effect then
        owner.fancy30effectlast = 1
        owner.fancy30effectFirstTime = true
      end
      owner.fancy30effect = owner.fancy30Count
      if owner.fancy30effect >= 10 then
        owner.fancy30effect = 11
      end
      if owner.fancy30effectFirstTime or owner.fancy30effect ~= owner.fancy30effectlast then
        local effect_name = buff.fancy30EffectList[owner.fancy30effect]
        local effect_id = owner.actor:addEffect(effect_name, 1)
        local actor = owner.actor
        local direction = owner.direction
        local effect = actor:getEffectById(effect_id)
        if effect then
          local scaleX = effect:getScaleX()
          effect:setScaleX(direction)
        end
        if owner.fancy30preEffectID then
          owner.actor.puppet:removeEffectWithID(owner.fancy30preEffectID)
        end
        owner.fancy30preEffectID = effect_id
        owner.fancy30effectFirstTime = false
        owner.fancy30effectlast = owner.fancy30effect
      end
    end
    if owner.fancy30Count >= 10 then
      owner.fancy30Count = 0
      owner.fancy30effect = nil
      owner:takeDamage(owner.attribs.HP * 0.15, "Holy", "hp", source)
      if ed.run_with_scene then
        local effect_name = "eff_impact_LYC_atk.cha"
        ed.scene:playEffectOnScene(effect_name, owner.position, {
          owner.direction,
          1
        }, nil, 1)
      end
    end
    if source and source.info["Main Attrib"] == "STR" then
      dmg = dmg * 1.3
    end
  end
  return dmg
end

function FancyAbyssbuff30.Buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local actor = owner.actor
  if actor and owner.fancy30preEffectID then
    local direction = owner.direction
    local effect = actor:getEffectById(owner.fancy30preEffectID)
    if effect then
      local scaleX = effect:getScaleX()
      effect:setScaleX(direction)
    end
  end
end

function FancyAbyssbuff30.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff30.createBuff)
  return skill
end

return FancyAbyssbuff30.init_fieldSkill

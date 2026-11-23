local function HealBuff1_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.HealBuff1 and owner.hp <= owner.attribs.HP * 0.3 then
    local param = ed.getDataTable("SoloCardSkill")[33]["Level Arg 1"][1]
    owner.HealBuff1 = true
    owner:takeHeal(param, "hp", owner, nil, {type = 1, id = 33})
    buff.HealBuff1_CD = 0
    buff.timer = 6
    if ed.run_with_scene then
      local effect_name = "eff_point_solo_card33_2.cha"
      local effect_z = -1
      buff.effectNode = ed.scene:playEffectOnScene(effect_name, owner.position, {
        owner.direction,
        1
      }, nil, effect_z)
    end
  end
  if owner.HealBuff1 then
    local param = ed.getDataTable("SoloCardSkill")[33]["Level Arg 1"][1]
    local hasteSpeedUp = owner:getHasteSpeed()
    local adjustedDt = dt * hasteSpeedUp
    if buff.HealBuff1_CD then
      buff.HealBuff1_CD = buff.HealBuff1_CD + adjustedDt
    end
    if 1 <= buff.HealBuff1_CD then
      owner:takeHeal(param, "hp", owner, nil, {type = 1, id = 33})
      owner.periodicSkillCount = owner.periodicSkillCount + 1
      buff.HealBuff1_CD = 0
    end
  end
end

local function onBuffRemove(baseFunc, buff)
  baseFunc(buff)
  if ed.run_with_scene and buff.effectNode then
    ed.scene:removeEffect(buff.effectNode, 1)
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.HealBuff1 = false
  end
  buff.HealBuff1_CD = 0
  buff.onRemoved = override(buff.onRemoved, onBuffRemove)
  buff.update = override(buff.update, HealBuff1_update)
  return buff
end

return initBuff

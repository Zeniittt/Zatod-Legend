local function trigger(buff, hp)
  local owner = buff.owner
  
  if owner.ShieldBuff1_triggered then
    return hp
  end
  owner.ShieldBuff1_triggered = true
  owner.ShieldBuff1_active = true
  owner:addShield(1000, {
    type = 1,
    id = buff.cardId
  })
  buff.ShieldBuff1_CD = 0
  buff.timer = 5
  local absHp = math.abs(hp)
  local shieldDef = math.min(owner.shieldValue, absHp + 1)
  local finalHp = hp + shieldDef
  owner:subShield(shieldDef)
  if ed.run_with_scene then
    local effect_name = "eff_point_solo_card77_1.cha"
    ed.scene:playEffectOnScene(effect_name, owner.position, {
      owner.direction,
      1
    }, nil, 1)
    local effect_name2 = "eff_point_solo_card77_2.cha"
    ed.scene:playEffectOnScene(effect_name2, owner.position, {
      owner.direction,
      1
    }, nil, -1)
  end
  return finalHp
end

local function ShieldBuff1_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.ShieldBuff1_active then
    local shieldAmount = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
    local hasteSpeedUp = owner:getHasteSpeed()
    local adjustedDt = dt * hasteSpeedUp
    if buff.ShieldBuff1_CD then
      buff.ShieldBuff1_CD = buff.ShieldBuff1_CD + adjustedDt
    end
    if buff.ShieldBuff1_CD >= 0.5 then
      owner:addShield(shieldAmount, {
        type = 1,
        id = buff.cardId
      })
      owner.periodicSkillCount = owner.periodicSkillCount + 1
      buff.ShieldBuff1_CD = 0
    end
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.ShieldBuff1_triggered = false
    owner.ShieldBuff1_active = false
  end
  buff.ShieldBuff1_CD = 0
  buff.cardId = 77
  
  function buff.onWillDie(hp)
    return trigger(buff, hp)
  end
  
  buff.update = override(buff.update, ShieldBuff1_update)
  return buff
end

return initBuff

local function onHitMiss(buff, caster)
  local rand = ed.rand()
  
  if rand <= 0.6 then
    local DodgeBuff4_values = ed.getDataTable("SoloCardSkill")[12]["Level Arg 1"]
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_impact_FV_fashion_1_atkb.cha", buff.owner.position, {
        buff.owner.direction,
        1
      }, nil, 1)
    end
    caster:takeDamage({
      amount = DodgeBuff4_values[buff.rank],
      damage_type = "AD",
      field = "hp",
      source = buff.owner,
      coefficient = 1,
      crit_mod = 1,
      transferred = true,
      soloParams = {type = 1, id = 12}
    })
  end
end

local function initBuff(buff)
  function buff.onHitMiss(skill, caster, power)
    onHitMiss(buff, caster)
  end
  
  return buff
end

return initBuff

local function onHitMiss(buff, caster, power)
  if ed.rand() <= ed.getDataTable("SoloCardSkill")[9]["Level Arg 1"][1] / 100 then
    local owner = buff.owner
    
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_solo_card9.cha", owner.position, {
        owner.direction * 1.5,
        1.5
      }, nil, 1)
    end
    caster:takeDamage({
      amount = power,
      damage_type = "AP",
      field = "hp",
      source = owner,
      soloParams = {type = 1, id = 9}
    })
  end
end

local function initBuff(buff)
  function buff.onHitMiss(skill, caster, power)
    onHitMiss(buff, caster, power)
  end
  
  return buff
end

return initBuff

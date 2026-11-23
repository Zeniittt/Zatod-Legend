local function onStart(buff)
  local owner = buff.owner
  
  if not owner.UltBuff1 then
    owner.UltBuff1 = true
    owner.mp = 1000
    if ed.run_with_scene then
      ed.scene:playEffectOnScene("eff_point_solo_card43.cha", owner.position, {
        owner.direction,
        1
      }, nil, -1)
    end
  end
end

local function initBuff(buff)
  function buff.onStart(buff)
    onStart(buff)
  end
  
  return buff
end

return initBuff

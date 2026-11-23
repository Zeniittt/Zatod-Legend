local function onHitMiss(buff)
  local owner = buff.owner
  
  local UltBuff8_values = ed.getDataTable("SoloCardSkill")[50]["Level Arg 1"]
  local UltBuff8_mp = UltBuff8_values[buff.rank]
  local rand = ed.rand()
  if rand <= 0.6 then
    owner:setMP(owner.mp + UltBuff8_mp)
  end
end

local function initBuff(buff)
  function buff.onHitMiss()
    onHitMiss(buff)
  end
  
  return buff
end

return initBuff

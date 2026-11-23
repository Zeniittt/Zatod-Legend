local function onHitCrit(buff)
  local owner = buff.owner
  
  local UltBuff7_values = ed.getDataTable("SoloCardSkill")[49]["Level Arg 1"]
  local UltBuff7_mp = UltBuff7_values[buff.rank]
  local rand = ed.rand()
  if rand <= 0.6 then
    owner:setMP(owner.mp + UltBuff7_mp)
  end
end

local function initBuff(buff)
  function buff.onHitCrit()
    onHitCrit(buff)
  end
  
  return buff
end

return initBuff

local function onHitMiss(buff)
  local owner = buff.owner
  
  local value = ed.getDataTable("SoloCardSkill")[85]["Level Arg 1"][buff.rank]
  owner:addShield(value)
end

local function initBuff(buff)
  function buff.onHitMiss()
    onHitMiss(buff)
  end
  
  return buff
end

return initBuff

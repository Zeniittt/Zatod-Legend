local function trigger(buff, value, soloParams)
  local owner = buff.owner
  
  local probability = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
  if ed.rand() < probability / 100 then
    owner:addHaste(20, {
      type = 1,
      id = buff.cardId
    }, owner)
  end
end

local function initBuff(buff)
  buff.cardId = 120
  
  function buff.onAddShield(value, soloParams)
    return trigger(buff, value, soloParams)
  end
  
  return buff
end

return initBuff

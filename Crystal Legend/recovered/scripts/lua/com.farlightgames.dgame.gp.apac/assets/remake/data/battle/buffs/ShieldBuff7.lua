local function onHitCrit(buff)
  local owner = buff.owner
  
  local shieldAmount = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
  owner:addShield(shieldAmount, {
    type = 1,
    id = buff.cardId
  })
end

local function initBuff(buff)
  buff.cardId = 83
  
  function buff.onHitCrit()
    onHitCrit(buff)
  end
  
  return buff
end

return initBuff

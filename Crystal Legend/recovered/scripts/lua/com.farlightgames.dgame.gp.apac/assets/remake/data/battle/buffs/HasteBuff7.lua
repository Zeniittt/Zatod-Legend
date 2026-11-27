local function onHitCrit(buff)
  local owner = buff.owner
  
  local hasteAmount = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
  owner:addHaste(hasteAmount, {
    type = 1,
    id = buff.cardId
  }, owner)
end

local function initBuff(buff)
  buff.cardId = 112
  
  function buff.onHitCrit()
    onHitCrit(buff)
  end
  
  return buff
end

return initBuff

local function onAttackSlot1(buff)
  local owner = buff.owner
  
  local hasteAmount = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
  owner:addHaste(hasteAmount, {
    type = 1,
    id = buff.cardId
  }, owner)
end

local function initBuff(buff)
  buff.cardId = 116
  
  function buff.onAttackSlot1()
    onAttackSlot1(buff)
  end
  
  return buff
end

return initBuff

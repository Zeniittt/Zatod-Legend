local function onAttackSlot5(buff, skill)
  local owner = buff.owner
  
  if ed.rand() < 0.3 then
    local hasteAmount = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
    owner:addHaste(hasteAmount, {
      type = 1,
      id = buff.cardId
    }, owner)
  end
end

local function initBuff(buff)
  buff.cardId = 113
  
  function buff.onAttackSlot5(skill)
    onAttackSlot5(buff, skill)
  end
  
  return buff
end

return initBuff

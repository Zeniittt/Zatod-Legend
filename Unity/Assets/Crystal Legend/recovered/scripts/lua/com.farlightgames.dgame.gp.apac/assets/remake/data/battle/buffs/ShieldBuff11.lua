local function onAttackSlot1(buff)
  local owner = buff.owner
  
  local value = ed.getDataTable("SoloCardSkill")[87]["Level Arg 1"][buff.rank] or 0
  owner:addShield(value, {type = 1, id = 87}, owner)
end

local function initBuff(buff)
  local owner = buff.owner
  
  function buff.onAttackSlot1(skill)
    onAttackSlot1(buff, skill)
  end
  
  return buff
end

return initBuff

local function trigger(buff, value, soloParams)
  local owner = buff.owner
  
  local probability = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
  if ed.rand() < probability / 100 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      target:addDrug(20, {
        type = 1,
        id = buff.cardId
      }, owner)
    end
  end
end

local function initBuff(buff)
  buff.cardId = 96
  
  function buff.onAddWeak(value, soloParams)
    return trigger(buff, value, soloParams)
  end
  
  return buff
end

return initBuff

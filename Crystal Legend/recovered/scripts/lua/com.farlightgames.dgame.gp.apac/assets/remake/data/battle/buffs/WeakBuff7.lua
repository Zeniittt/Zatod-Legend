local function onHitCrit(buff)
  local owner = buff.owner
  
  local weakAmount = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target then
    target:addWeak(weakAmount, {
      type = 1,
      id = buff.cardId
    }, owner)
  end
end

local function initBuff(buff)
  buff.cardId = 97
  
  function buff.onHitCrit()
    onHitCrit(buff)
  end
  
  return buff
end

return initBuff

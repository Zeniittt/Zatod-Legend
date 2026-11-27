local function onHitCrit(buff)
  local owner = buff.owner
  
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target then
    local drug = ed.getDataTable("SoloCardSkill")[59]["Level Arg 1"][buff.rank]
    target:addDrug(drug, {type = 1, id = 59}, owner)
  end
end

local function initBuff(buff)
  function buff.onHitCrit()
    onHitCrit(buff)
  end
  
  return buff
end

return initBuff

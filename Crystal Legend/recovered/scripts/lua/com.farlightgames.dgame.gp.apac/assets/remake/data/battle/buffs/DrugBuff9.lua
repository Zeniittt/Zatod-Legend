local function onHitMiss(buff)
  local owner = buff.owner
  
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target then
    local drug = ed.getDataTable("SoloCardSkill")[60]["Level Arg 1"][buff.rank]
    target:addDrug(drug, {type = 1, id = 60}, owner)
  end
end

local function initBuff(buff)
  function buff.onHitMiss()
    onHitMiss(buff)
  end
  
  return buff
end

return initBuff

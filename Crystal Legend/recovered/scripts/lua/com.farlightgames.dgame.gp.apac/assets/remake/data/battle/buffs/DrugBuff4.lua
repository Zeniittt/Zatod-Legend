local function trigger(buff)
  local owner = buff.owner
  
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target and ed.rand() < 0.3 then
    local drug = ed.getDataTable("SoloCardSkill")[55]["Level Arg 1"][buff.rank]
    target:addDrug(drug, {type = 1, id = 55}, owner)
  end
end

local function initBuff(buff)
  local owner = buff.owner
  
  function buff.trigger()
    trigger(buff)
  end
  
  return buff
end

return initBuff

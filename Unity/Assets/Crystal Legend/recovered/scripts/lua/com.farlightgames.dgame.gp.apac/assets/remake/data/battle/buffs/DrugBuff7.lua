local function trigger(buff)
  local owner = buff.owner
  
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target and ed.rand() < 0.3 then
    local drug = ed.getDataTable("SoloCardSkill")[58]["Level Arg 1"][buff.rank]
    target:addDrug(drug, {type = 1, id = 58}, owner)
  end
end

local function initBuff(buff)
  function buff.onHeal()
    trigger(buff)
  end
  
  return buff
end

return initBuff

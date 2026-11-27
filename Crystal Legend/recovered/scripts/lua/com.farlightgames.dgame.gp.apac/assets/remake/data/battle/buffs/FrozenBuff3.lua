local function trigger(buff)
  local owner = buff.owner
  
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target and ed.rand() < 0.35 then
    local value = ed.getDataTable("SoloCardSkill")[66]["Level Arg 1"][buff.rank]
    target:takeDamage({
      amount = value,
      damage_type = "AP",
      field = "hp",
      source = owner,
      coefficient = 1,
      crit_mod = 1,
      soloParams = {type = 1, id = 66}
    })
  end
end

local function initBuff(buff)
  function buff.trigger()
    trigger(buff)
  end
  
  return buff
end

return initBuff

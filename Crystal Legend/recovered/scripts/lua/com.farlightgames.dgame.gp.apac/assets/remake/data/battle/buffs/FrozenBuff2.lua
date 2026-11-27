local function FrozenBuff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not buff.isTrigged then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      buff.isTrigged = true
      local value = ed.getDataTable("SoloCardSkill")[65]["Level Arg 1"][buff.rank]
      target:addFrozen(value, {type = 1, id = 65}, owner)
      return
    end
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, FrozenBuff2_update)
  return buff
end

return initBuff

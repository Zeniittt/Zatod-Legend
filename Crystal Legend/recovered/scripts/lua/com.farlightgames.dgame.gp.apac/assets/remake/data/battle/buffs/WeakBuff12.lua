local function WeakBuff12_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  buff.triggerCD = buff.triggerCD + adjustedDt
  if buff.triggerCD >= 1 then
    local value = ed.getDataTable("SoloCardSkill")[102]["Level Arg 1"][buff.rank]
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      target:addWeak(value, {type = 1, id = 102}, owner)
      owner.periodicSkillCount = owner.periodicSkillCount + 1
    end
    buff.triggerCD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.triggerCD = 0
  buff.update = override(buff.update, WeakBuff12_update)
  return buff
end

return initBuff

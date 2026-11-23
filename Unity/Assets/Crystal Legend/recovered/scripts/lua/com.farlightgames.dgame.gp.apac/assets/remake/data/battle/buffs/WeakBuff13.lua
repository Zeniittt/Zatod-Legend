local function WeakBuff13_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  buff.triggerCD = buff.triggerCD + adjustedDt
  if buff.triggerCD >= 1.5 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      local value = (owner.attribs.HP - owner.hp) * ed.getDataTable("SoloCardSkill")[103]["Level Arg 1"][buff.rank] * 0.01
      value = math.max(value, 1)
      target:addWeak(value, {type = 1, id = 103}, owner)
      owner.periodicSkillCount = owner.periodicSkillCount + 1
    end
    buff.triggerCD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.triggerCD = 0
  buff.update = override(buff.update, WeakBuff13_update)
  return buff
end

return initBuff

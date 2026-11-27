local function WeakBuff4_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  buff.triggerCD = buff.triggerCD + adjustedDt
  buff.battleTime = buff.battleTime + dt
  if buff.triggerCD >= 1 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      local value = ed.getDataTable("SoloCardSkill")[94]["Level Arg 1"][buff.rank]
      target:addWeak(value * buff.battleTime, {type = 1, id = 94}, owner)
      owner.periodicSkillCount = owner.periodicSkillCount + 1
      if not target.WeakBuff4_effect_play then
        target.WeakBuff4_effect_play = true
        local bid = 90000133
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        target:addBuff(binfo, owner)
        local bid2 = 90000134
        local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
        target:addBuff(binfo2, owner)
      end
    end
    buff.triggerCD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.triggerCD = 0
  buff.battleTime = 0
  buff.update = override(buff.update, WeakBuff4_update)
  return buff
end

return initBuff

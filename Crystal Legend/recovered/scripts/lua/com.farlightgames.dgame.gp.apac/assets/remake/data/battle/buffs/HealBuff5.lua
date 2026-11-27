local function HealBuff5_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  if buff.HealBuff5_CD then
    buff.HealBuff5_CD = buff.HealBuff5_CD + adjustedDt
  else
    buff.HealBuff5_CD = 0
  end
  if buff.HealBuff5_CD >= 1 then
    local HealBuff5_values = ed.getDataTable("SoloCardSkill")[37]["Level Arg 1"]
    owner:takeHeal(HealBuff5_values[buff.rank] or 0, "hp", owner, nil, {type = 1, id = 37})
    owner.periodicSkillCount = owner.periodicSkillCount + 1
    buff.HealBuff5_CD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.HealBuff5_CD = 0
  buff.update = override(buff.update, HealBuff5_update)
  return buff
end

return initBuff

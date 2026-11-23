local function HPBuff5_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  if buff.HPBuff5_CD then
    buff.HPBuff5_CD = buff.HPBuff5_CD + adjustedDt
  else
    buff.HPBuff5_CD = 0
  end
  if buff.HPBuff5_CD >= 1 then
    local HPBuff5_values = ed.getDataTable("SoloCardSkill")[26]["Level Arg 1"]
    local HealPower = (owner.attribs.HP - owner.hp) * (HPBuff5_values[buff.rank] or 0) / 100
    owner:takeHeal(HealPower, "hp", owner, nil, {type = 1, id = 26})
    owner.periodicSkillCount = owner.periodicSkillCount + 1
    buff.HPBuff5_CD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.HPBuff5_CD = 0
  buff.update = override(buff.update, HPBuff5_update)
  return buff
end

return initBuff

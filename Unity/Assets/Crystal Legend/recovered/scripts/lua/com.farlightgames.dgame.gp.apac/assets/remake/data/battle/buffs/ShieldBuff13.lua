local function ShieldBuff13_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  buff.triggerCD = buff.triggerCD + adjustedDt
  if buff.triggerCD >= 1.5 then
    local skill = owner.basic_skill
    local value = (owner.attribs.HP - owner.hp) * ed.getDataTable("SoloCardSkill")[89]["Level Arg 1"][buff.rank] * 0.01
    value = math.max(value, 1)
    owner:addShield(value, {type = 1, id = 89})
    owner.periodicSkillCount = owner.periodicSkillCount + 1
    buff.triggerCD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.triggerCD = 0
  buff.update = override(buff.update, ShieldBuff13_update)
  return buff
end

return initBuff

local function HasteBuff12_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  buff.triggerCD = buff.triggerCD + adjustedDt
  if buff.triggerCD >= 1 then
    local hasteAmount = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
    owner:addHaste(hasteAmount, {
      type = 1,
      id = buff.cardId
    }, owner)
    if ed.run_with_scene then
    end
    owner.periodicSkillCount = owner.periodicSkillCount + 1
    buff.triggerCD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.cardId = 117
  buff.triggerCD = 0
  buff.update = override(buff.update, HasteBuff12_update)
  return buff
end

return initBuff

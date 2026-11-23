local function HasteBuff13_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  buff.triggerCD = buff.triggerCD + adjustedDt
  if buff.triggerCD >= 1.5 then
    local percentage = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
    local lostHp = owner.attribs.HP - owner.hp
    local hasteAmount = math.max(1, math.floor(lostHp * percentage * 0.01))
    owner:addHaste(hasteAmount, {
      type = 1,
      id = buff.cardId
    }, owner)
    owner.periodicSkillCount = owner.periodicSkillCount + 1
    buff.triggerCD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.cardId = 118
  buff.triggerCD = 0
  buff.update = override(buff.update, HasteBuff13_update)
  return buff
end

return initBuff

local function DrugBuff10_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local hasteSpeedUp = owner:getHasteSpeed()
  local adjustedDt = dt * hasteSpeedUp
  if buff.triggerCD then
    buff.triggerCD = buff.triggerCD + adjustedDt
  end
  if buff.triggerCD >= 1.5 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      local drug = (owner.attribs.HP - owner.hp) * ed.getDataTable("SoloCardSkill")[61]["Level Arg 1"][buff.rank] / 100
      drug = math.max(drug, 1)
      target:addDrug(drug, {type = 1, id = 61}, owner)
      owner.periodicSkillCount = owner.periodicSkillCount + 1
    end
    buff.triggerCD = 0
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.triggerCD = 0
  buff.update = override(buff.update, DrugBuff10_update)
  return buff
end

return initBuff

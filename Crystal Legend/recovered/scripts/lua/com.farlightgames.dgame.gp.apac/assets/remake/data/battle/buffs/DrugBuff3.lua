local function DrugBuff3_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not buff.isTrigged then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      buff.isTrigged = true
      local drug = ed.getDataTable("SoloCardSkill")[54]["Level Arg 1"][buff.rank]
      target:addDrug(drug, {type = 1, id = 54}, owner)
      return
    end
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, DrugBuff3_update)
  return buff
end

return initBuff

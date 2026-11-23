local function DrugBuff2_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local lost = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  
  local owner = buff.owner
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target and ed.rand() < 0.5 then
    local drug = ed.getDataTable("SoloCardSkill")[53]["Level Arg 1"][buff.rank]
    target:addDrug(drug, {type = 1, id = 53}, owner)
  end
  return lost
end

local function initBuff(buff)
  buff.onDamaged = override(buff.onDamaged, DrugBuff2_onDamaged)
  return buff
end

return initBuff

local function FrozenBuff4_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local lost = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  
  local owner = buff.owner
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target and ed.rand() < 0.5 then
    local value = ed.getDataTable("SoloCardSkill")[67]["Level Arg 1"][buff.rank]
    target:addFrozen(value, {type = 1, id = 67}, owner)
  end
  return lost
end

local function initBuff(buff)
  buff.onDamaged = override(buff.onDamaged, FrozenBuff4_onDamaged)
  return buff
end

return initBuff

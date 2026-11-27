local function FrozenBuff13_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local skill = owner.basic_skill
  local target = skill:selectTarget()
  if target then
    target.drugDamageAdd = math.floor(target.frozenValue / 10) * ed.getDataTable("SoloCardSkill")[76]["Level Arg 1"][buff.rank]
  end
end

local function initBuff(buff)
  local owner = buff.owner
  buff.triggerCD = 0
  buff.update = override(buff.update, FrozenBuff13_update)
  return buff
end

return initBuff

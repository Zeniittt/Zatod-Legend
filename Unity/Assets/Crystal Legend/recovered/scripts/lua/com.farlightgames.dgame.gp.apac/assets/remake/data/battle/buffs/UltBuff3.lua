local function onAttackSlot1(buff, skill)
  local owner = buff.owner
  
  local basic_skill = owner.basic_skill
  local target = basic_skill:selectTarget()
  local UltBuff3_values1 = ed.getDataTable("SoloCardSkill")[45]["Level Arg 1"]
  local UltBuff3_values2 = ed.getDataTable("SoloCardSkill")[45]["Level Arg 2"]
  local StunTime = UltBuff3_values1[buff.rank] + ed.rand() * (UltBuff3_values2[buff.rank] - UltBuff3_values1[buff.rank])
  if target then
    local StunBid = 90000059
    local StunBinfo = ed.lookupDataTable("Buff", nil, StunBid)
    local StunBuff = ed.BuffCreate(StunBinfo, target, owner)
    StunBuff.timer = StunTime
    target:addBuff(StunBuff, owner)
  end
end

local function initBuff(buff)
  function buff.onAttackSlot1(skill)
    onAttackSlot1(buff, skill)
  end
  
  return buff
end

return initBuff

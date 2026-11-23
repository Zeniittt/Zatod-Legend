local function HealBuff9_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.HealBuff9 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      local HealBuff9_values = ed.getDataTable("SoloCardSkill")[41]["Level Arg 1"]
      local HealDown_Ratio = -(HealBuff9_values[buff.rank] or 0)
      local HealDownBid = 90000057
      local HealDownBinfo = ed.lookupDataTable("Buff", nil, HealDownBid)
      owner.HealBuff9 = true
      local HealDownBuff = ed.BuffCreate(HealDownBinfo, target, owner)
      HealDownBuff:setAttribute("HealRatio", HealDown_Ratio, owner)
      target:addBuff(HealDownBuff, owner)
    end
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.HealBuff9 = false
  end
  buff.update = override(buff.update, HealBuff9_update)
  return buff
end

return initBuff

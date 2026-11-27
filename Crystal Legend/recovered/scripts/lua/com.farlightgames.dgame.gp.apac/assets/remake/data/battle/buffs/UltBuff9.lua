local function UltBuff9_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.UltBuff9 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      owner.UltBuff9 = true
      local UltBuff9_values = ed.getDataTable("SoloCardSkill")[51]["Level Arg 1"]
      local UltDown_Ratio = -(UltBuff9_values[buff.rank] or 0) / 100
      local UltDownBid = 90000060
      local UltDownBinfo = ed.lookupDataTable("Buff", nil, UltDownBid)
      local UltDownBuff = ed.BuffCreate(UltDownBinfo, target, owner)
      UltDownBuff:setAttribute("MPGainRatio", -UltDown_Ratio, owner)
      target:resetBuffApply(buff)
      target:rebuild()
    end
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.UltBuff9 = false
  end
  buff.update = override(buff.update, UltBuff9_update)
  return buff
end

return initBuff

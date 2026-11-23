local function onHitMiss(buff)
  local buffCount = 0
  
  for k, v in ipairs(buff.owner.buff_list or {}) do
    if v.info.ID == 90000022 then
      buffCount = buffCount + 1
    end
  end
  if 4 <= buffCount then
    return
  end
  local binfo = ed.lookupDataTable("Buff", nil, 90000022)
  local Attack71buff = ed.BuffCreate(binfo, buff.owner, buff.owner)
  local AttackBuff71_values = ed.getDataTable("SoloCardSkill")[7]["Level Arg 1"]
  Attack71buff:setAttribute("AD", AttackBuff71_values[buff.rank] or 0)
  buff.owner:addBuff(Attack71buff)
end

local function initBuff(buff)
  function buff.onHitMiss()
    onHitMiss(buff)
  end
  
  return buff
end

return initBuff

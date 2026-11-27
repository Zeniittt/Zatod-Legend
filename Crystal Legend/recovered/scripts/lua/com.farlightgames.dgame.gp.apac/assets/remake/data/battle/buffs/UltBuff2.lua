local function onAttackSlot1(buff, skill)
  local owner = buff.owner
  
  local bid = 90000058
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local MPRbuff = ed.BuffCreate(binfo, owner, owner)
  local UltBuff2_value = ed.getDataTable("SoloCardSkill")[44]["Level Arg 1"]
  MPRbuff:setAttribute("MPR", UltBuff2_value[buff.rank])
  owner:addBuff(MPRbuff, owner)
end

local function initBuff(buff)
  function buff.onAttackSlot1(skill)
    onAttackSlot1(buff, skill)
  end
  
  return buff
end

return initBuff

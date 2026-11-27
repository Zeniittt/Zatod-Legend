local function rogueBless8313onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and not transferred and source and not source.config.is_summoned and bCrit and field and field == "hp" and ed.engine.rogueSkillMgr:getBless(8313) then
    local bless8313 = ed.engine.rogueSkillMgr.rogueBlessList[8313]
    local MSPD = bless8313.isReinforced and bless8313.info["Script Arg5"] or bless8313.info["Script Arg1"]
    local time = bless8313.isReinforced and bless8313.info["Script Arg6"] or bless8313.info["Script Arg2"]
    local have8313buff = false
    for i, tbuff in ipairs(source.buff_list) do
      if tbuff.info.ID == 60018313 then
        tbuff.timer = time
        have8313buff = true
      end
    end
    if not have8313buff then
      local bless8313bid = 60018313
      local bless8313binfo = ed.lookupDataTable("Buff", nil, bless8313bid)
      local bless8313buff = ed.BuffCreate(bless8313binfo, source, source)
      bless8313buff:setAttribute("MSPD", MSPD)
      bless8313buff.timer = time
      source:addBuff(bless8313buff, source)
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless8313onDamaged)
  return buff
end

return initBuff

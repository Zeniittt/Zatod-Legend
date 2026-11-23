local function rogueBless8314onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if damage and 0 < damage and not transferred and source and not source.config.is_summoned and bCrit and field and field == "hp" and ed.engine.rogueSkillMgr:getBless(8314) then
    local bless8314 = ed.engine.rogueSkillMgr.rogueBlessList[8314]
    local ADDP = bless8314.isReinforced and bless8314.info["Script Arg5"] or bless8314.info["Script Arg1"]
    local APDP = bless8314.isReinforced and bless8314.info["Script Arg5"] or bless8314.info["Script Arg1"]
    local time = bless8314.isReinforced and bless8314.info["Script Arg6"] or bless8314.info["Script Arg2"]
    local have8314buff = false
    for i, tbuff in ipairs(source.buff_list) do
      if tbuff.info.ID == 60018314 then
        tbuff.timer = time
        have8314buff = true
      end
    end
    if not have8314buff then
      local bless8314bid = 60018314
      local bless8314binfo = ed.lookupDataTable("Buff", nil, bless8314bid)
      local bless8314buff = ed.BuffCreate(bless8314binfo, source, source)
      bless8314buff:setAttribute("ADDP", ADDP)
      bless8314buff:setAttribute("APDP", APDP)
      bless8314buff.timer = time
      source:addBuff(bless8314buff, source)
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless8314onDamaged)
  return buff
end

return initBuff

local function rogueBless8312onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and not transferred and source and not source.config.is_summoned and bCrit and field and field == "hp" and ed.engine.rogueSkillMgr:getBless(8312) then
    local bless8312 = ed.engine.rogueSkillMgr.rogueBlessList[8312]
    local HAST = bless8312.isReinforced and bless8312.info["Script Arg5"] or bless8312.info["Script Arg1"]
    local time = bless8312.isReinforced and bless8312.info["Script Arg6"] or bless8312.info["Script Arg2"]
    local have8312buff = false
    for i, tbuff in ipairs(source.buff_list) do
      if tbuff.info.ID == 60018312 then
        tbuff.timer = time
        have8312buff = true
      end
    end
    if not have8312buff then
      local bless8312bid = 60018312
      local bless8312binfo = ed.lookupDataTable("Buff", nil, bless8312bid)
      local bless8312buff = ed.BuffCreate(bless8312binfo, source, source)
      bless8312buff:setAttribute("HAST", HAST)
      bless8312buff.timer = time
      source:addBuff(bless8312buff, source)
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless8312onDamaged)
  return buff
end

return initBuff

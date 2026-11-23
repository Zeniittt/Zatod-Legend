local function rogueBless7203onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and not transferred and source and not source.config.is_summoned and source.camp == 1 and field and field == "hp" and ed.engine.rogueSkillMgr:getBless(7203) then
    local bless7203 = ed.engine.rogueSkillMgr.rogueBlessList[7203]
    local p = (bless7203.isReinforced and bless7203.info["Script Arg5"] or bless7203.info["Script Arg1"]) / 100
    local ratio = (bless7203.isReinforced and bless7203.info["Script Arg6"] or bless7203.info["Script Arg2"]) / 100
    local maxshield = bless7203.isReinforced and bless7203.info["Script Arg7"] or bless7203.info["Script Arg3"]
    local bless7203shield = damage * ratio
    if p >= ed.rand() then
      local ShieldIncrease = 0
      local ShieldWeak = 0
      if source.attribs.ShieldIncrease then
        ShieldIncrease = source.attribs.ShieldIncrease
      end
      if source.attribs.ShieldWeak then
        ShieldWeak = source.attribs.ShieldWeak
      end
      local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
      local shieldnum = math.min(bless7203shield * shieldratio, maxshield)
      local have7203buff = false
      for i, tbuff in ipairs(source.buff_list) do
        if tbuff.info.ID == 60017000 then
          tbuff.shield = tbuff.shield + shieldnum
          have7203buff = true
        end
      end
      if not have7203buff then
        local bless7203bid = 60017000
        local bless7203binfo = ed.lookupDataTable("Buff", nil, bless7203bid)
        local bless7203buff = ed.BuffCreate(bless7203binfo, source, source)
        bless7203buff.shield = shieldnum
        source:addBuff(bless7203buff, source)
      end
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless7203onDamaged)
  return buff
end

return initBuff

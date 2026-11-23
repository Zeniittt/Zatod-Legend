local function rogueBless8315update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local caster = buff.caster
  local magiccaster = ed.engine.rogueSkillMgr.magicCaster
  local count = 0
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 60028315 and tbuff.timer > 1 or tbuff.info.ID == 60038315 and tbuff.timer > 1 or tbuff.info.ID == 60048315 and tbuff.timer > 1 then
      count = count + 1
    end
  end
  if ed.engine.rogueSkillMgr:getBless(8315) then
    local bless8315 = ed.engine.rogueSkillMgr.rogueBlessList[8315]
    if count == 3 then
      local maxBles8315Damage = bless8315.isReinforced and bless8315.info["Script Arg6"] or bless8315.info["Script Arg2"]
      local damage8315 = math.min(owner.attribs.HP * (bless8315.isReinforced and bless8315.info["Script Arg5"] or bless8315.info["Script Arg1"]) / 100, maxBles8315Damage)
      owner:takeDamage(damage8315, "Holy", "hp", magiccaster)
      local bid4 = 60018315
      local binfo4 = ed.lookupDataTable("Buff", nil, bid4)
      local buff4 = owner:addBuff(binfo4, magiccaster)
      for i, tbuff in ipairs(owner.buff_list) do
        if tbuff.info.ID == 60028315 or tbuff.info.ID == 60038315 or tbuff.info.ID == 60048315 then
          tbuff.timer = -1
        end
      end
      if ed.run_with_scene then
        local effect_name = "eff_impact_TitanDR_atk3.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, owner.position, nil, nil, 1)
        end
      end
    end
  end
end

local function rogueBless8315onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local caster = buff.caster
  local owner = buff.owner
  if 0 < dmg and field and field == "hp" and source and source.camp == 1 and not source.config.is_summoned then
    if damage_type == "Holy" then
      local bid1 = 60028315
      local binfo1 = ed.lookupDataTable("Buff", nil, bid1)
      local buff1 = owner:addBuff(binfo1, caster)
    end
    if damage_type == "AD" then
      local bid2 = 60038315
      local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
      local buff2 = ed.BuffCreate(binfo2, owner, caster)
      owner:addBuff(buff2, caster)
    end
    if damage_type == "AP" then
      local bid3 = 60048315
      local binfo3 = ed.lookupDataTable("Buff", nil, bid3)
      local buff3 = owner:addBuff(binfo3, caster)
    end
  end
  return dmg
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless8315onDamaged)
  buff.update = override(buff.update, rogueBless8315update)
  return buff
end

return initBuff

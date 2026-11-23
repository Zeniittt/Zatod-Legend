local function rogueBless6404onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and bCrit and not transferred and field and field == "hp" and ed.engine.rogueSkillMgr:getBless(6404) then
    local magiccaster = ed.engine.rogueSkillMgr.magicCaster
    local bless6404 = ed.engine.rogueSkillMgr.rogueBlessList[6404]
    local p = bless6404.info["Script Arg1"] / 100
    if p > ed.rand() and not owner.buff_effects.invulnerable then
      local bless6404bid = 60016404
      local bless6404binfo = ed.lookupDataTable("Buff", nil, bless6404bid)
      local bless6404buff = ed.BuffCreate(bless6404binfo, owner, magiccaster)
      bless6404buff.timer = bless6404.info["Script Arg2"]
      owner:addBuff(bless6404buff, magiccaster)
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless6404onDamaged)
  return buff
end

return initBuff

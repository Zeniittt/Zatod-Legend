local function rogueBless5315onRemove(basefunc, buff)
  local owner = buff.owner
  
  local caster = buff.caster
  local magiccaster = ed.engine.rogueSkillMgr.magicCaster
  basefunc(buff)
  if buff.timer <= 0 and not ed.engine.beingEnd then
    local bless5315 = ed.engine.rogueSkillMgr.rogueBlessList[5315]
    if not owner.buff_effects.uncontrollable and not owner.buff_effects.invulnerable then
      local bless5315bid = 60015315
      local bless5315binfo = ed.lookupDataTable("Buff", nil, bless5315bid)
      local bless5315buff = ed.BuffCreate(bless5315binfo, owner, magiccaster)
      bless5315buff.timer = bless5315.info["Script Arg6"]
      owner:addBuff(bless5315buff, magiccaster)
    end
  end
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  if ed.engine.rogueSkillMgr:getBless(5315) then
    local bless5315 = ed.engine.rogueSkillMgr.rogueBlessList[5315]
    if bless5315.isReinforced then
      buff.timer = bless5315.info["Script Arg5"]
      buff.onRemoved = override(buff.onRemoved, rogueBless5315onRemove)
    end
  end
  return buff
end

return initBuff

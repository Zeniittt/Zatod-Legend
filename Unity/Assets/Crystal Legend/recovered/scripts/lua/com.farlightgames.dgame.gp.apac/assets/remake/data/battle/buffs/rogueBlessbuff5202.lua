local function rogueBless5202onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and field and field == "hp" and ed.engine.rogueSkillMgr:getBless(5202) then
    local bless5202 = ed.engine.rogueSkillMgr.rogueBlessList[5202]
    damage = damage * (1 + (bless5202.isReinforced and bless5202.info["Script Arg5"] or bless5202.info["Script Arg1"]) / 100)
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless5202onDamaged)
  return buff
end

return initBuff

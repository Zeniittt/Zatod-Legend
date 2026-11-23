local function rogueBless6402onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and damage_type == "AP" and ed.engine.rogueSkillMgr:getBless(6402) then
    local bless6402 = ed.engine.rogueSkillMgr.rogueBlessList[6402]
    local hprdmgbuff = 0
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.HPR and 0 > tbuff.info.HPR then
        hprdmgbuff = hprdmgbuff + 1
      end
    end
    damage = damage * (1 + hprdmgbuff * bless6402.info["Script Arg1"] / 100)
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless6402onDamaged)
  return buff
end

return initBuff

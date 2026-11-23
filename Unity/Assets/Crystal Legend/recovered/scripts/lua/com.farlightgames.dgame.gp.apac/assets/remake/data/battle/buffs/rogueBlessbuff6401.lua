local function rogueBless6401onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and damage_type == "AD" and ed.engine.rogueSkillMgr:getBless(6401) then
    local bless6401 = ed.engine.rogueSkillMgr.rogueBlessList[6401]
    local hprdmgbuff = 0
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.info.HPR and 0 > tbuff.info.HPR then
        hprdmgbuff = hprdmgbuff + 1
      end
    end
    damage = damage * (1 + hprdmgbuff * bless6401.info["Script Arg1"] / 100)
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless6401onDamaged)
  return buff
end

return initBuff

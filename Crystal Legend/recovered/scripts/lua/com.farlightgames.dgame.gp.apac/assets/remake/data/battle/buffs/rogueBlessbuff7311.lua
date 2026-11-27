local function rogueBless7311onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  if 0 < damage and field and field == "hp" and ed.engine.rogueSkillMgr:getBless(7311) then
    local bless7311 = ed.engine.rogueSkillMgr.rogueBlessList[7311]
    local totalADshield = 0
    local totalAPshield = 0
    local totalALLshield = 0
    for i, tbuff in ipairs(owner.buff_list) do
      if tbuff.shield and 0 < tbuff.shield then
        local stype = tbuff.info["Shield Type"]
        if stype == "AD" then
          totalADshield = totalADshield + tbuff.shield
        elseif stype == "AP" then
          totalAPshield = totalAPshield + tbuff.shield
        elseif stype == "all" then
          totalALLshield = totalALLshield + tbuff.shield
        end
      end
    end
    totalADshield = totalADshield + totalALLshield
    totalAPshield = totalAPshield + totalALLshield
    if damage_type == "AD" then
      if 0 < totalADshield and damage >= totalADshield then
        local overDamage = damage - totalADshield
        damage = totalADshield
        if bless7311.isReinforced then
          owner:takeHeal(overDamage, "hp", owner)
        end
      end
    elseif damage_type == "AP" then
      if 0 < totalAPshield and totalAPshield <= damage then
        local overDamage = damage - totalAPshield
        damage = totalAPshield
        if bless7311.isReinforced then
          owner:takeHeal(overDamage, "hp", owner)
        end
      end
    elseif damage_type == "Holy" and 0 < totalALLshield and totalALLshield <= damage then
      local overDamage = damage - totalALLshield
      damage = totalALLshield
      if bless7311.isReinforced then
        owner:takeHeal(overDamage, "hp", owner)
      end
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.onDamaged = override(buff.onDamaged, rogueBless7311onDamaged)
  return buff
end

return initBuff

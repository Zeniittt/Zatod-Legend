local function ShieldBuff3_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local lost = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  
  local owner = buff.owner
  if damage_type == "Holy" then
    return lost
  end
  if lost and 0 < lost and field == "hp" then
    local damageReduction = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
    local totalReduction = damageReduction * buff.shieldSkillCount
    lost = math.max(0, lost - totalReduction)
  end
  return lost
end

local function initBuff(buff)
  local owner = buff.owner
  local shieldSkillCount = 0
  if owner.cards then
    for k, v in pairs(owner.cards) do
      local cardTb = ed.getDataTable("SoloCardSkill")[k]
      if cardTb and (cardTb.Tag1 == 9 or cardTb.Tag2 == 9) then
        shieldSkillCount = shieldSkillCount + 1
      end
    end
  end
  buff.shieldSkillCount = shieldSkillCount
  buff.cardId = 79
  buff.onDamaged = override(buff.onDamaged, ShieldBuff3_onDamaged)
  return buff
end

return initBuff

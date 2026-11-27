local function roguechapterbuff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  if buff.dt == 1 then
    local owner = buff.owner
    local buffid = buff.info.ID
    local shieldvalue = 0
    if buffid - 62000000 == 1 then
      shieldvalue = 0.1 * owner.attribs.HP
    end
    if 1 < buffid - 62000000 then
      shieldvalue = (0.1 + 0.02 * (buffid - 62000001)) * owner.attribs.HP
    end
    buff.shield = shieldvalue
    local crisisDiff = ed.engine.rogueChapterBattleInfo.crisisDiff or 0
    local rogueNPC = ed.engine.rogueSkillMgr:getSkillCaster()
    if crisisDiff and 3 <= crisisDiff then
      local revelation = ed.engine.rogueSkillMgr:getRogueRevelation()
      if revelation and not rogueNPC.energychange then
        revelation:addEnergyAutoReturnRatio(-0.05 * crisisDiff)
        revelation:addEnergyRatio(-0.05 * crisisDiff)
        rogueNPC.energychange = true
      end
    end
  end
end

local function roguechapterbuff2_CrisisonDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  local owner = buff.owner
  local crisisDiff = ed.engine.rogueChapterBattleInfo.crisisDiff or 0
  if 0 < damage and field and field == "hp" and crisisDiff and 3 <= crisisDiff then
    local totalshield = 0
    totalshield = buff.shield
    if 0 < totalshield and damage >= totalshield then
      damage = totalshield
      buff.shield = -1
      buff.timer = -1
      return basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
    end
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
end

local function initBuff(buff)
  buff.update = override(buff.update, roguechapterbuff2_update)
  buff.onDamaged = override(buff.onDamaged, roguechapterbuff2_CrisisonDamaged)
  buff.unremoveable = true
  return buff
end

return initBuff

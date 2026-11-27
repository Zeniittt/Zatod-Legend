local function roguechapterbuff5_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  if buff.dt == 1 then
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

local function roguechapterbuff5_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  local owner = buff.owner
  if damage and 0 < damage and not transferred and source and source.camp == 1 and field and field == "hp" then
    if bCrit then
      damage = damage * (1 + buff.RCP5CritUP)
    else
      damage = damage * (1 - buff.RCP5unCritDown)
    end
  end
  return damage
end

local function initBuff(buff)
  local owner = buff.owner
  local buffid = buff.info.ID
  buff.RCP5unCritDown = (10 + 5 * (buffid - 65000000)) / 100
  buff.RCP5CritUP = (30 - 5 * (buffid - 65000000)) / 100
  buff.unremoveable = true
  buff.onDamaged = override(buff.onDamaged, roguechapterbuff5_onDamaged)
  buff.update = override(buff.update, roguechapterbuff5_update)
  return buff
end

return initBuff

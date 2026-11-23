local function roguechapterbuff4_update(basefunc, buff, dt)
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

local function roguechapterbuff4_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if dmg and source and damage_type == "AD" and field == "hp" and not transferred then
    local reducedmg = dmg * owner.cp4reflectratio / 100
    dmg = dmg - reducedmg
    source:takeDamage(reducedmg / owner.attribs.PDM * (1 - owner.attribs.LevelPIMU / 100), "Holy", "hp", owner, 1, 1, true)
  end
  return dmg
end

local function initBuff(buff)
  local owner = buff.owner
  local buffid = buff.info.ID
  owner.cp4reflectratio = 8 + 2 * (buffid - 64000000)
  local crisisDiff = ed.engine.rogueChapterBattleInfo.crisisDiff or 0
  if crisisDiff and 3 <= crisisDiff then
    owner.cp4reflectratio = owner.cp4reflectratio + (crisisDiff - 2) * 5
  end
  buff.unremoveable = true
  buff.onDamaged = override(buff.onDamaged, roguechapterbuff4_onDamaged)
  buff.update = override(buff.update, roguechapterbuff4_update)
  return buff
end

return initBuff

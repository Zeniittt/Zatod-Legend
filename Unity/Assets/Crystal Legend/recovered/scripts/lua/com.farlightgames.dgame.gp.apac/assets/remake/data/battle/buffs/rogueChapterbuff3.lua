local function roguechapterbuff3_update(basefunc, buff, dt)
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

local function initBuff(buff)
  local owner = buff.owner
  local buffid = buff.info.ID
  local hprvalue = -100 + -200 * (buffid - 63000000) * (1 + ed.engine.rogueWaveBonusCfg.Wave / 40)
  if buffid == 63000004 then
    hprvalue = hprvalue - 100
  end
  buff:setAttribute("HPR", hprvalue)
  buff.unremoveable = true
  buff.update = override(buff.update, roguechapterbuff3_update)
  return buff
end

return initBuff

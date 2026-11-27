local function roguecrisisbuff32_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  buff.dt = buff.dt and buff.dt + dt or dt
  if buff.dt == 1 then
    local owner = buff.owner
    local crisisDiff = ed.engine.rogueChapterBattleInfo.crisisDiff or 0
    if crisisDiff then
      buff:setAttribute("MPRatio", -5 * crisisDiff)
      buff:setAttribute("MPGainRatio", -5 * crisisDiff)
      if 3 <= crisisDiff then
        buff:setAttribute("PIMU", -10 * (crisisDiff - 2))
        buff:setAttribute("MIMU", -10 * (crisisDiff - 2))
      end
      owner:rebuild()
    end
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, roguecrisisbuff32_update)
  buff.unremoveable = true
  return buff
end

return initBuff

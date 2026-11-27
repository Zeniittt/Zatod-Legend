local function HasteBuff14_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.HasteBuff14 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      owner.HasteBuff14 = true
      buff.cardId = 119
      local value = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
      target.deHasteRatio = target.deHasteRatio + value / 100
    end
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, HasteBuff14_update)
  return buff
end

return initBuff

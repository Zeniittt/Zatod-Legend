local function HasteBuff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.HasteBuff2_triggered then
    owner.HasteBuff2_triggered = true
    local hasteAmount = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
    owner:addHaste(hasteAmount, {
      type = 1,
      id = buff.cardId
    }, owner)
    if ed.run_with_scene then
      local effect_name = "eff_point_solo_card107_1.cha"
      ed.scene:playEffectOnScene(effect_name, owner.position, {
        owner.direction,
        1
      }, nil, 1)
      local effect_name = "eff_point_solo_card107_2.cha"
      ed.scene:playEffectOnScene(effect_name, owner.position, {
        owner.direction,
        1
      }, nil, -1)
    end
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.HasteBuff2_triggered = false
  end
  buff.cardId = 107
  buff.update = override(buff.update, HasteBuff2_update)
  return buff
end

return initBuff

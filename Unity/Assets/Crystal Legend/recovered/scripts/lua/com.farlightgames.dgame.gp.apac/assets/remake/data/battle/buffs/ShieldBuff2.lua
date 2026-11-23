local function ShieldBuff2_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if not owner.ShieldBuff2 then
    owner.ShieldBuff2 = true
    local shieldAmount = ed.getDataTable("SoloCardSkill")[buff.cardId]["Level Arg 1"][buff.rank] or 0
    owner:addShield(shieldAmount, {
      type = 1,
      id = buff.cardId
    })
    if ed.run_with_scene then
      local effect_name = "eff_point_solo_card78.cha"
      ed.scene:playEffectOnScene(effect_name, owner.position, {
        owner.direction,
        1
      }, nil, 1)
    end
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.ShieldBuff2 = false
  end
  buff.cardId = 78
  buff.update = override(buff.update, ShieldBuff2_update)
  return buff
end

return initBuff

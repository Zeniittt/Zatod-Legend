local function CritBuff1_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if owner.CritBuff1_timer then
    owner.CritBuff1_timer = owner.CritBuff1_timer + dt
  else
    owner.CritBuff1_timer = 0
  end
  if owner.CritBuff1_timer and owner.CritBuff1_timer >= 0.2 and not owner.CritBuff1 then
    local skill = owner.basic_skill
    local target = skill:selectTarget()
    if target then
      owner.CritBuff1 = true
      local param = ed.getDataTable("SoloCardSkill")[16]["Level Arg 1"][1] / 100
      if ed.run_with_scene then
        ed.scene:playEffectOnScene("eff_point_solo_card16.cha", {
          target.position[1],
          target.position[2] - 15
        }, {
          target.direction * 1.3,
          1.3
        }, nil, 1)
      end
      target:takeDamage({
        amount = param * target.attribs.HP,
        damage_type = "Holy",
        field = "hp",
        source = owner,
        coefficient = 1,
        crit_mod = 1,
        soloParams = {type = 1, id = 16}
      })
    end
  end
end

local function initBuff(buff)
  local owner = buff.owner
  if owner then
    owner.CritBuff1 = false
  end
  buff.update = override(buff.update, CritBuff1_update)
  return buff
end

return initBuff

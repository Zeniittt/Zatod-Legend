local function rogueBless7404update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  local totalshield = 0
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.shield and 0 < tbuff.shield then
      totalshield = totalshield + tbuff.shield
    end
  end
  if owner.revelation7buff then
    totalshield = totalshield + owner.revelation7buffshield
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(7404) and 0 < totalshield then
      local bless7404 = ed.engine.rogueSkillMgr.rogueBlessList[7404]
      local HPR = -bless7404.info["Script Arg1"] / 100 * totalshield
      local list = {}
      local arg1 = 150
      for unit in ed.engine:foreachAliveUnit(-1) do
        local p = ed.edpSub(unit.position, owner.position)
        if p[1] * p[1] + p[2] * p[2] <= arg1 * arg1 then
          table.insert(list, unit)
        end
      end
      for k, unit in ipairs(list) do
        if not unit.buff_effects.invulnerable then
          local bless7404bid = 60017404
          local bless7404binfo = ed.lookupDataTable("Buff", nil, bless7404bid)
          local bless7404buff = ed.BuffCreate(bless7404binfo, unit, owner)
          bless7404buff:setAttribute("HPR", HPR)
          unit:addBuff(bless7404buff, owner)
        end
      end
    end
  end
  buff.attack_timer = timer
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.attack_timer = 1
  buff.update = override(buff.update, rogueBless7404update)
  return buff
end

return initBuff

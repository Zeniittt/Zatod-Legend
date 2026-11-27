local function rogueBless7402update(basefunc, buff, dt)
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
    if ed.engine.rogueSkillMgr:getBless(7402) then
      local bless7402 = ed.engine.rogueSkillMgr.rogueBlessList[7402]
      local HPR = math.min(bless7402.info["Script Arg1"] / 100 * totalshield, bless7402.info["Script Arg2"])
      if 0 < totalshield and HPR ~= buff.bless7402lasthpr then
        buff.bless7402lasthpr = HPR
        buff:setAttribute("HPR", HPR)
        owner.bless7402havebeeffect = true
        owner:rebuild()
      elseif totalshield == 0 and owner.bless7402havebeeffect then
        buff:setAttribute("HPR", 0)
        owner.bless7402havebeeffect = false
        owner:rebuild()
      end
    end
  end
  buff.attack_timer = timer
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.attack_timer = 1
  buff.bless7402lasthpr = 0
  buff.update = override(buff.update, rogueBless7402update)
  return buff
end

return initBuff

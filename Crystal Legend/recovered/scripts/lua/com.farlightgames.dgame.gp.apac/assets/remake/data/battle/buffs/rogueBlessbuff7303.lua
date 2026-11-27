local function rogueBless7303update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.bless7303haveshield = false
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.shield and tbuff.shield > 0 then
      owner.bless7303haveshield = true
      break
    end
  end
  if owner.revelation7buff then
    owner.bless7303haveshield = true
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(7303) then
      local bless7303 = ed.engine.rogueSkillMgr.rogueBlessList[7303]
      local MCRIT = 0
      if 0 < owner.attribs.MCRIT then
        MCRIT = owner.attribs.MCRIT * (bless7303.isReinforced and bless7303.info["Script Arg5"] or bless7303.info["Script Arg1"]) / 100
      end
      if owner.bless7303haveshield and not owner.bless7303havebeeffect then
        buff:setAttribute("MCRIT", MCRIT)
        owner.bless7303havebeeffect = true
        owner:rebuild()
      elseif not owner.bless7303haveshield and owner.bless7303havebeeffect then
        buff:setAttribute("MCRIT", 0)
        owner.bless7303havebeeffect = false
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
  buff.update = override(buff.update, rogueBless7303update)
  return buff
end

return initBuff

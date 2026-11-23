local function rogueBless7302update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.bless7302haveshield = false
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.shield and tbuff.shield > 0 then
      owner.bless7302haveshield = true
      break
    end
  end
  if owner.revelation7buff then
    owner.bless7302haveshield = true
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(7302) then
      local bless7302 = ed.engine.rogueSkillMgr.rogueBlessList[7302]
      local CRIT = 0
      if 0 < owner.attribs.CRIT then
        CRIT = owner.attribs.CRIT * (bless7302.isReinforced and bless7302.info["Script Arg5"] or bless7302.info["Script Arg1"]) / 100
      end
      if owner.bless7302haveshield and not owner.bless7302havebeeffect then
        buff:setAttribute("CRIT", CRIT)
        owner.bless7302havebeeffect = true
        owner:rebuild()
      elseif not owner.bless7302haveshield and owner.bless7302havebeeffect then
        buff:setAttribute("CRIT", 0)
        owner.bless7302havebeeffect = false
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
  buff.update = override(buff.update, rogueBless7302update)
  return buff
end

return initBuff

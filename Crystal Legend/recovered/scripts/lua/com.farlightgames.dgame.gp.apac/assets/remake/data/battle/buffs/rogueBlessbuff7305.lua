local function rogueBless7305update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.bless7305haveshield = false
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.shield and tbuff.shield > 0 then
      owner.bless7305haveshield = true
      break
    end
  end
  if owner.revelation7buff then
    owner.bless7305haveshield = true
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(7305) then
      local bless7305 = ed.engine.rogueSkillMgr.rogueBlessList[7305]
      local MCSD = bless7305.isReinforced and bless7305.info["Script Arg5"] or bless7305.info["Script Arg1"]
      if owner.bless7305haveshield and not owner.bless7305havebeeffect then
        buff:setAttribute("MCSD", MCSD)
        owner.bless7305havebeeffect = true
        owner:rebuild()
      elseif not owner.bless7305haveshield and owner.bless7305havebeeffect then
        buff:setAttribute("MCSD", 0)
        owner.bless7305havebeeffect = false
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
  buff.update = override(buff.update, rogueBless7305update)
  return buff
end

return initBuff

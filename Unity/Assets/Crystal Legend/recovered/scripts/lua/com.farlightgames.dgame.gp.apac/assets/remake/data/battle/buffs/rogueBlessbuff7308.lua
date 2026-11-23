local function rogueBless7308update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.bless7308haveshield = false
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.shield and tbuff.shield > 0 then
      owner.bless7308haveshield = true
      break
    end
  end
  if owner.revelation7buff then
    owner.bless7308haveshield = true
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(7308) then
      local bless7308 = ed.engine.rogueSkillMgr.rogueBlessList[7308]
      local MR = 0
      if 0 < owner.attribs.MR then
        MR = owner.attribs.MR * (bless7308.isReinforced and bless7308.info["Script Arg5"] or bless7308.info["Script Arg1"]) / 100
      end
      if owner.bless7308haveshield and not owner.bless7308havebeeffect then
        buff:setAttribute("MR", MR)
        owner.bless7308havebeeffect = true
        owner:rebuild()
      elseif not owner.bless7308haveshield and owner.bless7308havebeeffect then
        buff:setAttribute("MR", 0)
        owner.bless7308havebeeffect = false
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
  buff.update = override(buff.update, rogueBless7308update)
  return buff
end

return initBuff

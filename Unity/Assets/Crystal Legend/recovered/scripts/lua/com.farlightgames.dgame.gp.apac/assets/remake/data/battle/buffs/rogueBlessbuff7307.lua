local function rogueBless7307update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.bless7307haveshield = false
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.shield and tbuff.shield > 0 then
      owner.bless7307haveshield = true
      break
    end
  end
  if owner.revelation7buff then
    owner.bless7307haveshield = true
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(7307) then
      local bless7307 = ed.engine.rogueSkillMgr.rogueBlessList[7307]
      local ARM = 0
      if 0 < owner.attribs.ARM then
        ARM = owner.attribs.ARM * (bless7307.isReinforced and bless7307.info["Script Arg5"] or bless7307.info["Script Arg1"]) / 100
      end
      if owner.bless7307haveshield and not owner.bless7307havebeeffect then
        buff:setAttribute("ARM", ARM)
        owner.bless7307havebeeffect = true
        owner:rebuild()
      elseif not owner.bless7307haveshield and owner.bless7307havebeeffect then
        buff:setAttribute("ARM", 0)
        owner.bless7307havebeeffect = false
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
  buff.update = override(buff.update, rogueBless7307update)
  return buff
end

return initBuff

local function rogueBless7304update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.bless7304haveshield = false
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.shield and tbuff.shield > 0 then
      owner.bless7304haveshield = true
      break
    end
  end
  if owner.revelation7buff then
    owner.bless7304haveshield = true
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(7304) then
      local bless7304 = ed.engine.rogueSkillMgr.rogueBlessList[7304]
      local CSD = bless7304.isReinforced and bless7304.info["Script Arg5"] or bless7304.info["Script Arg1"]
      if owner.bless7304haveshield and not owner.bless7304havebeeffect then
        buff:setAttribute("CSD", CSD)
        owner.bless7304havebeeffect = true
        owner:rebuild()
      elseif not owner.bless7304haveshield and owner.bless7304havebeeffect then
        buff:setAttribute("CSD", 0)
        owner.bless7304havebeeffect = false
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
  buff.update = override(buff.update, rogueBless7304update)
  return buff
end

return initBuff

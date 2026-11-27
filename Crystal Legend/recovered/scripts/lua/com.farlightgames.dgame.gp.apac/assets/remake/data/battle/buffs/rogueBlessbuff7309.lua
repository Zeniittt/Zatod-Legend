local function rogueBless7309update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.bless7309haveshield = false
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.shield and tbuff.shield > 0 then
      owner.bless7309haveshield = true
      break
    end
  end
  if owner.revelation7buff then
    owner.bless7309haveshield = true
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(7309) then
      local bless7309 = ed.engine.rogueSkillMgr.rogueBlessList[7309]
      local DODG = bless7309.isReinforced and bless7309.info["Script Arg5"] or bless7309.info["Script Arg1"]
      if owner.bless7309haveshield and not owner.bless7309havebeeffect then
        buff:setAttribute("DODG", DODG)
        owner.bless7309havebeeffect = true
        owner:rebuild()
      elseif not owner.bless7309haveshield and owner.bless7309havebeeffect then
        buff:setAttribute("DODG", 0)
        owner.bless7309havebeeffect = false
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
  buff.update = override(buff.update, rogueBless7309update)
  return buff
end

return initBuff

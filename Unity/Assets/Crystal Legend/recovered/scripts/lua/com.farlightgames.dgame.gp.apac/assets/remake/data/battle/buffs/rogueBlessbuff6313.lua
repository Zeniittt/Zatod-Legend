local function rogueBless6313update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.rogueBless6313behprdmg = false
  if owner.attribs.HPR and owner.attribs.HPR < 0 then
    owner.rogueBless6313behprdmg = true
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(6313) then
      local bless6313 = ed.engine.rogueSkillMgr.rogueBlessList[6313]
      local HAST = bless6313.isReinforced and bless6313.info["Script Arg5"] or bless6313.info["Script Arg1"]
      if owner.rogueBless6313behprdmg and not owner.bless6313havebeeffect then
        buff:setAttribute("HAST", HAST)
        buff:setAttribute("MSPD", HAST)
        owner.bless6313havebeeffect = true
        owner:rebuild()
      elseif not owner.rogueBless6313behprdmg and owner.bless6313havebeeffect then
        buff:setAttribute("HAST", 0)
        buff:setAttribute("MSPD", 0)
        owner.bless6313havebeeffect = false
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
  buff.update = override(buff.update, rogueBless6313update)
  return buff
end

return initBuff

local function rogueBless6309update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.rogueBless6309behprdmg = false
  if owner.attribs.HPR and owner.attribs.HPR < 0 then
    owner.rogueBless6309behprdmg = true
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(6309) then
      local bless6309 = ed.engine.rogueSkillMgr.rogueBlessList[6309]
      local MR = 0
      if 0 < owner.attribs.MR then
        MR = owner.attribs.MR * (bless6309.isReinforced and bless6309.info["Script Arg5"] or bless6309.info["Script Arg1"]) / 100
      end
      if owner.rogueBless6309behprdmg and not owner.bless6309havebeeffect then
        buff:setAttribute("MR", MR)
        owner.bless6309havebeeffect = true
        owner:rebuild()
      elseif not owner.rogueBless6309behprdmg and owner.bless6309havebeeffect then
        buff:setAttribute("MR", 0)
        owner.bless6309havebeeffect = false
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
  buff.update = override(buff.update, rogueBless6309update)
  return buff
end

return initBuff

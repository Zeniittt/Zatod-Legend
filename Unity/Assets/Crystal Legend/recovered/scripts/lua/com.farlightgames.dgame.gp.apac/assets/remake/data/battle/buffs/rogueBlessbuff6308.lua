local function rogueBless6308update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.rogueBless6308behprdmg = false
  if owner.attribs.HPR and owner.attribs.HPR < 0 then
    owner.rogueBless6308behprdmg = true
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(6308) then
      local bless6308 = ed.engine.rogueSkillMgr.rogueBlessList[6308]
      local ARM = 0
      if 0 < owner.attribs.ARM then
        ARM = owner.attribs.ARM * (bless6308.isReinforced and bless6308.info["Script Arg5"] or bless6308.info["Script Arg1"]) / 100
      end
      if owner.rogueBless6308behprdmg and not owner.bless6308havebeeffect then
        buff:setAttribute("ARM", ARM)
        owner.bless6308havebeeffect = true
        owner:rebuild()
      elseif not owner.rogueBless6308behprdmg and owner.bless6308havebeeffect then
        buff:setAttribute("ARM", 0)
        owner.bless6308havebeeffect = false
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
  buff.update = override(buff.update, rogueBless6308update)
  return buff
end

return initBuff

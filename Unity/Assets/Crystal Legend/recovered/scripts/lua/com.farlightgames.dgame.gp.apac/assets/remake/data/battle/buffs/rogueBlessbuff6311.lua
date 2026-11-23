local function rogueBless6311update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.rogueBless6311behprdmg = false
  if owner.attribs.HPR and owner.attribs.HPR < 0 then
    owner.rogueBless6311behprdmg = true
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(6311) then
      local bless6311 = ed.engine.rogueSkillMgr.rogueBlessList[6311]
      local AD = 0
      if 0 < owner.attribs.AD then
        AD = owner.attribs.AD * (bless6311.isReinforced and bless6311.info["Script Arg5"] or bless6311.info["Script Arg1"]) / 100
      end
      if owner.rogueBless6311behprdmg and not owner.bless6311havebeeffect then
        buff:setAttribute("AD", AD)
        owner.bless6311havebeeffect = true
        owner:rebuild()
      elseif not owner.rogueBless6311behprdmg and owner.bless6311havebeeffect then
        buff:setAttribute("AD", 0)
        owner.bless6311havebeeffect = false
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
  buff.update = override(buff.update, rogueBless6311update)
  return buff
end

return initBuff

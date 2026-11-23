local function rogueBless6312update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.rogueBless6312behprdmg = false
  if owner.attribs.HPR and owner.attribs.HPR < 0 then
    owner.rogueBless6312behprdmg = true
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(6312) then
      local bless6312 = ed.engine.rogueSkillMgr.rogueBlessList[6312]
      local AP = 0
      if 0 < owner.attribs.AP then
        AP = owner.attribs.AP * (bless6312.isReinforced and bless6312.info["Script Arg5"] or bless6312.info["Script Arg1"]) / 100
      end
      if owner.rogueBless6312behprdmg and not owner.bless6312havebeeffect then
        buff:setAttribute("AP", AP)
        owner.bless6312havebeeffect = true
        owner:rebuild()
      elseif not owner.rogueBless6312behprdmg and owner.bless6312havebeeffect then
        buff:setAttribute("AP", 0)
        owner.bless6312havebeeffect = false
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
  buff.update = override(buff.update, rogueBless6312update)
  return buff
end

return initBuff

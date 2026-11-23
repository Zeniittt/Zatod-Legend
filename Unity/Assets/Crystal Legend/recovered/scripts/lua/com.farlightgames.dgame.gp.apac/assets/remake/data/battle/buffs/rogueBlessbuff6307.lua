local function rogueBless6307update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.rogueBless6307behprdmg = false
  if owner.attribs.HPR and owner.attribs.HPR < 0 then
    owner.rogueBless6307behprdmg = true
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(6307) then
      local bless6307 = ed.engine.rogueSkillMgr.rogueBlessList[6307]
      local HealRatio = bless6307.isReinforced and bless6307.info["Script Arg5"] or bless6307.info["Script Arg1"]
      if owner.rogueBless6307behprdmg and not owner.bless6307havebeeffect then
        buff:setAttribute("HealRatio", HealRatio)
        owner.bless6307havebeeffect = true
        owner:rebuild()
      elseif not owner.rogueBless6307behprdmg and owner.bless6307havebeeffect then
        buff:setAttribute("HealRatio", 0)
        owner.bless6307havebeeffect = false
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
  buff.update = override(buff.update, rogueBless6307update)
  return buff
end

return initBuff

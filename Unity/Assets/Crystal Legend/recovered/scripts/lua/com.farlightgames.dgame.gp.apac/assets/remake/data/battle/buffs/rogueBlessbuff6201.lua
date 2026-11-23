local function rogueBless6201update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  owner.rogueBless6201behprdmg = false
  if owner.attribs.HPR and owner.attribs.HPR < 0 then
    owner.rogueBless6201behprdmg = true
  end
  if owner.rogueBless6201behprdmg then
    owner.belss6201gettimer = owner.belss6201gettimer + dt
  else
    owner.belss6201losttimer = owner.belss6201losttimer + dt
  end
  if owner.belss6201gettimer >= owner.belss6201gettime then
    owner.belss6201gettimer = 0
    owner.bless6201count = math.min(owner.bless6201maxcount, owner.bless6201count + 1)
  end
  if owner.belss6201losttimer >= owner.belss6201losttime then
    owner.belss6201losttimer = 0
    owner.bless6201count = math.max(0, owner.bless6201count - 1)
  end
  if owner.bless6201count ~= owner.bless6201lastcount then
    owner.bless6201lastcount = owner.bless6201count
    buff:setAttribute("DOTRES", owner.bless6201effectnum * owner.bless6201count)
    owner:rebuild()
  end
  if ed.run_with_scene and owner.actor then
    if owner.bless6201count == 1 and not owner.bless6201effect_id then
      owner.bless6201effect_id = owner.actor:addEffect("eff_buff_rogue6201.cha", 1)
    end
    if owner.bless6201count == 0 and owner.bless6201effect_id then
      owner.actor.puppet:removeEffectWithID(owner.bless6201effect_id)
      owner.bless6201effect_id = nil
    end
  end
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  owner.bless6201count = 0
  owner.bless6201lastcount = 0
  owner.belss6201losttimer = 0
  owner.belss6201gettimer = 0
  owner.bless6201effect_id = nil
  if ed.engine.rogueSkillMgr:getBless(6201) then
    local bless6201 = ed.engine.rogueSkillMgr.rogueBlessList[6201]
    owner.bless6201maxcount = bless6201.isReinforced and bless6201.info["Script Arg8"] or bless6201.info["Script Arg4"]
    owner.bless6201effectnum = bless6201.isReinforced and bless6201.info["Script Arg7"] or bless6201.info["Script Arg3"]
    owner.belss6201losttime = bless6201.isReinforced and bless6201.info["Script Arg6"] or bless6201.info["Script Arg2"]
    owner.belss6201gettime = bless6201.isReinforced and bless6201.info["Script Arg5"] or bless6201.info["Script Arg1"]
    if ed.engine.rogueSkillMgr:getBless(6204) then
      local bless6204 = ed.engine.rogueSkillMgr.rogueBlessList[6204]
      owner.belss6201losttime = bless6204.isReinforced and bless6204.info["Script Arg5"] or bless6204.info["Script Arg1"]
    end
    if ed.engine.rogueSkillMgr:getBless(6205) then
      local bless6205 = ed.engine.rogueSkillMgr.rogueBlessList[6205]
      owner.belss6201gettime = bless6205.isReinforced and bless6205.info["Script Arg5"] or bless6205.info["Script Arg1"]
    end
  end
  buff.update = override(buff.update, rogueBless6201update)
  return buff
end

return initBuff

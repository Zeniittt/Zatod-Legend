local function rogueBless3201update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if owner.rogueBless3201lastCount ~= owner.rogueBless3201count then
    owner.rogueBless3201lastCount = owner.rogueBless3201count
    local bless3201 = ed.engine.rogueSkillMgr.rogueBlessList[3201]
    buff.rogueBless3201attarg = (bless3201.isReinforced and bless3201.info["Script Arg6"] or bless3201.info["Script Arg2"]) / 100
    buff:setAttribute("ARM", buff.rogueBless3201attarg * owner.rogueBless3201count * owner.bless3201oriarm)
    buff:setAttribute("MR", buff.rogueBless3201attarg * owner.rogueBless3201count * owner.bless3201orimr)
    buff.rogueBless3201hparg = (bless3201.isReinforced and bless3201.info["Script Arg8"] or bless3201.info["Script Arg4"]) / 100
    buff:setAttribute("HP", buff.rogueBless3201hparg * owner.rogueBless3201count * owner.bless3201orihp)
    buff.info["Actor Scale"] = {
      1 + 0.05 * owner.rogueBless3201count,
      1 + 0.05 * owner.rogueBless3201count
    }
    buff:onAddedClient(false)
    if ed.engine.rogueSkillMgr:getBless(3205) then
      local bless3205 = ed.engine.rogueSkillMgr.rogueBlessList[3205]
      buff.rogueBless3205adarg = (bless3205.isReinforced and bless3205.info["Script Arg5"] or bless3205.info["Script Arg1"]) / 100
      buff.rogueBless3205aparg = (bless3205.isReinforced and bless3205.info["Script Arg6"] or bless3205.info["Script Arg2"]) / 100
      buff:setAttribute("AD", buff.rogueBless3205adarg * owner.rogueBless3201count * owner.bless3205oriad)
      buff:setAttribute("AP", buff.rogueBless3205aparg * owner.rogueBless3201count * owner.bless3205oriap)
    end
    if ed.engine.rogueSkillMgr:getBless(3401) then
      local bless3401 = ed.engine.rogueSkillMgr.rogueBlessList[3401]
      buff.rogueBless3401arg = bless3401.info["Script Arg1"]
      buff:setAttribute("PIMU", buff.rogueBless3401arg * owner.rogueBless3201count)
    end
    if ed.engine.rogueSkillMgr:getBless(3402) then
      local bless3402 = ed.engine.rogueSkillMgr.rogueBlessList[3402]
      buff.rogueBless3402arg = bless3402.info["Script Arg1"]
      buff:setAttribute("MIMU", buff.rogueBless3402arg * owner.rogueBless3201count)
    end
    if ed.engine.rogueSkillMgr:getBless(3403) then
      local bless3403 = ed.engine.rogueSkillMgr.rogueBlessList[3403]
      buff.rogueBless3403arg = bless3403.info["Script Arg1"]
      buff:setAttribute("DOTRES", buff.rogueBless3403arg * owner.rogueBless3201count)
    end
    owner:rebuild()
  end
  if ed.run_with_scene and owner.actor then
    if owner.rogueBless3201count > 0 and owner.rogueBless3201count < owner.rogueBless3201maxCount and not owner.rogueBless3201effect1 then
      owner.actor:addEffect("eff_buff_rogue3201_1.cha", -1)
      owner.rogueBless3201effect1 = true
    elseif owner.rogueBless3201count == owner.rogueBless3201maxCount and not owner.rogueBless3201effect2 then
      owner.actor:addEffect("eff_buff_rogue3201_2.cha", 1)
      owner.rogueBless3201effect2 = true
    end
  end
end

local function rogueBless3201onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  local owner = buff.owner
  if 0 < damage and not transferred and source.camp ~= owner.camp and field and field == "hp" then
    owner.rogueBless3201count = math.min(owner.rogueBless3201maxCount, owner.rogueBless3201count + 1)
    if ed.engine.rogueSkillMgr:getBless(3404) then
      local bless3404 = ed.engine.rogueSkillMgr.rogueBlessList[3404]
      buff.rogueBless3404arg = bless3404.info["Script Arg1"]
      damage = damage - buff.rogueBless3404arg * owner.rogueBless3201count
      if damage <= 1 then
        damage = 1
      end
    end
    if ed.engine.rogueSkillMgr:getBless(3203) then
      local bless3203 = ed.engine.rogueSkillMgr.rogueBlessList[3203]
      buff.rogueBless3203dmg = (bless3203.isReinforced and bless3203.info["Script Arg5"] or bless3203.info["Script Arg1"]) / 100 * owner.rogueBless3201count * owner.attribs.HP
      if source and source.camp ~= owner.camp then
        source:takeDamage(buff.rogueBless3203dmg, "Holy", "hp", owner, 1, 1, true)
      end
    end
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  owner.bless3201effect = nil
  owner.bless3201effectlast = nil
  owner.bless3201effectFirstTime = nil
  owner.bless3201preEffectID = nil
  owner.bless3201oriarm = owner.attribs.ARM
  owner.bless3201orimr = owner.attribs.MR
  owner.bless3201orihp = owner.attribs.HP
  owner.bless3205oriad = owner.attribs.AD
  owner.bless3205oriap = owner.attribs.AP
  owner.rogueBless3201count = 0
  owner.rogueBless3201lastCount = 0
  local bless3201 = ed.engine.rogueSkillMgr.rogueBlessList[3201]
  owner.rogueBless3201maxCount = bless3201.isReinforced and bless3201.info["Script Arg7"] or bless3201.info["Script Arg3"]
  if ed.engine.rogueSkillMgr:getBless(3204) then
    local bless3204 = ed.engine.rogueSkillMgr.rogueBlessList[3204]
    owner.rogueBless3201maxCount = bless3204.isReinforced and bless3204.info["Script Arg5"] or bless3204.info["Script Arg1"]
  end
  buff.onDamaged = override(buff.onDamaged, rogueBless3201onDamaged)
  buff.update = override(buff.update, rogueBless3201update)
  return buff
end

return initBuff

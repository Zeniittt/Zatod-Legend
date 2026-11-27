local control_effects = {
  stun = true,
  frozen = true,
  icefrozen = true,
  immoblilize = true,
  silence = true,
  disarm = true,
  doom = true,
  imprisonment = true,
  enchanted = true,
  fear = true,
  taunt = true,
  detaunt = true,
  polymorph = true
}

local function isCrlEftConflictWithControl(self)
  local isRet = false
  local info = self.info
  for i, effect in ipairs(info["Control Effects"]) do
    if control_effects[effect] then
      isRet = true
      break
    end
  end
  return isRet
end

local function rogueBless5201update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  owner.becontrol = false
  for i, tbuff in ipairs(owner.buff_list) do
    if isCrlEftConflictWithControl(tbuff) then
      owner.becontrol = true
      break
    end
  end
  if owner.becontrol then
    owner.bless5201time = owner.bless5201time + dt
  end
  if buff.bless5201fristtime then
    buff.bless5201fristtime = false
    if ed.run_with_scene then
      local effect_name = "eff_UI_rogue5201.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, {400, 170}, {1, 1}, nil, 1)
      end
    end
  end
  local timer = buff.attack_timer - dt
  while timer <= 0 do
    timer = timer + 1
    if ed.engine.rogueSkillMgr:getBless(5404) then
      local bless5404 = ed.engine.rogueSkillMgr.rogueBlessList[5404]
      local CRITRES = bless5404.info["Script Arg1"]
      local MCRITRES = bless5404.info["Script Arg2"]
      if owner.becontrol and not owner.bless5204havebeeffect then
        buff:setAttribute("CRITRES", CRITRES)
        buff:setAttribute("MCRITRES", MCRITRES)
        owner.bless5204havebeeffect = true
        owner:rebuild()
      elseif not owner.becontrol and owner.bless5204havebeeffect then
        buff:setAttribute("CRITRES", 0)
        buff:setAttribute("MCRITRES", 0)
        owner.bless5204havebeeffect = false
        owner:rebuild()
      end
    end
  end
  buff.attack_timer = timer
  if owner.bless5201time >= owner.bless5201maxtime then
    owner.bless5201time = 0
    local magiccaster = ed.engine.rogueSkillMgr.magicCaster
    local bless5201 = ed.engine.rogueSkillMgr.rogueBlessList[5201]
    local bless5201ratio = (bless5201.isReinforced and bless5201.info["Script Arg6"] or bless5201.info["Script Arg2"]) / 100
    local bless5201damageinfo = {}
    if ed.engine.rogueSkillMgr:getBless(5403) then
      bless5201damageinfo["Ignore Shield"] = true
    end
    local maxBles5201Damage = bless5201.isReinforced and bless5201.info["Script Arg7"] or bless5201.info["Script Arg3"]
    local damage5201 = math.min(owner.attribs.HP * bless5201ratio, maxBles5201Damage)
    owner:takeDamage(damage5201, "AD", "hp", magiccaster, 1, 1, true, bless5201damageinfo)
    if ed.engine.rogueSkillMgr:getBless(5202) then
      local bless5202 = ed.engine.rogueSkillMgr.rogueBlessList[5202]
      local bless5202bid = 60005202
      local bless5202binfo = ed.lookupDataTable("Buff", nil, bless5202bid)
      local bless5202buff = ed.BuffCreate(bless5202binfo, owner, magiccaster)
      bless5202buff.timer = bless5202.isReinforced and bless5202.info["Script Arg6"] or bless5202.info["Script Arg2"]
      owner:addBuff(bless5202buff, magiccaster)
    end
    if ed.engine.rogueSkillMgr:getBless(5204) then
      local bless5204 = ed.engine.rogueSkillMgr.rogueBlessList[5204]
      local bless5204ratio = (bless5204.isReinforced and bless5204.info["Script Arg5"] or bless5204.info["Script Arg1"]) / 100
      local maxBles5204Damage = bless5204.isReinforced and bless5204.info["Script Arg6"] or bless5204.info["Script Arg2"]
      local damage5204 = math.min(owner.attribs.HP * bless5204ratio, maxBles5204Damage)
      owner:takeDamage(damage5204, "AP", "hp", magiccaster, 1, 1, true)
    end
    if ed.engine.rogueSkillMgr:getBless(5205) then
      local bless5205 = ed.engine.rogueSkillMgr.rogueBlessList[5205]
      local p = (bless5205.isReinforced and bless5205.info["Script Arg5"] or bless5205.info["Script Arg1"]) / 100
      if p >= ed.rand() and not owner.buff_effects.uncontrollable and not owner.buff_effects.invulnerable then
        local bless5205bid = 60005205
        local bless5205binfo = ed.lookupDataTable("Buff", nil, bless5205bid)
        local bless5205buff = ed.BuffCreate(bless5205binfo, owner, magiccaster)
        bless5205buff.timer = bless5205.isReinforced and bless5205.info["Script Arg6"] or bless5205.info["Script Arg2"]
        owner:addBuff(bless5205buff, magiccaster)
      end
    end
    if ed.run_with_scene then
      local effect_name = "eff_impact_rogue5201.cha"
      if effect_name then
        ed.scene:playEffectOnScene(effect_name, owner.position, {
          owner.direction,
          1
        }, nil, 1)
      end
    end
  end
end

local function rogueBless5201onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  local owner = buff.owner
  if 0 < damage and owner.becontrol and damage_type == "AD" and ed.engine.rogueSkillMgr:getBless(5401) then
    local bless5401 = ed.engine.rogueSkillMgr.rogueBlessList[5401]
    damage = damage * (1 + bless5401.info["Script Arg1"] / 100)
  end
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  owner.bless5201time = 0
  if ed.engine.rogueSkillMgr:getBless(5201) then
    local bless5201 = ed.engine.rogueSkillMgr.rogueBlessList[5201]
    owner.bless5201maxtime = bless5201.isReinforced and bless5201.info["Script Arg5"] or bless5201.info["Script Arg1"]
    if ed.engine.rogueSkillMgr:getBless(5203) then
      local bless5203 = ed.engine.rogueSkillMgr.rogueBlessList[5203]
      owner.bless5201maxtime = owner.bless5201maxtime - (bless5203.isReinforced and bless5203.info["Script Arg5"] or bless5203.info["Script Arg1"])
    end
  end
  buff.attack_timer = 1
  buff.bless5201fristtime = true
  buff.update = override(buff.update, rogueBless5201update)
  buff.onDamaged = override(buff.onDamaged, rogueBless5201onDamaged)
  return buff
end

return initBuff

local function rogueBless1201onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  
  local owner = buff.owner
  local sourceishero = false
  local damageisAD = false
  if source and source ~= owner then
    if not ed.engine.rogueSkillMgr:getBless(1202) then
      if source.config.is_summoned then
        return damage
      else
        sourceishero = true
      end
    elseif source.config.is_summoned then
      local bless1202 = ed.engine.rogueSkillMgr.rogueBlessList[1202]
      local p = (bless1202.isReinforced and bless1202.info["Script Arg5"] or bless1202.info["Script Arg1"]) / 100
      if p >= ed.rand() then
        sourceishero = true
      else
        return damage
      end
    else
      sourceishero = true
    end
    if damage_type == "AD" then
      damageisAD = true
    elseif ed.engine.rogueSkillMgr:getBless(1401) then
      if damage_type == "AP" then
        damageisAD = true
      else
        return damage
      end
    else
      return damage
    end
  end
  if ed.engine.rogueSkillMgr:getBless(1201) then
    local bless1201 = ed.engine.rogueSkillMgr.rogueBlessList[1201]
    if 0 < damage and sourceishero and damageisAD and (not damageinfo or damageinfo.Bless1201 ~= true) and not transferred then
      if ed.engine.rogueSkillMgr:getBless(1205) then
        local bless1205 = ed.engine.rogueSkillMgr.rogueBlessList[1205]
        local p = (bless1205.isReinforced and bless1205.info["Script Arg5"] or bless1205.info["Script Arg1"]) / 100
        if p >= ed.rand() then
          buff.rogueBless1201Count = buff.rogueBless1201Count + (bless1205.isReinforced and bless1205.info["Script Arg6"] or bless1205.info["Script Arg2"])
        else
          buff.rogueBless1201Count = buff.rogueBless1201Count + (bless1201.isReinforced and bless1201.info["Script Arg5"] or bless1201.info["Script Arg1"])
        end
      else
        buff.rogueBless1201Count = buff.rogueBless1201Count + (bless1201.isReinforced and bless1201.info["Script Arg5"] or bless1201.info["Script Arg1"])
      end
      if ed.run_with_scene and owner.actor then
        if not owner.bless1201effect then
          owner.bless1201effectlast = 1
          owner.bless1201effectFirstTime = true
        end
        owner.bless1201effect = buff.rogueBless1201Count
        if owner.bless1201effect >= buff.rogueBless1201maxCount then
          owner.bless1201effect = 11
        end
        if owner.bless1201effectFirstTime or owner.bless1201effect ~= owner.bless1201effectlast then
          local effect_name = buff.bless1201EffectList[owner.bless1201effect]
          local effect_id = owner.actor:addEffect(effect_name, 1)
          local actor = owner.actor
          local direction = owner.direction
          local effect = actor:getEffectById(effect_id)
          if effect then
            local scaleX = effect:getScaleX()
            effect:setScaleX(direction)
          end
          if owner.bless1201preEffectID then
            owner.actor.puppet:removeEffectWithID(owner.bless1201preEffectID)
          end
          owner.bless1201preEffectID = effect_id
          owner.bless1201effectFirstTime = false
          owner.bless1201effectlast = owner.bless1201effect
        end
      end
    end
    if buff.rogueBless1201Count >= buff.rogueBless1201maxCount then
      buff.rogueBless1201Count = 0
      owner.bless1201effect = nil
      local bless1201damageratio = (bless1201.isReinforced and bless1201.info["Script Arg7"] or bless1201.info["Script Arg3"]) / 100
      local maxBless1201Damage = bless1201.isReinforced and bless1201.info["Script Arg8"] or bless1201.info["Script Arg4"]
      local damage1201 = math.min(owner.attribs.HP * bless1201damageratio, maxBless1201Damage)
      local bless1201damageinfo = {}
      bless1201damageinfo.Bless1201 = true
      if ed.engine.rogueSkillMgr:getBless(1404) then
        bless1201damageinfo.MUSTCRIT = true
      end
      owner:takeDamage(damage1201, "AD", "hp", source, 1, 1, true, bless1201damageinfo)
      if ed.run_with_scene then
        local effect_name = "eff_impact_LYC_atk.cha"
        ed.scene:playEffectOnScene(effect_name, owner.position, {
          owner.direction,
          1
        }, nil, 1)
      end
      if ed.engine.rogueSkillMgr:getBless(1203) then
        local bless1203 = ed.engine.rogueSkillMgr.rogueBlessList[1203]
        local list = {}
        local arg1 = 100
        if bless1203.isReinforced then
          arg1 = 125
        end
        for unit in ed.engine:foreachAliveUnit(-1) do
          if unit == buff.owner then
          else
            local p = ed.edpSub(unit.position, owner.position)
            if p[1] * p[1] + p[2] * p[2] <= arg1 * arg1 then
              table.insert(list, unit)
            end
          end
        end
        for k, unit in ipairs(list) do
          local bless1203ratio = (bless1203.isReinforced and bless1203.info["Script Arg5"] or bless1203.info["Script Arg1"]) / 100
          unit:takeDamage(damage1201 * bless1203ratio, "AD", "hp", source, 1, 1, true)
        end
      end
      if ed.engine.rogueSkillMgr:getBless(1402) then
        local Bless1402_PowerRatio = ed.engine.rogueSkillMgr.rogueBlessList[1402].info["Script Arg1"]
        owner:takeDamage(source.attribs.HP * Bless1402_PowerRatio / 100, "AD", "hp", source, 1, 1, true)
      end
      if ed.engine.rogueSkillMgr:getBless(1403) and 0 >= buff.bless1403timer then
        local Bless1403_CD = ed.engine.rogueSkillMgr.rogueBlessList[1403].info["Script Arg2"]
        buff.bless1403timer = Bless1403_CD
        if not owner.buff_effects.uncontrollable and not owner.buff_effects.invulnerable then
          local bless1403bid = 60001403
          local bless1403binfo = ed.lookupDataTable("Buff", nil, bless1403bid)
          local bless1403buff = ed.BuffCreate(bless1403binfo, owner, source)
          bless1403buff.timer = ed.engine.rogueSkillMgr.rogueBlessList[1403].info["Script Arg1"]
          owner:addBuff(bless1403buff, source)
        end
      end
    end
  end
  return damage
end

local function rogueBless1201update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  buff.dt = buff.dt and buff.dt + dt or dt
  if buff.dt == dt then
    local bless1201 = ed.engine.rogueSkillMgr.rogueBlessList[1201]
    buff.rogueBless1201maxCount = bless1201.isReinforced and bless1201.info["Script Arg6"] or bless1201.info["Script Arg2"]
    if ed.engine.rogueSkillMgr:getBless(1204) then
      local bless1204 = ed.engine.rogueSkillMgr.rogueBlessList[1204]
      buff.rogueBless1201maxCount = bless1204.isReinforced and bless1204.info["Script Arg5"] or bless1204.info["Script Arg1"]
    end
  end
  if ed.run_with_scene and owner.actor then
    local actor = owner.actor
    if actor and owner.bless1201preEffectID then
      local direction = owner.direction
      local effect = actor:getEffectById(owner.bless1201preEffectID)
      if effect then
        local scaleX = effect:getScaleX()
        effect:setScaleX(direction)
      end
    end
  end
  buff.bless1403timer = buff.bless1403timer - dt
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  buff.bless1201EffectList = {
    "eff_buff_rogue1201_1.cha",
    "eff_buff_rogue1201_2.cha",
    "eff_buff_rogue1201_3.cha",
    "eff_buff_rogue1201_4.cha",
    "eff_buff_rogue1201_5.cha",
    "eff_buff_rogue1201_6.cha",
    "eff_buff_rogue1201_7.cha",
    "eff_buff_rogue1201_8.cha",
    "eff_buff_rogue1201_9.cha",
    "eff_buff_rogue1201_10.cha",
    "eff_tile_TS_atk2.cha"
  }
  for i, name in pairs(buff.bless1201EffectList) do
    caster:preloadEffect(name)
  end
  owner.bless1201effect = nil
  owner.bless1201effectlast = nil
  owner.bless1201effectFirstTime = nil
  owner.bless1201preEffectID = nil
  buff.bless1403timer = 0
  buff.rogueBless1201Count = 0
  buff.rogueBless1201maxCount = 10
  buff.update = override(buff.update, rogueBless1201update)
  buff.onDamaged = override(buff.onDamaged, rogueBless1201onDamaged)
  return buff
end

return initBuff

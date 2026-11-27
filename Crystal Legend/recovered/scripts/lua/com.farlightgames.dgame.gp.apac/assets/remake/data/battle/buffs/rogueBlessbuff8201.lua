local function rogueBless8201update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if ed.run_with_scene and owner.actor then
    if owner.rogueBless8201count ~= owner.rogueBless8201lastcount then
      owner.rogueBless8201lastcount = owner.rogueBless8201count
      owner.bless8201effect = owner.rogueBless8201count + 1
      local effect_name = buff.bless8201EffectList[owner.bless8201effect]
      local effect_id = owner.actor:addEffect(effect_name, 1)
      local actor = owner.actor
      local direction = owner.direction
      local effect = actor:getEffectById(effect_id)
      if effect then
        local scaleX = effect:getScaleX()
        effect:setScaleX(direction)
      end
      if owner.bless8201preEffectID then
        owner.actor.puppet:removeEffectWithID(owner.bless8201preEffectID)
      end
      owner.bless8201preEffectID = effect_id
    end
    local actor = owner.actor
    if actor and owner.bless8201preEffectID then
      local direction = owner.direction
      local effect = actor:getEffectById(owner.bless8201preEffectID)
      if effect then
        local scaleX = effect:getScaleX()
        effect:setScaleX(direction)
      end
    end
  end
end

local function rogueBless8201onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local info = buff.info
  local owner = buff.owner
  return damage
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  owner.rogueBless8201count = 0
  owner.rogueBless8201lastcount = 0
  owner.rogueBless8201maxcount = 0
  owner.belss8201Triggered = false
  if ed.engine.rogueSkillMgr:getBless(8201) then
    local bless8201 = ed.engine.rogueSkillMgr.rogueBlessList[8201]
    owner.rogueBless8201maxcount = bless8201.isReinforced and bless8201.info["Script Arg5"] or bless8201.info["Script Arg1"]
  end
  if ed.engine.rogueSkillMgr:getBless(8204) then
    local bless8204 = ed.engine.rogueSkillMgr.rogueBlessList[8204]
    owner.rogueBless8201count = bless8204.isReinforced and bless8204.info["Script Arg5"] or bless8204.info["Script Arg1"]
  end
  owner.bless8201effect = nil
  owner.bless8201effectlast = nil
  owner.bless8201effectFirstTime = nil
  owner.bless8201preEffectID = nil
  buff.bless8201EffectList = {
    "eff_tile_TS_atk2.cha",
    "eff_buff_rogue8201_1.cha",
    "eff_buff_rogue8201_2.cha",
    "eff_buff_rogue8201_3.cha",
    "eff_buff_rogue8201_4.cha",
    "eff_buff_rogue8201_5.cha",
    "eff_buff_rogue8201_6.cha",
    "eff_buff_rogue8201_7.cha"
  }
  for i, name in pairs(buff.bless8201EffectList) do
    caster:preloadEffect(name)
  end
  buff.onDamaged = override(buff.onDamaged, rogueBless8201onDamaged)
  buff.update = override(buff.update, rogueBless8201update)
  return buff
end

return initBuff

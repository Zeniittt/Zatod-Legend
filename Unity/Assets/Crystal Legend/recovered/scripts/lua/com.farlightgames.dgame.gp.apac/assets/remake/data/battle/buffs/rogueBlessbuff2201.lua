local function rogueBless2201update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if ed.run_with_scene and owner.actor then
    local actor = owner.actor
    if actor and owner.bless2201preEffectID then
      local direction = owner.direction
      local effect = actor:getEffectById(owner.bless2201preEffectID)
      if effect then
        local scaleX = effect:getScaleX()
        effect:setScaleX(direction)
      end
    end
  end
end

local function initBuff(buff)
  local caster = buff.caster
  local owner = buff.owner
  owner.last_current_skill = nil
  owner.rogueBless2201count = 0
  owner.bless2201effect = nil
  owner.bless2201effectlast = nil
  owner.bless2201effectFirstTime = nil
  owner.bless2201preEffectID = nil
  buff.bless2201EffectList = {
    "eff_buff_rogue2201_1.cha",
    "eff_buff_rogue2201_2.cha",
    "eff_buff_rogue2201_3.cha",
    "eff_buff_rogue2201_4.cha",
    "eff_buff_rogue2201_5.cha",
    "eff_buff_rogue2201_6.cha",
    "eff_buff_rogue2201_7.cha",
    "eff_buff_rogue2201_8.cha",
    "eff_buff_rogue2201_9.cha",
    "eff_buff_rogue2201_10.cha"
  }
  for i, name in pairs(buff.bless2201EffectList) do
    caster:preloadEffect(name)
  end
  if ed.engine.rogueSkillMgr:getBless(2201) then
    local bless2201 = ed.engine.rogueSkillMgr.rogueBlessList[2201]
    owner.rogueBless2201maxcount = bless2201.isReinforced and bless2201.info["Script Arg7"] or bless2201.info["Script Arg3"]
  end
  buff.update = override(buff.update, rogueBless2201update)
  return buff
end

return initBuff

module("ed.battlehero", package.seeall)
local ed = ed
RogueTitanFG = {}
RogueTitanFG.TitanFG_atk4Bid = 12001504

function RogueTitanFG.hero_getLostHPAfterImmunity(basefunc, hero, damage, immunity, damage_type, source, field)
  local lost = basefunc(hero, damage, immunity, damage_type, source, field)
  local dt = damage_type
  local s = source
  if lost and (dt == "AD" or dt == "AP") and 0 < lost and s and s:isAlive() and s.info["Unit Type"] ~= "Pet" then
    local skillatk4 = hero.skills.RogueTitanFG_atk4
    if skillatk4 then
      local SeedRatio = skillatk4.info["Script Arg2"] / 100
      SeedRatio = math.min(SeedRatio, 0.2)
      local SeedRandom = ed.rand()
      local bid = RogueTitanFG.TitanFG_atk4Bid
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, s, hero)
      if SeedRatio > SeedRandom then
        if ed.run_with_scene then
          local effect_name = "eff_impact_TitanFG_atk4_self.cha"
          if effect_name then
            ed.scene:playEffectOnScene(effect_name, hero.position, {
              hero.direction * 1,
              1
            }, nil, 1)
          end
        end
        lost = lost * 0
      end
    end
  end
  return lost
end

function RogueTitanFG.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local skillult = caster.skills.RogueTitanFG_ult
  if skillult then
    caster.ult_buffTime = 0
    caster.HPShield = 0
    caster.hasultBuff = true
    local bid = 12001501
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local ultbuff = ed.BuffCreate(binfo, caster, caster)
    ultbuff.update = override(ultbuff.update, RogueTitanFG.skillult_buffUpdate)
    ultbuff.onRemoved = override(ultbuff.onRemoved, RogueTitanFG.skillult_buffonRemoved)
    caster:addBuff(ultbuff, caster)
  end
end

function RogueTitanFG.skillult_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local skillult = caster.skills.RogueTitanFG_ult
  if caster and skillult then
    caster.ult_buffTime = caster.ult_buffTime + dt
    if caster.ult_buffTime and caster.ult_buffTime % 2 == 0 then
      skillult:takeEffectAt(caster.position, caster)
    end
  end
end

function RogueTitanFG.skillult_buffonRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  caster.hasultBuff = false
end

function RogueTitanFG.skillult_power(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  return power, coeff
end

function RogueTitanFG.collectHpChange(basefunc, self, config)
  local caster = self
  local skillult = caster.skills.RogueTitanFG_ult
  local unit = config.unit
  if caster.hasultBuff and skillult then
    local HPRation = skillult.info["Script Arg3"] / 100
    HPRation = math.min(HPRation, 0.5)
    if unit.camp ~= caster.camp and config.hp_change < 0 then
      caster.HPShield = -config.hp_change * HPRation + caster.HPShield
    end
    if caster.HPShield and 0 < caster.HPShield then
      local havebuff = false
      local shieldbuff
      for i, tbuff in ipairs(caster.buff_list) do
        if tbuff.info.ID == 598 then
          havebuff = true
          shieldbuff = tbuff
        end
      end
      local max = skillult.info["Script Arg4"] / 100
      max = math.min(max, 0.15)
      local ShieldMax = max * caster.attribs.HP
      if havebuff then
        shieldbuff.shield = shieldbuff.shield + caster.HPShield
        if ShieldMax < shieldbuff.shield then
          shieldbuff.shield = ShieldMax
        end
      else
        local bid = 598
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local shieldbuff = ed.BuffCreate(binfo, caster, caster)
        if shieldbuff then
          shieldbuff.shield = caster.HPShield
          if ShieldMax < shieldbuff.shield then
            shieldbuff.shield = ShieldMax
          end
        end
        caster:addBuff(shieldbuff, caster)
      end
    end
  end
end

function RogueTitanFG.init_hero(hero)
  local skillult = hero.skills.RogueTitanFG_ult
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, RogueTitanFG.hero_getLostHPAfterImmunity)
  hero.collectHPchange = override(hero.collectHPchange, RogueTitanFG.collectHpChange)
  if skillult then
    skillult.start = override(skillult.start, RogueTitanFG.skillult_start)
    skillult.power = override(skillult.power, RogueTitanFG.skillult_power)
  end
  return hero
end

return RogueTitanFG.init_hero

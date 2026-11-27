module("ed.battlehero", package.seeall)
local ed = ed
RogueTitanDracula = {}
RogueTitanDracula.TitanDracula_arcana2BidEnemy = 12001603
RogueTitanDracula.TitanDracula_arcana2Bid = 12001604
RogueTitanDracula.TitanDracula_arcana3Bid = 12001605
RogueTitanDracula.TitanDracula_arcana4Bid = 12001606

function RogueTitanDracula.skillatk2_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local PowerRatio = 1
  if target:isAlive() and caster:isAlive() then
    if target.hp / target.attribs.HP <= 0.25 then
      PowerRatio = 2
      power = power * PowerRatio
      return power * PowerRatio
    elseif target.hp / target.attribs.HP <= 0.5 then
      PowerRatio = 1.5
      power = power * PowerRatio
      return power * PowerRatio
    elseif target.hp / target.attribs.HP <= 0.75 then
      PowerRatio = 1.25
      power = power * PowerRatio
      return power * PowerRatio
    end
  end
  return power * PowerRatio
end

function RogueTitanDracula.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local PowerRatio = 1
  if target:isAlive() and caster:isAlive() then
    if target.hp / target.attribs.HP <= 0.25 then
      PowerRatio = 2
      power = power * PowerRatio
      return power * PowerRatio
    elseif target.hp / target.attribs.HP <= 0.5 then
      PowerRatio = 1.5
      power = power * PowerRatio
      return power * PowerRatio
    elseif target.hp / target.attribs.HP <= 0.75 then
      PowerRatio = 1.25
      power = power * PowerRatio
      return power * PowerRatio
    end
  end
  return power * PowerRatio
end

function RogueTitanDracula.skillatk4_power(basefunc, skill, source, target, damage_type)
  local power = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local PowerRatio = 1
  if target:isAlive() and caster:isAlive() then
    if target.hp / target.attribs.HP <= 0.25 then
      PowerRatio = 2
      power = power * PowerRatio
      return power * PowerRatio
    elseif target.hp / target.attribs.HP <= 0.5 then
      PowerRatio = 1.5
      power = power * PowerRatio
      return power * PowerRatio
    elseif target.hp / target.attribs.HP <= 0.75 then
      PowerRatio = 1.25
      power = power * PowerRatio
      return power * PowerRatio
    end
  end
  return power * PowerRatio
end

function RogueTitanDracula.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local originfo = skill.info
  local HPR_Ratio = skill.info["Script Arg2"] / 100
  skill.info = ed.wraptable(originfo, {
    ["No Dodge"] = true
  })
  local bid = RogueTitanDracula.TitanDracula_arcana3Bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff:setAttribute("HPR", caster.attribs.HP * HPR_Ratio)
  caster:addBuff(buff, caster)
  caster.arcana3buff = buff
  basefunc(skill, target)
end

function RogueTitanDracula.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  if caster and caster:isAlive() then
    local region_position = {
      caster.position[1],
      0
    }
    caster.ult_region_position = region_position
    local skillultsregion = caster.skills.TitanDracula_ults
    if skill.ults_region then
      skill.ults_region:terminate()
    end
    if skillultsregion then
      skillultsregion.target = caster
      local region = skillultsregion:createRegion()
      region.position = region_position
      skill.ults_region = region
      caster.ults_region = region
      ed.engine:addRegion(region)
    end
  end
  basefunc(skill)
end

function RogueTitanDracula.skillults_createRegion(basefunc, skill)
  local ultregion = basefunc(skill)
  ultregion.update = override(ultregion.update, RogueTitanDracula.ultregion_update)
  ultregion.terminate = override(ultregion.terminate, RogueTitanDracula.ultregion_terminate)
  return ultregion
end

function RogueTitanDracula.ultregion_update(basefunc, region, dt)
  basefunc(region, dt)
  local caster = region.caster
  local skillult = caster.skills.TitanDracula_ult
  if not caster.ult_hitTime then
    caster.ult_hitTime = 0
  end
  caster.ult_hitTime = dt + caster.ult_hitTime
  if caster.ult_hitTime and caster.ult_hitTime == 1.5 then
    caster.ult_hitTime = 0
    skillult:takeEffectAt(caster.position, caster)
  end
  if caster.ults_region then
    region.position = caster.position
  end
end

function RogueTitanDracula.ultregion_terminate(basefunc, region)
  basefunc(region)
  local caster = region.caster
  if caster and caster.arcana3buff then
    caster.arcana3buff.timer = -1
  end
end

function RogueTitanDracula.hero_die(basefunc, hero)
  basefunc(hero)
  if hero.ults_region then
    hero.ults_region:terminate()
  end
end

function RogueTitanDracula.hero_reset(basefunc, hero)
  basefunc(hero)
end

function RogueTitanDracula.init_hero(hero)
  hero.die = override(hero.die, RogueTitanDracula.hero_die)
  hero.reset = override(hero.reset, RogueTitanDracula.hero_reset)
  local skillult = hero.skills.TitanDracula_ult
  local skillults = hero.skills.TitanDracula_ults
  local skillatk = hero.skills.TitanDracula_atk
  local skillatk2 = hero.skills.TitanDracula_atk2
  local skillatk3 = hero.skills.TitanDracula_atk3
  local skillatk4 = hero.skills.TitanDracula_atk4
  if skillatk2 then
    skillatk2.power = override(skillatk2.power, RogueTitanDracula.skillatk2_power)
  end
  if skillatk3 then
    skillatk3.power = override(skillatk3.power, RogueTitanDracula.skillatk3_power)
  end
  if skillatk4 then
    skillatk4.power = override(skillatk4.power, RogueTitanDracula.skillatk4_power)
  end
  if skillult then
    skillult.start = override(skillult.start, RogueTitanDracula.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, RogueTitanDracula.skillult_onAttackFrame)
  end
  if skillults then
    skillults.createRegion = override(skillults.createRegion, RogueTitanDracula.skillults_createRegion)
  end
  return hero
end

return RogueTitanDracula.init_hero

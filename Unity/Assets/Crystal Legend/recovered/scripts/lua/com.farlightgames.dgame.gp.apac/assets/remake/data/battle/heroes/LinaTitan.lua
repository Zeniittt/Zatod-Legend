module("ed.battlehero", package.seeall)
local ed = ed
LinaTitan = {}

function LinaTitan.skillatk_takeEffectOn(basefunc, skill, target, source)
  local skillatk4 = skill.caster.skills.LinaTitan_atk4
  basefunc(skill, target, source)
  if skillatk4 then
    target:addBuff(skillatk4:createBuff(target))
  end
end

function LinaTitan.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 4717
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function LinaTitan.skillult_finish(basefunc, skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.LinaTitan_atk4
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4717 then
      tbuff.timer = -1
    end
  end
  if skillatk4 then
    local bid = 4716
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
  end
  basefunc(skill, target)
end

function LinaTitan.skillult_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillult = caster.skills.LinaTitan_ult
  local skillatk4 = caster.skills.LinaTitan_atk4
  if skillatk4 and skillult then
    target:addBuff(skillatk4:createBuff(target))
  end
  basefunc(skill, target, source)
end

function LinaTitan.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillatk2 = skill.caster.skills.LinaTitan_atk2
  local skillatk4 = skill.caster.skills.LinaTitan_atk4
  local hp_lost = target.attribs.HP * 0.1
  local hp_lost_2 = caster.attribs.HP * 3
  local real_lost = math.min(hp_lost, hp_lost_2)
  if skillatk4 and skillatk2 then
    target:addBuff(skillatk4:createBuff(target))
  end
  if target.atk2_hit and skillatk2 then
    target:takeDamage(real_lost, "Holy", "hp", caster, 1, 1, true)
    caster:takeHeal(100, "mp", caster)
  end
  basefunc(skill, target, source)
end

function LinaTitan.skillatk2_finish(basefunc, skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.LinaTitan_atk4
  if skillatk4 then
    local bid = 4716
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
  end
  basefunc(skill, target)
end

function LinaTitan.skillatk3_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local skillatk4 = skill.caster.skills.LinaTitan_atk4
  local skillatk3 = skill.caster.skills.LinaTitan_atk3
  local skillatk3s = skill.caster.skills.LinaTitan_atk3s
  local LinaTitan_region
  local caster = skill.caster
  local target = skill.target
  if skillatk4 and skillatk3 then
    target:addBuff(skillatk4:createBuff(target))
  end
  if caster.name == "LinaTitan" and skillatk3 and skillatk3s then
    skillatk3s.target = target
    LinaTitan_region = skillatk3s:createRegion()
    target.LinaTitan_region = LinaTitan_region
    local position = {
      target.position[1],
      target.position[2]
    }
    LinaTitan_region.position = position
    ed.engine:addRegion(LinaTitan_region)
  end
end

function LinaTitan.skillatk3_finish(basefunc, skill, target)
  local caster = skill.caster
  local skillatk4 = caster.skills.LinaTitan_atk4
  if skillatk4 then
    local bid = 4716
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
  end
  basefunc(skill, target)
end

function LinaTitan.skillak4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, LinaTitan.skillatk4buff_update)
  return buff
end

function LinaTitan.skillatk4buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillatk4 = caster.skills.LinaTitan_atk4
  if not owner.effect_time then
    owner.effect_time = 0
  else
    owner.effect_time = owner.effect_time + dt
    if owner.effect_time >= 4 then
      owner.atk2_hit = true
    end
  end
end

function LinaTitan.init_hero(hero)
  local skillatk = hero.skills.LinaTitan_atk
  local skillult = hero.skills.LinaTitan_ult
  local skillatk2 = hero.skills.LinaTitan_atk2
  local skillatk3 = hero.skills.LinaTitan_atk3
  local skillatk4 = hero.skills.LinaTitan_atk4
  if skillatk then
    skillatk.takeEffectOn = override(skillatk.takeEffectOn, LinaTitan.skillatk_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, LinaTitan.skillatk2_takeEffectOn)
    skillatk2.finish = override(skillult.finish, LinaTitan.skillatk2_finish)
  end
  if skillatk3 then
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, LinaTitan.skillatk3_takeEffectOn)
    skillatk3.finish = override(skillult.finish, LinaTitan.skillatk3_finish)
  end
  if skillatk4 then
    skillatk4.createBuff = override(skillatk4.createBuff, LinaTitan.skillak4_createBuff)
  end
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, LinaTitan.skillult_takeEffectOn)
    skillult.start = override(skillult.start, LinaTitan.skillult_start)
    skillult.finish = override(skillult.finish, LinaTitan.skillult_finish)
  end
  return hero
end

return LinaTitan.init_hero

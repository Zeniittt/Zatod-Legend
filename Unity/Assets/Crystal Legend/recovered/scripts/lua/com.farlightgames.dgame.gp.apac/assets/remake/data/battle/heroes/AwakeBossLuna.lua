module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossLuna = {}
AwakeBossLuna.percents = {
  1,
  1,
  1,
  1
}

function AwakeBossLuna.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  if ed.run_with_scene then
    local effect_night = "eff_point_Luna_night.cha"
    local effect_moon = "eff_point_Luna_moon.cha"
    local origin = {
      ed.engine.stage_rect.maxX / 2,
      0
    }
    local casterorigin = skill.caster.position
    if skill.caster.fashion_id == 311 or skill.caster.fashion_id == 312 then
      effect_moon = "eff_point_Luna_moon_bloodmoon"
    end
    ed.scene:playEffectOnScene(effect_moon, casterorigin, {
      skill.caster.direction,
      1
    }, nil, 0)
    ed.scene:playEffectOnScene(effect_night, origin, nil, nil, 0)
  end
end

function AwakeBossLuna.skillatk3_createProjectile(basefunc, skill)
  local projectile = basefunc(skill)
  projectile:enableJump(4)
  projectile:enableTrack(skill.target)
  return projectile
end

function AwakeBossLuna.skillatk3_power(basefunc, skill, source, target, damage_type)
  local ret = basefunc(skill, source, target, damage_type)
  if source.jumps and source.jumps >= 1 and source.jumps <= 4 then
    ret = ret * AwakeBossLuna.percents[source.jumps]
  end
  return ret
end

function AwakeBossLuna.init_hero(hero)
  local skillult = hero.skills.AwakeBossLuna_ult
  local skillatk = hero.skills.AwakeBossLuna_atk
  local skillatk2 = hero.skills.AwakeBossLuna_atk2
  local skillatk3 = hero.skills.AwakeBossLuna_atk3
  local skillaura = hero.aura_skill_list[1]
  if skillult then
    skillult.info["Ignore Shield"] = true
    hero:preloadEffect("eff_point_Luna_night.cha")
    hero:preloadEffect("eff_point_Luna_moon.cha")
    skillult.start = override(skillult.start, AwakeBossLuna.skillult_start)
  end
  if skillatk then
    skillatk.info["Ignore Shield"] = true
  end
  if skillatk2 then
    skillatk2.info["Ignore Shield"] = true
  end
  if skillatk3 then
    skillatk3.info["Ignore Shield"] = true
    skillatk3.createProjectile = override(skillatk3.createProjectile, AwakeBossLuna.skillatk3_createProjectile)
    skillatk3.power = override(skillatk3.power, AwakeBossLuna.skillatk3_power)
  end
  if hero.fashion_id == 311 or hero.fashion_id == 312 then
    hero:preloadEffect("eff_point_AwakeBossLuna_moon_bloodmoon.cha")
    if skillatk then
      hero.skills.AwakeBossLuna_atk.info["Tile Art"] = "eff_tile_Luna_atk_bloodmoon.cha"
    end
    if skillatk3 then
      hero.skills.AwakeBossLuna_atk3.info["Tile Art"] = "eff_tile_Luna_atk_bloodmoon.cha"
    end
    if skillult then
      hero.skills.AwakeBossLuna_ult.info["Impact Effect"] = "eff_point_Luna_atk2_bloodmoon.cha"
    end
    if skillatk2 then
      hero.skills.AwakeBossLuna_atk2.info["Impact Effect"] = "eff_point_Luna_atk2_bloodmoon.cha"
    end
  end
  if skillaura then
  end
  return hero
end

return AwakeBossLuna.init_hero

module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossDR = {}
AwakeBossDR.fashion_id_1 = 21
AwakeBossDR.offset_list = {
  {0, 0},
  {-19, 5},
  {5, -14},
  {-36, 28},
  {39, -50}
}

function AwakeBossDR.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster then
    local bid = 12002503
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
  end
end

function AwakeBossDR.skillult_createProjectile(basefunc, skill)
  local count = (skill.info["Script Arg2"] - skill.attack_counter) / 5 + 1
  if 5 < count then
    count = 5
  end
  local origtarget = skill.target
  for i = 1, count do
    local projectile = basefunc(skill)
    local h = projectile.height
    local v = projectile.zSpeed
    local a = skill.info["Tile Gravity"]
    local A = 0.5 * a
    local B = v
    local C = h
    local delta = B ^ 2 - 4 * A * C
    local t = (-B - delta ^ 0.5) / (2 * A)
    if 1 < i then
      skill:selectTarget()
    end
    if skill.target then
      local target_position = {
        skill.target.position[1] + AwakeBossDR.offset_list[i][1] * skill.caster:getInitDir(),
        skill.target.position[2] + AwakeBossDR.offset_list[i][2]
      }
      local distance = ed.edpSub(target_position, skill.caster.position)
      projectile.velocity = ed.edpMult(distance, 1 / t)
    end
    ed.engine:addProjectile(projectile)
  end
  return nil
end

function AwakeBossDR.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if isHit and target then
    target:takeDamage(100, "Holy", "mp", caster)
    caster:takeHeal(100, "mp", caster)
  end
  return isHit, dmg
end

function AwakeBossDR.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  return buff
end

function AwakeBossDR.hero_reset(basefunc, hero)
  local skillult = hero.skills.AwakeBossDR_ult
  local skillatk = hero.skills.AwakeBossDR_atk
  local skillatk2 = hero.skills.AwakeBossDR_atk2
  if AwakeBossDR.fashion_id_1 and AwakeBossDR.fashion_id_1 == hero.fashion_id then
    if skillult then
      local originfo1 = skillult.info
      skillult.info = ed.wraptable(originfo1, {
        ["Tile Art"] = "eff_tile_AwakeBossDR_fashion_1_atk.cha"
      })
    end
    if skillatk then
      local originfo2 = skillatk.info
      skillatk.info = ed.wraptable(originfo2, {
        ["Tile Art"] = "eff_tile_AwakeBossDR_fashion_1_atk.cha"
      })
    end
    if skillatk2 then
      local originfo3 = skillatk2.info
      skillatk2.info = ed.wraptable(originfo3, {
        ["Tile Art"] = "eff_tile_AwakeBossDR_fashion_1_atk.cha"
      })
    end
  end
  basefunc(hero)
end

function AwakeBossDR.init_hero(hero)
  local skillult = hero.skills.AwakeBossDR_ult
  local skillatk2 = hero.skills.AwakeBossDR_atk2
  local skillatk3 = hero.skills.AwakeBossDR_atk3
  local skillaura = hero.aura_skill_list[1]
  if AwakeBossDR.fashion_id_1 and AwakeBossDR.fashion_id_1 == hero.fashion_id then
    hero.reset = override(hero.reset, AwakeBossDR.hero_reset)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, AwakeBossDR.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, AwakeBossDR.skillatk3_createBuff)
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Shape Arg1"] = 80 + skillatk3.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillaura then
    local aname = skillaura["Passive Attr"]
    local num = skillaura["Basic Num"]
    if skillaura.evo_rank and 1 <= skillaura.evo_rank then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank1["Script Arg1"]
    end
    if skillaura.evo_rank and skillaura.evo_rank >= 2 then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank2["Script Arg1"]
    end
    if skillaura.evo_rank and skillaura.evo_rank >= 3 then
      skillaura["Basic Num"] = skillaura["Basic Num"] + skillaura.evo_rank3["Script Arg1"]
    end
  end
  if skillult then
    skillult.createProjectile = override(skillult.createProjectile, AwakeBossDR.skillult_createProjectile)
    skillult.start = override(skillult.start, AwakeBossDR.skillult_start)
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
  end
  return hero
end

return AwakeBossDR.init_hero

module("ed.battlehero", package.seeall)
local ed = ed
GuildMountDR = {}
GuildMountDR.fashion_id_1 = 21
GuildMountDR.offset_list = {
  {0, 0},
  {-19, 5},
  {5, -14},
  {-36, 28},
  {39, -50}
}

function GuildMountDR.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster then
    local bid = 12002903
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    caster:addBuff(binfo, caster)
  end
end

function GuildMountDR.skillult_createProjectile(basefunc, skill)
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
        skill.target.position[1] + GuildMountDR.offset_list[i][1] * skill.caster:getInitDir(),
        skill.target.position[2] + GuildMountDR.offset_list[i][2]
      }
      local distance = ed.edpSub(target_position, skill.caster.position)
      projectile.velocity = ed.edpMult(distance, 1 / t)
    end
    ed.engine:addProjectile(projectile)
  end
  return nil
end

function GuildMountDR.skillatk2_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg = basefunc(skill, target, source, shift)
  local caster = skill.caster
  if isHit and target then
    target:takeDamage(100, "Holy", "mp", caster)
    caster:takeHeal(100, "mp", caster)
  end
  return isHit, dmg
end

function GuildMountDR.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  return buff
end

function GuildMountDR.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillaura = hero.aura_skill_list[1]
  if skillaura then
    local bid = 12002904
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, hero, hero)
    hero:addBuff(buff, hero)
  end
end

function GuildMountDR.init_hero(hero)
  local skillult = hero.skills.GuildMountDR_ult
  local skillatk2 = hero.skills.GuildMountDR_atk2
  local skillatk3 = hero.skills.GuildMountDR_atk3
  local skillaura = hero.aura_skill_list[1]
  hero.reset = override(hero.reset, GuildMountDR.hero_reset)
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, GuildMountDR.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, GuildMountDR.skillatk3_createBuff)
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
    skillult.createProjectile = override(skillult.createProjectile, GuildMountDR.skillult_createProjectile)
    skillult.start = override(skillult.start, GuildMountDR.skillult_start)
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

return GuildMountDR.init_hero

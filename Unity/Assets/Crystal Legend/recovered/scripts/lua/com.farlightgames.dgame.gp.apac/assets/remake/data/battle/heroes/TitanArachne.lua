module("ed.battlehero", package.seeall)
local ed = ed
TitanArachne = {}

function TitanArachne.skillult_start(basefunc, skill, target)
  local hero = skill.caster
  local bid = 4788
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
  basefunc(skill, target)
end

function TitanArachne.skillults_start(basefunc, skill, target)
  basefunc(skill, target)
  local hero = skill.caster
  local bid = 4788
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  hero:addBuff(binfo, hero)
end

function TitanArachne.skillult_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4788 then
      tbuff.timer = 1
    end
  end
  caster.TitanArachne_ultchange = true
  if caster.TitanArachne_ultchange then
    if caster.currentActionStage == 1 then
      caster:enterActionStageFromOneStage(2, 10170)
    end
    if ed.run_with_scene then
      local panel = caster.heroPanel
      if panel and caster.name == "TitanArachne" and caster.currentActionStage == 2 then
        panel:setPortrait("UI/DOTA-HERO/TitanArachne2.jpg")
      end
    end
  end
end

function TitanArachne.skillults_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 4788 or tbuff.info.ID == 4789 or tbuff.info.ID == 4790 then
      tbuff.timer = -1
    end
  end
  caster.TitanArachne_ultchange = false
  if not caster.TitanArachne_ultchange then
    if caster.currentActionStage == 2 then
      caster:enterActionStageFromOneStage(1, 10170)
    end
    if ed.run_with_scene then
      local panel = caster.heroPanel
      if panel and caster.name == "TitanArachne" and caster.currentActionStage == 1 then
        panel:setPortrait("UI/DOTA-HERO/TitanArachne.jpg")
      end
    end
  end
end

function TitanArachne.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.TitanArachne_ultchange or hero.mp < 800 and hero.name == "TitanArachne" then
    return false
  end
  return true
end

function TitanArachne.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if ed.run_with_scene and hero.actor then
    hero.actor.cheer = override(hero.actor.cheer, TitanArachne.actor_cheer)
  end
end

function TitanArachne.actor_cheer(basefunc, actor)
  local caster = actor.model
  if caster.currentActionStage and caster.currentActionStage == 2 then
    caster:enterActionStageFromOneStage(1, 10170)
  end
  basefunc(actor)
end

function TitanArachne.skillatks_takeEffectOn(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  local target = skill.target
  local skillatk4s = caster.skills.TitanArachne_atk4s
  local x = ed.rand()
  if skillatk4s and target:isAlive() and x < 0.35 then
    skillatk4s:takeEffectOn(target, caster)
    if caster.TitanArachne_hasArcana and caster.TitanArachne_hasArcana > 3 and caster.TitanArachne_atk4s_ad then
      local bid = 4796
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = ed.BuffCreate(binfo, caster, caster)
      caster:addBuff(buff, caster)
    end
  end
end

function TitanArachne.hero_reset(basefunc, hero)
  basefunc(hero)
  if hero.currentActionStage == 2 then
    hero:enterActionStageFromOneStage(1, 10170)
  end
  hero.TitanArachne_ultchange = false
  local skillatk3 = hero.skills.TitanArachne_atk3
  local dir = hero:getInitDir()
  hero.Spiderweblist = {}
  if skillatk3 and not hero.config.is_summoned and hero:isAlive() then
    local skillevel = {
      skillatk3.level,
      skillatk3.level,
      skillatk3.level
    }
    local count = hero.TitanArachne_hasArcana and 1 < hero.TitanArachne_hasArcana and 5 or 3
    local SpiderwebLoction = {
      {
        65,
        ed.rand() * 50 - 25
      },
      {
        195,
        ed.rand() * 50 - 25
      },
      {
        325,
        ed.rand() * 50 - 25
      },
      {
        130,
        ed.rand() * 50 - 25
      },
      {
        260,
        ed.rand() * 50 - 25
      }
    }
    for i = 1, count do
      local proto = {
        _tid = 333,
        _level = skillatk3.level or 1,
        _skill_levels = skillevel,
        _stars = hero.stars,
        _rank = hero.rank
      }
      local config = {
        is_monster = true,
        estimate_rank = true,
        hp_mod = hero.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or hero.config.hp_mod,
        dps_mod = hero.config.dps_mod or 1
      }
      local Spiderweb = ed.UnitCreate(proto, hero.camp, config)
      Spiderweb.die = override(Spiderweb.die, TitanArachne.Spiderweb_die)
      Spiderweb.direction = hero.direction
      ed.engine:summonUnit(Spiderweb, {
        400 + SpiderwebLoction[i][1] * dir,
        0 + SpiderwebLoction[i][2] * dir
      }, hero)
      Spiderweb.father = hero
      Spiderweb.update = override(Spiderweb.update, TitanArachne.Spiderweb_update)
      Spiderweb.Spiderweb_target = nil
      Spiderweb.webbuff = false
    end
  end
  hero.TitanArachne_atk4s_ad = hero.attribs.AD * 0.03
end

function TitanArachne.Spiderweb_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if not hero.webbuff then
    local webbuff = ed.lookupDataTable("Buff", nil, 4795)
    hero:addBuff(webbuff, hero)
    hero.webbuff = true
  end
  for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
    local unitdistance = ed.edpDistanceSQ(hero.position, unit.position)
    if unit.buff_effects.invulnerable then
    elseif unit.buffManager.invisible then
    elseif unit.buff_effects.uncontrollable then
    elseif unitdistance <= 625 and unit:isAlive() then
      hero.Spiderweb_target = unit
    end
  end
  if hero.Spiderweb_target and hero:isAlive() then
    hero:setDeathWithEffectOrNot(true)
    hero:die()
  end
  if hero.father and not hero.father:isAlive() and hero:isAlive() then
    hero:setDeathWithEffectOrNot(true)
    hero:die()
  end
end

function TitanArachne.Spiderweb_die(basefunc, hero, killer)
  local skill_Spiderweb = hero.father.skills.TitanArachne_atk3
  if skill_Spiderweb and hero.Spiderweb_target then
    skill_Spiderweb:takeEffectOn(hero.Spiderweb_target, hero)
    hero.Spiderweb_target = nil
  end
  basefunc(hero, killer)
end

function TitanArachne.skillatk4_start(basefunc, skill, target)
  local caster = skill.caster
  skill.info["No Dodge"] = true
  skill.info["Ignore Shield"] = true
  local bid = 4788
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function TitanArachne.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 4788 then
      tbuff.timer = -1
    end
  end
end

function TitanArachne.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  if caster.TitanArachne_hasArcana and caster.TitanArachne_hasArcana > 2 then
    buff:setAttribute("Control Effects", {
      "uncontrollable",
      "stable"
    })
  end
  buff.update = override(buff.update, TitanArachne.skillult_buffUpdate)
  return buff
end

function TitanArachne.skillult_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local hero = buff.owner
  local skillults = hero.skills.TitanArachne_ults
  if buff.owner.mp <= 1 and buff.owner:isAlive() then
    buff.owner.removeBuff(buff.owner, buff)
    if hero.currentActionStage == 2 and hero.TitanArachne_ultchange and skillults then
      skillults.cd_remaining = 0
      hero.global_cd = 0
    end
  end
end

function TitanArachne.skillatk2_start(basefunc, skill, target)
  skill.info["No Dodge"] = true
  basefunc(skill, target)
end

function TitanArachne.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
end

function TitanArachne.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.timecount = 1.5
  buff.update = override(buff.update, TitanArachne.skillatk2_buffUpdate)
  return buff
end

function TitanArachne.skillatk2_buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  buff.timecount = buff.timecount - dt
  local owner = buff.owner
  local caster = buff.caster
  if buff.timecount <= 0 then
    buff.timecount = buff.timecount + 1.5
    owner:takeDamage(caster.attribs.AD * (ed.rand() + 1) * 0.575, "Holy", "hp", caster)
    owner:hurt()
  end
end

function TitanArachne.init_hero(hero)
  local skillult = hero.skills.TitanArachne_ult
  local skillults = hero.skills.TitanArachne_ults
  local skillatks = hero.skills.TitanArachne_atks
  local skillatk2 = hero.skills.TitanArachne_atk2
  local skillatk2s = hero.skills.TitanArachne_atk2s
  local skillatk3 = hero.skills.TitanArachne_atk3
  local skillatk4 = hero.skills.TitanArachne_atk4
  hero.reset = override(hero.reset, TitanArachne.hero_reset)
  hero.update = override(hero.update, TitanArachne.hero_update)
  hero.die = override(hero.die, TitanArachne.hero_die)
  hero:setActionStageChangeByManual(true)
  hero.TitanArachne_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatks then
    skillatks.takeEffectOn = override(skillatks.takeEffectOn, TitanArachne.skillatks_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.start = override(skillatk2.start, TitanArachne.skillatk2_start)
    skillatk2.createBuff = override(skillatk2.createBuff, TitanArachne.skillatk2_createBuff)
  end
  if skillatk2s then
    skillatk2s.start = override(skillatk2s.start, TitanArachne.skillatk2_start)
    skillatk2s.createBuff = override(skillatk2s.createBuff, TitanArachne.skillatk2_createBuff)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, TitanArachne.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, TitanArachne.skillatk4_finish)
  end
  if skillult then
    skillult.start = override(skillult.start, TitanArachne.skillult_start)
    skillult.finish = override(skillult.finish, TitanArachne.skillult_finish)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, TitanArachne.skillult_canCastWithTarget)
    skillult.createBuff = override(skillult.createBuff, TitanArachne.skillult_createBuff)
  end
  if skillults then
    skillults.start = override(skillults.start, TitanArachne.skillults_start)
    skillults.finish = override(skillults.finish, TitanArachne.skillults_finish)
  end
  return hero
end

return TitanArachne.init_hero

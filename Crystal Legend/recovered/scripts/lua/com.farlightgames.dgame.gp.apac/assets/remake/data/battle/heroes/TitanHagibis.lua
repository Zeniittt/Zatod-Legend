module("ed.battlehero", package.seeall)
local ed = ed
TitanHagibis = {}
TitanHagibis.TitanHagibis_atk3_stun_bid = 1678
TitanHagibis.TitanHagibis_enter_bid = 1681
TitanHagibis.tornado_live_time = 18
TitanHagibis.tornado_r = 65
TitanHagibis.first_v = 2.5
TitanHagibis.tornado_v = 40
TitanHagibis.skillults_ratio = 15
TitanHagibis.TitanHagibis_enter_bid2 = 1686
TitanHagibis.TitanHagibis_fashionID = 101041
TitanHagibis.fashion_HitID = 4505
TitanHagibis.fashion_shieldID = 4506

function TitanHagibis.skillatk3_start(basefunc, skill, target)
  basefunc(skill, target)
  skill.TitanHagibis_atk3_targetcount = 0
end

function TitanHagibis.skillatk3_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  skill.TitanHagibis_atk3_targetcount = skill.TitanHagibis_atk3_targetcount + 1
  local ret = basefunc(skill, target, source, shift)
  if skill.TitanHagibis_atk3_targetcount == 1 and target:isAlive() and ret then
    local bid = TitanHagibis.TitanHagibis_atk3_stun_bid
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
end

function TitanHagibis.skillult_buff_update(basefunc, buff, dt)
  local caster = buff.caster
  local owner = buff.owner
  local skillults = caster.skills.TitanHagibis_ults
  local skillults2 = caster.skills.TitanHagibis_ults2
  if not caster.TitanHagibis_tornado or not caster.TitanHagibis_tornado:isAlive() then
    buff.timer = 0
  end
  if owner.TitanHagibis_ultinvulnerable == true then
    owner.TitanHagibis_ultinvulnerable = false
    skillults:takeEffectOn(owner)
    skillults2:takeEffectOn(owner)
  end
  if not buff.lastposition then
    buff.lastposition = {
      owner.position[1],
      owner.position[2]
    }
  end
  if buff.lastposition[1] ~= owner.position[1] or buff.lastposition[2] ~= owner.position[2] then
    owner.TitanHagibis_distanceSQ = ((owner.position[1] - buff.lastposition[1]) ^ 2 + (owner.position[2] - buff.lastposition[2]) ^ 2) ^ 0.5
    skillults:takeEffectOn(owner)
    skillults2:takeEffectOn(owner)
    buff.lastposition = {
      owner.position[1],
      owner.position[2]
    }
  end
  basefunc(buff, dt)
end

function TitanHagibis.ult_buff_OnRemoved(basefunc, buff)
  basefunc(buff)
  buff.lastposition = nil
end

function TitanHagibis.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, TitanHagibis.skillult_buff_update)
  buff.onRemoved = override(buff.onRemoved, TitanHagibis.ult_buff_OnRemoved)
  return buff
end

function TitanHagibis.skillults_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillult = caster.skills.TitanHagibis_ult
  if target.buff_effects.invulnerable then
    target.TitanHagibis_ultinvulnerable = true
  end
  if target.TitanHagibis_distanceSQ then
    skill.info["Basic Num"] = math.min(target.TitanHagibis_distanceSQ, 200) / 800 * caster.attribs.AD * (1 + skill.info["Script Arg1"] / 100) * TitanHagibis.skillults_ratio
  end
  target.notPopupBattleInfo = true
  basefunc(skill, target, source)
  target.notPopupBattleInfo = nil
end

function TitanHagibis.skillults2_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local skillult = caster.skills.TitanHagibis_ult
  local ratio = 1
  if caster.TitanHagibis_hasArcana > 3 then
    ratio = 1.5
  end
  if target.TitanHagibis_distanceSQ then
    skill.info["Basic Num"] = math.min(target.TitanHagibis_distanceSQ, 200) / 800 * 500 * ratio
  end
  basefunc(skill, target, source)
end

function TitanHagibis.tornado_update(basefunc, hero, dt)
  local TitanHagibis_tornado_v = TitanHagibis.tornado_v
  if hero.first_count >= 0 and hero.first_count <= 8 then
    TitanHagibis_tornado_v = TitanHagibis.tornado_v * TitanHagibis.first_v
  end
  if not hero.walk_count then
    hero.walk_count = 1
  end
  hero.walk_count = hero.walk_count + 1
  if hero.walk_count >= 1 then
    local angle = hero.last_angle + (ed.rand() * 10 - 5)
    if hero.position[1] >= 670 then
      if 0 <= angle then
        angle = angle + 15
      else
        angle = angle - 15
      end
    elseif hero.position[1] <= 130 then
      if 0 <= angle then
        angle = angle - 15
      else
        angle = angle + 15
      end
    elseif hero.position[2] >= 50 then
      if angle <= 90 then
        angle = angle - 15
      else
        angle = angle + 15
      end
    elseif hero.position[2] <= -50 then
      if angle <= -90 then
        angle = angle - 15
      else
        angle = angle + 15
      end
    end
    local vx = TitanHagibis_tornado_v * math.cos(math.rad(angle))
    local vy = TitanHagibis_tornado_v * math.sin(math.rad(angle))
    hero.walk_v = {vx, vy}
    hero.walk_count = 0
    hero.last_angle = angle
  end
  hero.first_count = hero.first_count + 1
  basefunc(hero, dt)
  hero.live_time = hero.live_time - dt
  if 0 >= hero.live_time then
    hero:die()
  end
  if hero:isAlive() and hero.config and hero.config.summoner then
    local skillult2 = hero.config.summoner.skills.TitanHagibis_ults3
    skillult2.info["No Dodge"] = true
    for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
      local unitdistance = ed.edpDistanceSQ(unit.position, hero.position)
      if unitdistance <= TitanHagibis.tornado_r * TitanHagibis.tornado_r then
        local havebuff
        for i, tbuff in ipairs(unit.buff_list) do
          if tbuff.info.ID == 1684 then
            havebuff = true
          end
        end
        if not havebuff then
          unit.notPopupBattleInfo = true
          skillult2:takeEffectOn(unit)
          unit.notPopupBattleInfo = nil
          if unit.height >= 250 then
            local bid = 1684
            local binfo = ed.lookupDataTable("Buff", nil, bid)
            local buff = unit:addBuff(binfo, hero)
          end
        end
      end
    end
  end
end

function TitanHagibis.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.TitanHagibis_tornado and caster.TitanHagibis_tornado:isAlive() then
    caster.TitanHagibis_tornado:die()
  end
  local skillult = caster.skills.TitanHagibis_ult
  local dir = caster:getInitDir()
  local summonlocation = {
    caster.position[1] + dir * 50,
    caster.position[2]
  }
  local caster = skill.caster
  local dir = caster:getInitDir()
  local skillevel = {
    skillult.level,
    skillult.level,
    skillult.level
  }
  local proto = {
    _tid = 297,
    _level = skillult.level or 1,
    _skill_levels = skillevel,
    _stars = caster.stars,
    _rank = caster.rank
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = caster.camp == ed.emCampEnemy and ed.engine.guildInstance_mode and 2 or caster.config.hp_mod,
    dps_mod = caster.config.dps_mod or 1
  }
  local TitanHagibis_tornado = ed.UnitCreate(proto, caster.camp, config)
  TitanHagibis_tornado.direction = caster.direction
  TitanHagibis_tornado.walk_count = 0
  TitanHagibis_tornado.first_count = 0
  TitanHagibis_tornado.last_angle = 90 - TitanHagibis_tornado.direction * 90
  TitanHagibis_tornado.live_time = TitanHagibis.tornado_live_time
  TitanHagibis_tornado.update = override(TitanHagibis_tornado.update, TitanHagibis.tornado_update)
  local bid = 606
  local binfo606 = ed.lookupDataTable("Buff", nil, bid)
  local buff = TitanHagibis_tornado:addBuff(binfo606, TitanHagibis_tornado)
  ed.engine:summonUnit(TitanHagibis_tornado, summonlocation, caster)
  caster.TitanHagibis_tornado = TitanHagibis_tornado
end

function TitanHagibis.hero_reset(basefunc, hero)
  basefunc(hero)
  local bid = TitanHagibis.TitanHagibis_enter_bid
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, hero, hero)
  hero.TitanHagibis_enter_Buff = hero:addBuff(buff, hero)
  local bid2 = TitanHagibis.TitanHagibis_enter_bid2
  local binfo2 = ed.lookupDataTable("Buff", nil, bid2)
  local buff2 = ed.BuffCreate(binfo2, hero, hero)
  hero.TitanHagibis_enter_Buff2 = hero:addBuff(buff2, hero)
  hero:setPosition({
    400 - 325 * hero:getInitDir(),
    0
  })
  local skillatk4 = hero.skills.TitanHagibis_atk4
  local skillatk3 = hero.skills.TitanHagibis_atk3
  if skillatk4 and skillatk3 and hero.TitanHagibis_hasArcana > 1 then
    skillatk4.cd_remaining = 0
    skillatk3.cd_remaining = 0
  end
  hero.hasFashion = false
  hero.fashion_index = 0
end

function TitanHagibis.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if TitanHagibis.TitanHagibis_fashionID and TitanHagibis.TitanHagibis_fashionID == hero.fashion_id and hero.fashion_index then
    hero.fashion_index = hero.fashion_index + dt
    if hero.fashion_index == 0.125 then
      local skillatk = hero.skills.TitanHagibis_atk
      local originfo = skillatk.info
      skillatk.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_TitanHagibis_skin_atk.cha"
      })
      local skillatk2 = hero.skills.TitanHagibis_atk2
      local originfo = skillatk2.info
      skillatk2.info = ed.wraptable(originfo, {
        ["Tile Art"] = "eff_tile_TitanHagibis_skin_atk2.cha"
      })
    end
  end
end

function TitanHagibis.hero_die(basefunc, hero, killer)
  basefunc(hero, killer)
  if hero.TitanHagibis_tornado and hero.TitanHagibis_tornado:isAlive() then
    hero.TitanHagibis_tornado:die()
  end
end

function TitanHagibis.skillatk4_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster.TitanHagibis_enter_Buff then
    caster.TitanHagibis_enter_Buff.timer = 0
  end
end

function TitanHagibis.skillatk4_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local hero = skill.caster
  if TitanHagibis.TitanHagibis_fashionID and TitanHagibis.TitanHagibis_fashionID == hero.fashion_id and hero.hasFashion ~= true then
    local shieldbid = TitanHagibis.fashion_shieldID
    local shieldbinfo = ed.lookupDataTable("Buff", nil, shieldbid)
    local shieldbuff = ed.BuffCreate(shieldbinfo, hero, hero)
    shieldbuff.shield = hero.attribs.HP * 0.1
    hero:addBuff(shieldbuff, hero)
    for unit in ed.engine:foreachAliveUnit(hero.camp) do
      if unit.info["Unit Type"] == "Hero" then
        local HitBid = TitanHagibis.fashion_HitID
        local Hitbinfo = ed.lookupDataTable("Buff", nil, HitBid)
        local Hitbuff = ed.BuffCreate(Hitbinfo, unit, hero)
        Hitbuff:setAttribute("HIT", 30)
        unit:addBuff(Hitbuff, hero)
      end
    end
    hero.hasFashion = true
  end
end

function TitanHagibis.skillatk4_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if caster.TitanHagibis_enter_Buff2 then
    caster.TitanHagibis_enter_Buff2.timer = 0
  end
end

function TitanHagibis.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if skill.caster.TitanHagibis_hasArcana > 2 then
    buff:setAttribute("HAST", 75)
    buff:setAttribute("MSPD", 75)
  end
  return buff
end

function TitanHagibis.init_hero(hero)
  local skillult = hero.skills.TitanHagibis_ult
  local skillults = hero.skills.TitanHagibis_ults
  local skillults2 = hero.skills.TitanHagibis_ults2
  local skillatk = hero.skills.TitanHagibis_atk
  local skillatk2 = hero.skills.TitanHagibis_atk2
  local skillatk3 = hero.skills.TitanHagibis_atk3
  local skillatk4 = hero.skills.TitanHagibis_atk4
  hero.TitanHagibis_hasArcana = ed.getProtoArcanaLevel(hero.proto)
  if skillatk3 then
    skillatk3.start = override(skillatk3.start, TitanHagibis.skillatk3_start)
    skillatk3.takeEffectOn = override(skillatk3.takeEffectOn, TitanHagibis.skillatk3_takeEffectOn)
  end
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanHagibis.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, TitanHagibis.skillult_createBuff)
    skillults.takeEffectOn = override(skillults.takeEffectOn, TitanHagibis.skillults_takeEffectOn)
    skillults2.takeEffectOn = override(skillults2.takeEffectOn, TitanHagibis.skillults2_takeEffectOn)
  end
  if skillatk4 then
    skillatk4.start = override(skillatk4.start, TitanHagibis.skillatk4_start)
    skillatk4.finish = override(skillatk4.finish, TitanHagibis.skillatk4_finish)
    skillatk4.createBuff = override(skillatk4.createBuff, TitanHagibis.skillatk4_createBuff)
    if TitanHagibis.TitanHagibis_fashionID and TitanHagibis.TitanHagibis_fashionID == hero.fashion_id then
      skillatk4.onAttackFrame = override(skillatk4.onAttackFrame, TitanHagibis.skillatk4_onAttackFrame)
    end
  end
  hero.reset = override(hero.reset, TitanHagibis.hero_reset)
  hero.die = override(hero.die, TitanHagibis.hero_die)
  hero.update = override(hero.update, TitanHagibis.hero_update)
  return hero
end

return TitanHagibis.init_hero

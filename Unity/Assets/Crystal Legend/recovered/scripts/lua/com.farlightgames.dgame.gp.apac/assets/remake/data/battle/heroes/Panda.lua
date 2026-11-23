module("ed.battlehero", package.seeall)
local ed = ed
Panda = {}
Panda.moveforwardtable = {
  [0] = 0,
  [1] = 15,
  [2] = 10,
  [3] = 15,
  [4] = 5,
  [5] = 15,
  [6] = 5,
  [7] = 5,
  [8] = 5,
  [9] = 5
}
Panda.fashionPuppetName = "Panda_fashion_1.cha"

function Panda.skillult_takeEffectOn(basefunc, self, target, source, shift)
  local is_hit, dmg = basefunc(self, target, source, shift)
  local caster = self.caster
  if self.evo_rank and self.evo_rank >= 3 then
    local holydmg = self.evo_rank3["Script Arg1"] * caster.attribs.AD
    target:takeDamage(holydmg, "Holy", "hp", self.caster)
  end
  local shard = caster.proto._shard
  if shard and shard._id == 1000441 and caster.shardSkillRank and caster.shardSkillRank >= 1 then
    local APdmg = caster.shardSkill[1]["Script Arg1"] * caster.attribs.AD
    target:takeDamage(APdmg, "AP", "hp", self.caster)
  end
  return is_hit, dmg
end

function Panda.skillult_onAttackFrame(basefunc, skill)
  local awake = ed.protoAwake(skill.caster.proto, 44)
  local caster = skill.caster
  local puppetName = caster.actor and caster.actor.puppetName
  if puppetName and puppetName == Panda.fashionPuppetName then
    skill.info["Tile Art"] = "eff_tile_Panda_ult_fashion.cha"
  elseif awake then
    skill.info["Tile Art"] = "eff_tile_Panda_ult2.cha"
  end
  local originfo = skill.info
  local attack_counter = skill.attack_counter
  local moveforward = Panda.moveforwardtable[attack_counter] or 0
  if attack_counter == 0 then
    skill.info = ed.wraptable(originfo, {
      ["Track Type"] = "projectile",
      ["Buff ID"] = 0
    })
    basefunc(skill)
    skill.info = originfo
  elseif attack_counter < 5 then
    skill.info = ed.wraptable(originfo, {
      ["Move Forward"] = moveforward,
      ["Knock Up"] = 0.1,
      ["Knock Back"] = 10
    })
    basefunc(skill)
    skill.info = originfo
    return
  elseif attack_counter == 5 then
    skill.info = ed.wraptable(originfo, {
      ["Move Forward"] = moveforward,
      ["Knock Up"] = 0.6,
      ["Knock Back"] = 20
    })
    local origin = {
      skill.caster.position[1] + 50 * skill.caster.direction,
      skill.caster.position[2]
    }
    if skill.target and not skill.target.buff_effects.stable then
      skill.target.position = {
        origin[1] + 20 * skill.caster.direction,
        origin[2]
      }
    end
    if ed.run_with_scene then
      local effect_name = "eff_point_Panda_ult.cha"
      ed.scene:playEffectOnScene(effect_name, origin, {
        skill.caster.direction,
        1
      }, nil, 0)
    end
    basefunc(skill)
    skill.info = originfo
    return
  elseif 5 < attack_counter then
    skill.info = ed.wraptable(originfo, {
      ["Move Forward"] = moveforward,
      ["Knock Up"] = 0.5,
      ["Knock Back"] = 5
    })
    basefunc(skill)
    skill.info = originfo
    return
  end
end

function Panda.skillatk2_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local skillatk4 = caster.skills.Panda_atk4
  if skillatk4 and skillatk4.evo_rank and skillatk4.evo_rank >= 2 then
    local skillatk2_buff = caster.skills.Panda_atk2_buff
    local buff = skillatk2_buff:createBuff(caster)
    caster:addBuff(buff, caster)
  end
end

function Panda.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function Panda.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = skill.evo_rank2["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function Panda.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillatk4 = hero.skills.Panda_atk4
  if skillatk4 and hero:isAlive() then
    if not hero.wind_remainingTime then
      hero.wind_remainingTime = skillatk4.info["Script Arg3"]
    end
    hero.wind_remainingTime = hero.wind_remainingTime - dt
    if hero.wind_remainingTime <= 0 then
      hero.wind_remainingTime = skillatk4.info["Script Arg2"]
      if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
        hero.wind_remainingTime = hero.wind_remainingTime - skillatk4.evo_rank1["Script Arg1"]
      end
      local enemycount = 0
      for unit in ed.engine:foreachAliveUnit(hero.foecamp) do
        if unit and not unit.config.is_summoned then
          enemycount = enemycount + 1
        end
      end
      local skillwind = skillatk4
      local shard = hero.proto._shard
      if shard and shard._id == 1000441 and hero.shardSkillRank and hero.shardSkillRank >= 2 then
        skillwind = hero.skills.Panda_atk4shard
      end
      if 1 < enemycount then
        enemycount = 0
        local target = skillwind:selectTarget()
        if target then
          if ed.run_with_scene then
            local effect_name = "eff_point_DOTsr_atk2"
            if not effect_name then
              return
            end
            local effect_z = 1
            if not target.buff_effects.uncontrollable or target.config.is_summoned then
              ed.scene:playEffectOnScene(effect_name, target.position, {
                target.direction,
                1
              }, nil, effect_z)
            end
          end
          local list = target.buff_list
          local buff_list = {}
          local myenemycamp = hero.foecamp
          for i = 1, #list do
            local buff = list[i]
            if buff and (not buff.caster or buff.caster.camp == myenemycamp) and buff.info.Dispel == "YES" then
              buff_list[#buff_list + 1] = buff
            end
          end
          for i = 1, #buff_list do
            target:removeBuff(buff_list[i])
          end
          skillwind:takeEffectOn(target)
        end
      end
    end
  end
end

function Panda.skillatk4_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.update = override(buff.update, Panda.skillatk4buff_update)
  buff.onRemoved = override(buff.onRemoved, Panda.skillatk4buff_onRemoved)
  return buff
end

function Panda.skillatk4buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local time = buff.timer
  if buff.owner.actor then
    if 2.5 < time then
      buff.owner.actor.zSpeed = 280
    else
      buff.owner.actor.zSpeed = 80 * math.sin(math.rad(time * 360)) + 100
    end
  end
end

function Panda.skillatk4buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local owner = buff.owner
  local caster = buff.caster
  local skillatk4 = caster.skills.Panda_atk4
  if skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
    local bid = 10004406
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    owner:addBuff(binfo, caster)
  end
end

function Panda.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.wind_remainingTime = nil
end

function Panda.skillshard_start(basefunc, skill, target)
  local owner = skill.caster
  local bid = 10004408
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  basefunc(skill, target)
end

function Panda.init_hero(hero)
  local skillult = hero.skills.Panda_ult
  local skillatk = hero.skills.Panda_atk
  local skillatk2 = hero.skills.Panda_atk2
  local skillatk3 = hero.skills.Panda_atk3
  local skillatk4 = hero.skills.Panda_atk4
  local shard = hero.proto._shard
  if skillult then
    if shard and shard._id == 1000441 and hero.shardSkillRank and hero.shardSkillRank >= 1 then
      skillult.info = ed.wraptable(skillult.info, {
        ["No Dodge"] = true
      })
    end
    if shard and shard._id == 1000441 and hero.shardSkillRank and hero.shardSkillRank >= 3 then
      skillult.start = override(skillult.start, Panda.skillshard_start)
    end
    hero:preloadEffect("eff_point_Panda_ult.cha")
    if skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    skillult.takeEffectOn = override(skillult.takeEffectOn, Panda.skillult_takeEffectOn)
    skillult.onAttackFrame = override(skillult.onAttackFrame, Panda.skillult_onAttackFrame)
  end
  if skillatk2 then
    if shard and shard._id == 1000441 and hero.shardSkillRank and hero.shardSkillRank >= 3 then
      skillatk2.start = override(skillatk2.start, Panda.skillshard_start)
    end
    if skillatk2.evo_rank and 1 <= skillatk2.evo_rank then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank1["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
    if skillatk2.evo_rank and 3 <= skillatk2.evo_rank then
      skillatk2.createBuff = override(skillatk2.createBuff, Panda.skillatk2_createBuff)
    end
    skillatk2.onAttackFrame = override(skillatk2.onAttackFrame, Panda.skillatk2_onAttackFrame)
  end
  if skillatk3 then
    if shard and shard._id == 1000441 and hero.shardSkillRank and hero.shardSkillRank >= 3 then
      skillatk3.start = override(skillatk3.start, Panda.skillshard_start)
    end
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.createBuff = override(skillatk3.createBuff, Panda.skillatk3_createBuff)
    end
    if skillatk3.evo_rank and 3 <= skillatk3.evo_rank then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk4 then
    hero.update = override(hero.update, Panda.hero_update)
    hero.reset = override(hero.reset, Panda.hero_reset)
    local skillwind = skillatk4
    if shard and shard._id == 1000441 and hero.shardSkillRank and hero.shardSkillRank >= 2 then
      skillwind = hero.skills.Panda_atk4shard
    end
    skillwind.createBuff = override(skillwind.createBuff, Panda.skillatk4_createBuff)
  end
  return hero
end

return Panda.init_hero

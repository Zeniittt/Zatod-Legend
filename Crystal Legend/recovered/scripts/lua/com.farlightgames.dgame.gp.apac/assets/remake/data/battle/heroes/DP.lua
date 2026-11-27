module("ed.battlehero", package.seeall)
local ed = ed
DP = {}
DP.fashion_id_1 = 401
DP.fashion_id_4 = 404
DP.shard_3 = 10004003

function DP.ult_buff_update(basefunc, self, dt)
  local buff = self
  local owner = buff.owner
  local caster = buff.caster
  local skillult = buff.owner.skills.DP_ult
  buff.second_timer = buff.second_timer - dt
  if buff.second_timer > 1.5 and buff then
    local timer = buff.attack_timer - dt
    while timer <= 0 do
      local shard = caster.proto._shard
      if shard and shard._id == 1000401 then
        if caster.shardSkillRank and caster.shardSkillRank >= 2 then
          timer = timer + 0.25
        else
          timer = timer + 0.375
        end
      else
        timer = timer + 0.375
      end
      local skill = buff.caster.skills.DP_ult
      local originfo = skill.info
      local origtarget = skill.target
      skill.info = ed.wraptable(originfo, {
        ["Buff ID"] = 0,
        ["Damage Type"] = "AP",
        ["Target Camp"] = -1,
        ["Affected Camp"] = -1,
        ["Target Type"] = "random"
      })
      local target = skill:selectTarget()
      if target then
        local succ, dmg = skill:takeEffectOn(target, skill.caster)
        buff.total_times = buff.total_times + 1
        if dmg then
          local coefficient = 1
          buff.total_dmg = buff.total_dmg + dmg
          owner.buff_total_dmg = buff.total_dmg
          if skillult.evo_rank and skillult.evo_rank >= 3 then
            owner:takeHeal(dmg * 0.3, "hp", owner)
          end
        end
      end
      skill.info = originfo
      skill.target = origtarget
    end
    buff.attack_timer = timer
  end
  if buff.second_timer == 1 and ed.run_with_scene then
    ed.scene:removeEffect(buff.origin_effect, -1)
  end
  basefunc(buff, dt)
end

function DP.ult_buff_onRemoved(basefunc, buff)
  local skillult = buff.owner.skills.DP_ult
  local hprpro = 0.65
  if skillult.evo_rank and skillult.evo_rank >= 3 then
    hprpro = 0.4
  end
  buff.owner:takeHeal(buff.total_dmg * hprpro, "hp", buff.owner)
  if buff.second_timer > 0 and ed.run_with_scene then
    ed.scene:removeEffect(buff.origin_effect, -1)
  end
  buff.second_timer = 10
  basefunc(buff)
end

function DP.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target, source)
  local caster = skill.caster
  local shard = caster.proto._shard
  if caster ~= target and isHit and shard and shard._id == 1000401 and caster.shardSkillRank and caster.shardSkillRank >= 2 then
    local mppower = caster.shardSkill[2]["Script Arg2"]
    target:takeDamage(mppower, "Holy", "mp", skill.caster)
    caster:takeHeal(mppower, "mp", caster)
  end
  return isHit, dmg, Crit, lfs_amount
end

function DP.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.attack_timer = 0.375
  local caster = skill.caster
  local shard = caster.proto._shard
  if shard and shard._id == 1000401 and caster.shardSkillRank and caster.shardSkillRank >= 2 then
    buff.attack_timer = 0.25
  end
  buff.total_dmg = 0
  buff.total_times = 0
  buff.second_timer = 10
  if ed.run_with_scene then
    local effect_name = "eff_buff_DP_ult.cha"
    if DP.fashion_id_1 and DP.fashion_id_1 == skill.caster.fashion_id then
      effect_name = "eff_buff_DP_fashion_1_ult.cha"
    end
    if DP.fashion_id_4 and DP.fashion_id_4 == skill.caster.fashion_id then
      effect_name = "eff_buff_DP_fashion_4_ult.cha"
    end
    if not effect_name then
      return
    end
    local effect_z = -1
    buff.origin_effect = ed.scene:playEffectOnScene(effect_name, buff.owner.position, {
      buff.owner.direction,
      1
    }, nil, effect_z)
  end
  buff.update = override(buff.update, DP.ult_buff_update)
  buff.onRemoved = override(buff.onRemoved, DP.ult_buff_onRemoved)
  return buff
end

function DP.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = skill.evo_rank1["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = skill.evo_rank2["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff:setAttribute("MR", -skill.evo_rank3["Script Arg1"])
  end
  local shard = caster.proto._shard
  if shard and shard._id == 1000401 and caster.shardSkillRank and 1 <= caster.shardSkillRank then
    buff:setAttribute("HAST", -caster.shardSkill[1]["Script Arg1"])
    buff:setAttribute("MSPD", -caster.shardSkill[1]["Script Arg1"])
  end
  return buff
end

function DP.getLostHPAfterImmunity(basefunc, unit, damage, immunity, damage_type, source, skill, field)
  local lostHP = basefunc(unit, damage, immunity)
  local shard = unit.proto._shard
  if shard and shard._id == 1000401 and field == "hp" and unit.shardSkillRank and unit.shardSkillRank >= 3 then
    local bid = DP.shard_3
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, unit, unit)
    buff:setAttribute("HPR", unit.shardSkill[3]["Script Arg1"] / 100 * lostHP / 5)
    unit:addBuff(buff, unit)
  end
  return lostHP
end

function DP.init_hero(hero)
  local skillult = hero.skills.DP_ult
  local skillatk = hero.skills.DP_atk
  local skillatk2 = hero.skills.DP_atk2
  local skillatk3 = hero.skills.DP_atk3
  local skillpasv = hero.passive_skill_list[1]
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, DP.getLostHPAfterImmunity)
  if skillatk then
    if DP.fashion_id_1 and DP.fashion_id_1 == hero.fashion_id then
      skillatk.info = ed.wraptable(skillatk.info, {
        ["Tile Art"] = "eff_tile_DP_fashion_1_atk.cha"
      })
    end
    if DP.fashion_id_4 and DP.fashion_id_4 == hero.fashion_id then
      skillatk.info = ed.wraptable(skillatk.info, {
        ["Tile Art"] = "eff_tile_DP_fashion_4_atk.cha"
      })
    end
  end
  if skillult then
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
    local shard = hero.proto._shard
    if shard and shard._id == 1000401 and hero.shardSkillRank and 2 <= hero.shardSkillRank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = hero.shardSkill[2]["Script Arg1"]
      })
    end
    skillult.createBuff = override(skillult.createBuff, DP.skillult_createBuff)
    skillult.takeEffectOn = override(skillult.takeEffectOn, DP.skillult_takeEffectOn)
  end
  if skillatk2 then
    if DP.fashion_id_1 and DP.fashion_id_1 == hero.fashion_id then
      local plusratio = skillatk2.info["Plus Ratio"]
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Point Effect"] = "eff_point_DP_fashion_1_atk2.cha",
        ["Plus Ratio"] = plusratio
      })
    end
    if DP.fashion_id_4 and DP.fashion_id_4 == hero.fashion_id then
      local plusratio = skillatk2.info["Plus Ratio"]
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Point Effect"] = "eff_point_DP_fashion_4_atk2.cha",
        ["Plus Ratio"] = plusratio
      })
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
    if skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    if DP.fashion_id_1 and DP.fashion_id_1 == hero.fashion_id then
      local plusratio = skillatk3.info["Plus Ratio"]
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Point Effect"] = "eff_point_DP_fashion_1_atk3.cha",
        ["Point Zorder"] = -1
      })
    end
    if DP.fashion_id_4 and DP.fashion_id_4 == hero.fashion_id then
      local plusratio = skillatk3.info["Plus Ratio"]
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Point Effect"] = "eff_point_DP_fashion_4_atk3.cha",
        ["Point Zorder"] = -1
      })
    end
    skillatk3.createBuff = override(skillatk3.createBuff, DP.skillatk3_createBuff)
  end
  if skillpasv then
    local aname = skillpasv["Passive Attr"]
    if skillpasv.evo_rank and 1 <= skillpasv.evo_rank then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank1["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 2 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank2["Script Arg1"]
    end
    if skillpasv.evo_rank and skillpasv.evo_rank >= 3 then
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  return hero
end

return DP.init_hero

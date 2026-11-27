module("ed.battlehero", package.seeall)
local ed = ed
TitanVM = {}

function TitanVM.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local owner = skill.caster
  if skill.evo_rank and skill.evo_rank >= 3 then
    skill.info["No Dodge"] = true
  end
  local bid = 11020303
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  owner:addBuff(binfo, owner)
end

function TitanVM.skillult_finish(basefunc, skill)
  basefunc(skill)
  for i, tbuff in ipairs(skill.caster.buff_list) do
    if tbuff.info.ID == 11020303 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
  local skillatk4 = skill.caster.skills.TitanVM_atk4
  if skillatk4 and skillatk4.evo_rank and skillatk4.evo_rank >= 3 then
    skillatk4.cd_remaining = 0
  end
end

function TitanVM.skillult_onAttackFrame(basefunc, skill)
  local caster = skill.caster
  local attack_counter = skill.attack_counter
  local skillult = caster.skills.TitanVM_ult
  local hero = skill.caster
  local target = skill.target
  local blink_distance = 70
  if attack_counter then
    if attack_counter == 0 then
      if target then
        local direction = 0 < target.position[1] - hero.position[1] and -1 or 1
        hero.direction = direction
        local position1 = target.position[1] - direction * blink_distance
        if target.buff_effects.stable or 799 < position1 or position1 < 1 then
          position1 = position1 + 2 * direction * blink_distance
          hero.direction = -direction
        end
        hero.position = {
          position1,
          target.position[2]
        }
      end
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 1 then
      if ed.run_with_scene then
        local effect_name1 = "eff_point_TitanVM_ult.cha"
        skillult.effectult1 = ed.scene:playEffectOnScene(effect_name1, {400, 0}, {
          caster.direction * 1,
          1
        }, nil, 1)
      end
      skill.attack_counter = skill.attack_counter + 1
    end
    if attack_counter == 2 then
      if caster.manually_casting then
        ed.engine:unfreeze()
        caster.manually_casting = false
      end
      skillult:takeEffectAt({400, 0}, caster)
      skill.attack_counter = skill.attack_counter + 1
    end
  end
end

function TitanVM.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  buff.onRemoved = override(buff.onRemoved, TitanVM.skillultbuff_onRemoved)
  return buff
end

function TitanVM.skillultbuff_onRemoved(basefunc, buff)
  local caster = buff.caster
  local owner = buff.owner
  local skillults = caster.skills.TitanVM_ults
  if skillults and not ed.engine.beingEnd then
    skillults:takeEffectOn(owner, caster)
  end
  basefunc(buff)
end

function TitanVM.skillatk2_takeEffectOn(basefunc, skill, target)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target)
  local caster = skill.caster
  if isHit and target and not target.buff_effects.uncontrollable and not target.buff_effects.invulnerable then
    local bid = 11020302
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    binfo.fearrange = 2
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
  return isHit, dmg, Crit, lfs_amount
end

function TitanVM.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"]
  end
  if buff then
    buff.onRemoved = override(buff.onRemoved, TitanVM.skillatk3buff_onRemoved)
  end
  return buff
end

function TitanVM.skillatk3buff_onRemoved(basefunc, buff)
  local caster = buff.caster
  local skillatk3s = caster.skills.TitanVM_atk3s
  if caster:isAlive() and skillatk3s and not ed.engine.beingEnd then
    skillatk3s:takeEffectAt(caster.position, caster)
  end
  basefunc(buff)
end

function TitanVM.skillatk4_takeEffectOn(basefunc, skill, target)
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target)
  local caster = skill.caster
  if skill.evo_rank and skill.evo_rank >= 2 and isHit and not target.buff_effects.uncontrollable and not target.buff_effects.invulnerable then
    local bid = 11020306
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, target, caster)
    target:addBuff(buff, caster)
  end
  local ShieldIncrease = 0
  local ShieldWeak = 0
  if caster.attribs.ShieldIncrease then
    ShieldIncrease = caster.attribs.ShieldIncrease
  end
  if caster.attribs.ShieldWeak then
    ShieldWeak = caster.attribs.ShieldWeak
  end
  local shieldratio = math.max(0.01, 1 + (ShieldIncrease - ShieldWeak) / 100)
  local skillatk4basicshield = skill.info["Script Arg2"] * (caster.config.hp_mod or 1) * shieldratio
  local skillatk4bonusshield = skill.info["Script Arg3"] * (caster.config.hp_mod or 1) * shieldratio
  local havebuff = false
  local skillatk4buff
  for i, tbuff in ipairs(caster.buff_list) do
    if tbuff.info.ID == 11020307 then
      skillatk4buff = tbuff
      havebuff = true
    end
  end
  if havebuff and isHit and not target.config.is_summoned then
    skillatk4buff.shield = skillatk4buff.shield + skillatk4bonusshield
  end
  if not havebuff then
    local bid0 = 11020307
    local binfo0 = ed.lookupDataTable("Buff", nil, bid0)
    local buff0 = ed.BuffCreate(binfo0, caster, caster)
    buff0.shield = skillatk4basicshield
    if isHit and not target.config.is_summoned then
      buff0.shield = skillatk4basicshield + skillatk4bonusshield
    end
    caster:addBuff(buff0, caster)
  end
  return isHit, dmg, Crit, lfs_amount
end

function TitanVM.init_hero(hero)
  local skillult = hero.skills.TitanVM_ult
  local skillults = hero.skills.TitanVM_ults
  local skillatk2 = hero.skills.TitanVM_atk2
  local skillatk3 = hero.skills.TitanVM_atk3
  local skillatk3s = hero.skills.TitanVM_atk3s
  local skillatk4 = hero.skills.TitanVM_atk4
  if skillult then
    skillult.start = override(skillult.start, TitanVM.skillult_start)
    skillult.finish = override(skillult.finish, TitanVM.skillult_finish)
    skillult.onAttackFrame = override(skillult.onAttackFrame, TitanVM.skillult_onAttackFrame)
    skillult.createBuff = override(skillult.createBuff, TitanVM.skillult_createBuff)
    if skillult.evo_rank and skillult.evo_rank >= 1 and skillults then
      skillults.info = ed.wraptable(skillults.info, {
        ["Plus Ratio"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 and skillults then
      skillults.info = ed.wraptable(skillults.info, {
        ["Plus Ratio"] = skillult.evo_rank2["Script Arg1"]
      })
    end
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, TitanVM.skillatk2_takeEffectOn)
    if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
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
    skillatk3.createBuff = override(skillatk3.createBuff, TitanVM.skillatk3_createBuff)
    if skillatk3s then
      if skillatk3.evo_rank and skillatk3.evo_rank >= 1 then
        skillatk3s.info = ed.wraptable(skillatk3s.info, {
          ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
        })
      end
      if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
        skillatk3s.info = ed.wraptable(skillatk3s.info, {
          ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
        })
      end
    end
  end
  if skillatk4 then
    if skillatk4.evo_rank and skillatk4.evo_rank >= 1 then
      skillatk4.info = ed.wraptable(skillatk4.info, {
        ["Plus Ratio"] = skillatk4.evo_rank1["Script Arg1"]
      })
    end
    skillatk4.takeEffectOn = override(skillatk4.takeEffectOn, TitanVM.skillatk4_takeEffectOn)
  end
  return hero
end

return TitanVM.init_hero

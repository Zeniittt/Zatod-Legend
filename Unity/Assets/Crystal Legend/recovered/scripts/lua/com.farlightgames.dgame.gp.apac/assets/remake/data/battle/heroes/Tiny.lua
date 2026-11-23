module("ed.battlehero", package.seeall)
local ed = ed
Tiny = {}
Tiny.Evobuff = 10002903

function Tiny.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  skill.thrownUnit = skill.target
end

function Tiny.skillult_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  if skill.thrownUnit and skill.thrownUnit.knockup_time <= 0 then
    local unit = skill.thrownUnit
    skill.thrownUnit = nil
    local info = skill.info
    skill.info = ed.wraptable(info, {
      ["Damage Type"] = "AP",
      ["Basic Num"] = info["Script Arg2"],
      ["Plus Ratio"] = info["Script Arg3"],
      ["AOE Origin"] = "target",
      ["Knock Up"] = 0,
      ["Knock Back"] = 0
    })
    skill:takeEffectAt(unit.position)
    skill.info = info
  end
end

function Tiny.skillult_createBuff(basefunc, skill, target)
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

function Tiny.Tiny_takeDamage(basefunc, unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local amount = struct_table
  local skillTags
  if type(struct_table) == "table" then
    damage_type = struct_table.damage_type
    field = struct_table.field
    source = struct_table.source
    coefficient = struct_table.coefficient
    crit_mod = struct_table.crit_mod
    amount = struct_table.amount
    skillTags = struct_table.skillTags
  end
  field = field or "hp"
  coefficient = coefficient or 1
  crit_mod = crit_mod or 1
  local self = unit
  local caster = source
  if not self:isAlive() then
    return 0
  end
  local ratio = 0.3
  local Distance = 200
  if damage_type == "AD" then
    local DSQ = ed.edpDistanceSQ(caster.position, unit.position)
    if DSQ < Distance ^ 2 and ratio > ed.rand() and unit:isAlive() and not caster.buff_effects.uncontrollable and not caster.buff_effects.invulnerable then
      local bid = Tiny.Evobuff
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff = caster:addBuff(binfo, unit)
    end
  end
  return basefunc(unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
end

function Tiny.skillatk3_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if ed.run_with_scene then
    local effect_name = "eff_point_Tiny_atk3.cha"
    if not effect_name then
      return
    end
    local effect_z = -1
    ed.scene:playEffectOnScene(effect_name, {
      caster.position[1] + caster.direction * 100,
      caster.position[2]
    }, {
      caster.direction,
      1
    }, nil, effect_z)
  end
end

function Tiny.skillatk3_createBuff(basefunc, skill, target)
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

function Tiny.init_hero(hero)
  local skillult = hero.skills.Tiny_ult
  local skillatk2 = hero.skills.Tiny_atk2
  local skillatk3 = hero.skills.Tiny_atk3
  local skillpasv = hero.passive_skill_list[1]
  if skillult then
    if skillult.evo_rank and 1 <= skillult.evo_rank then
      skillult.info = ed.wraptable(skillult.info, {
        ["Script Arg3"] = skillult.evo_rank1["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 2 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Script Arg3"] = skillult.evo_rank2["Script Arg1"]
      })
    end
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.createBuff = override(skillult.createBuff, Tiny.skillult_createBuff)
    end
    skillult.onAttackFrame = override(skillult.onAttackFrame, Tiny.skillult_onAttackFrame)
    skillult.update = override(skillult.update, Tiny.skillult_update)
  end
  if skillatk2 then
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
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, Tiny.skillatk3_onAttackFrame)
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank1["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.createBuff = override(skillatk3.createBuff, Tiny.skillatk3_createBuff)
    end
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
      hero.takeDamage = override(hero.takeDamage, Tiny.Tiny_takeDamage)
    end
    hero:rebuild()
  end
  return hero
end

return Tiny.init_hero

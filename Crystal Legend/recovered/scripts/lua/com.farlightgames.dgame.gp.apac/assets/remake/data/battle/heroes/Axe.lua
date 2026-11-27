module("ed.battlehero", package.seeall)
local ed = ed
Axe = {}
Axe.name = "Axe"
Axe.atk3_recoverHpPercent = 0.02

function Axe.skillult_takeEffectOn(basefunc, skill, target, source)
  local killratio = 0.3
  local eliminaterate = 2.5
  local caster = skill.caster
  local skillsawake = caster.skills.Axe_sawake
  local hpremain = target.hp
  local hpratio = hpremain / target.attribs.HP
  local originfo = skill.info
  if skill.evo_rank and skill.evo_rank >= 3 then
    eliminaterate = skill.evo_rank3["Script Arg1"]
  end
  if killratio > hpratio then
    if ed.run_with_scene then
      local effect_name = "eff_point_Axe_ult.cha"
      local effect_z = skill.info["Point Zorder"] or 0
      ed.scene:playEffectOnScene(effect_name, skill.caster.position, {
        skill.caster.direction,
        1
      }, nil, effect_z)
      local color = target.camp == ed.emCampEnemy and "blue" or "red"
      ed.PopupCreate("culling", color, target.actor, true, "text")
    end
    skill.info = ed.wraptable(originfo, {
      ["Knock Up"] = 1,
      ["No Dodge"] = true,
      ["Basic Num"] = originfo["Basic Num"] * eliminaterate,
      ["Plus Ratio"] = originfo["Plus Ratio"] * eliminaterate
    })
  end
  local ret, dmg = basefunc(skill, target, source)
  skill.info = originfo
  if ret and not target:isAlive() and target.killer and target.killer == caster then
    skill.caster:takeHeal(300, "mp", skill.caster)
  end
  return ret, dmg
end

function Axe.skillult_willCast(basefunc, skill)
  local ret = basefunc(skill)
  local killratio = 0.3
  if ret then
    local target = skill.target
    if target and not target.config.is_boss then
      local hpratio = target.hp / target.attribs.HP
      return killratio >= hpratio
    end
    return ret
  end
end

function Axe.takeDamage(basefunc, unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
  local amount = struct_table
  if type(struct_table) == "table" then
    damage_type = struct_table.damage_type
    field = struct_table.field
    source = struct_table.source
    coefficient = struct_table.coefficient
    crit_mod = struct_table.crit_mod
    amount = struct_table.amount
  end
  field = field or "hp"
  coefficient = coefficient or 1
  crit_mod = crit_mod or 1
  local self = unit
  if not self:isAlive() then
    return
  end
  if damage_type == "AD" and unit.atk3_cd_Axe <= 0 then
    local castingSkill = false
    local cur_skill = unit.current_skill
    if cur_skill and cur_skill.info["Skill Name"] == "Axe_atk3" then
      castingSkill = true
    elseif cur_skill then
      local noAF = 0
      for _, phase in ipairs(cur_skill.phase_list) do
        noAF = noAF + #phase.event_list
      end
      if noAF > cur_skill.attack_counter then
        castingSkill = true
      end
    end
    local atkpro = 0.4
    local skillatk3 = unit.skills.Axe_atk3
    if skillatk3 then
      if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
        atkpro = skillatk3.evo_rank3["Script Arg1"] / 100
      end
      if not castingSkill and atkpro > ed.rand() then
        local skillatk3duration = skillatk3.phase_list[1].duration
        skillatk3.cd_remaining = 0
        unit.glcd_recover_Axe = unit.global_cd - skillatk3duration
        unit.global_cd = 0
      end
    end
  end
  return basefunc(unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
end

function Axe.update(basefunc, unit, dt)
  unit.atk3_cd_Axe = unit.atk3_cd_Axe - dt
  basefunc(unit, dt)
end

function Axe.skillatk3_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  local atk3cd = 0.375
  if skill.evo_rank and skill.evo_rank >= 3 then
    atk3cd = skill.evo_rank3["Script Arg2"]
  end
  caster.atk3_cd_Axe = atk3cd
  caster.global_cd = caster.glcd_recover_Axe
  if skill.evo_rank and skill.evo_rank >= 3 then
    local hp_amount = caster.attribs.HP * skill.evo_rank3["Script Arg3"] / 100
    caster:takeHeal(hp_amount, "hp", caster)
  end
end

function Axe.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  local HPR = buffInfo.HPR
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff:setAttribute("HPR", HPR - skill.evo_rank1["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff:setAttribute("HPR", HPR - skill.evo_rank1["Script Arg1"] - skill.evo_rank2["Script Arg1"])
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function Axe.init_hero(hero)
  local skillult = hero.skills.Axe_ult
  local skillatk2 = hero.skills.Axe_atk2
  local skillatk3 = hero.skills.Axe_atk3
  local skillpasv = hero.passive_skill_list[1]
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
    hero:preloadEffect("eff_point_Axe_ult.cha")
    skillult.takeEffectOn = override(skillult.takeEffectOn, Axe.skillult_takeEffectOn)
    skillult.willCast = override(skillult.willCast, Axe.skillult_willCast)
  end
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, Axe.skillatk2_createBuff)
  end
  if skillatk3 then
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
    hero.takeDamage = override(hero.takeDamage, Axe.takeDamage)
    hero.update = override(hero.update, Axe.update)
    hero.atk3_cd_Axe = 0
    skillatk3.finish = override(skillatk3.finish, Axe.skillatk3_finish)
    skillatk3.info["Init CD"] = 999
    skillatk3.info.CD = 999
    skillatk3.cd_remaining = 999
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

return Axe.init_hero

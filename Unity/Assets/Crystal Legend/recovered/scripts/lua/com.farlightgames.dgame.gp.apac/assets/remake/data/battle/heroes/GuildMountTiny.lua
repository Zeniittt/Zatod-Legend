module("ed.battlehero", package.seeall)
local ed = ed
GuildMountTiny = {}
GuildMountTiny.Evobuff = 10035803

function GuildMountTiny.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  skill.thrownUnit = skill.target
end

function GuildMountTiny.skillult_update(basefunc, skill, dt_action, dt_cd)
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

function GuildMountTiny.GuildMountTiny_takeDamage(basefunc, unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
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
    return
  end
  local ratio = 0.4
  local Distance = 800
  if damage_type == "AD" and not transferred then
    local DSQ = ed.edpDistanceSQ(caster.position, unit.position)
    if DSQ < Distance ^ 2 and unit:isAlive() and not caster.buff_effects.untargetable and not caster.buff_effects.invulnerable and type(amount) == "number" and amount and 0 < amount then
      caster:takeDamage(amount * ratio, "AD", "hp", self, 1, 1, true)
      if struct_table.amount then
        struct_table.amount = struct_table.amount * (1 - ratio)
      end
    end
  end
  return basefunc(unit, struct_table, damage_type, field, source, coefficient, crit_mod, transferred)
end

function GuildMountTiny.skillatk3_onAttackFrame(basefunc, skill)
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

function GuildMountTiny.init_hero(hero)
  local skillult = hero.skills.GuildMountTiny_ult
  local skillatk2 = hero.skills.GuildMountTiny_atk2
  local skillatk3 = hero.skills.GuildMountTiny_atk3
  local skillpasv = hero.passive_skill_list[1]
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, GuildMountTiny.skillult_onAttackFrame)
    skillult.update = override(skillult.update, GuildMountTiny.skillult_update)
  end
  if skillatk3 then
    skillatk3.onAttackFrame = override(skillatk3.onAttackFrame, GuildMountTiny.skillatk3_onAttackFrame)
  end
  if skillpasv then
    hero.takeDamage = override(hero.takeDamage, GuildMountTiny.GuildMountTiny_takeDamage)
  end
  return hero
end

return GuildMountTiny.init_hero

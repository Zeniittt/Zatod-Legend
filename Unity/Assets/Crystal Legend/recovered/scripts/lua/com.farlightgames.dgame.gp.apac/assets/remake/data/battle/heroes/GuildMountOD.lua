module("ed.battlehero", package.seeall)
local ed = ed
GuildMountOD = {}
GuildMountOD.INT = 10036102

function GuildMountOD.skillult_takeEffectOn(basefunc, skill, target)
  if target.info["Main Attrib"] == "INT" then
    if ed.run_with_scene then
      local color = target.camp == ed.emCampEnemy and "red" or "blue"
      local str = "immune"
      ed.PopupCreate(str, color, target.actor, nil, "text")
    end
    return false
  else
    local target = target
    local Main_attrib = target.info["Main Attrib"]
    if target and Main_attrib and Main_attrib ~= "INT" then
      local caster = skill.caster
      local caster_INT = caster.attribs.INT
      local target_INT = target.attribs.INT
      if caster_INT and target_INT and caster_INT > target_INT then
        target:takeDamage(caster_INT - target_INT, "Holy", "hp", caster, 1, 1, true)
      end
    end
    return basefunc(skill, target)
  end
end

function GuildMountOD.skillatk2_takeEffectOn(basefunc, skill, target)
  local caster = skill.caster
  local caster_INT = caster.attribs.INT
  local target_INT = target.attribs.INT
  if target and caster_INT and target_INT and caster_INT > target_INT then
    target:takeDamage(caster_INT - target_INT, "Holy", "hp", caster, 1, 1, true)
  end
  return basefunc(skill, target)
end

function GuildMountOD.skillatk3_canCastWithTarget(basefunc, skill, target)
  local enemycount = 0
  local caster = skill.caster
  for unit in ed.engine:foreachAliveUnit(caster.foecamp) do
    if unit then
      enemycount = enemycount + 1
    end
  end
  if enemycount <= 1 then
    enemycount = 0
    return false
  else
    enemycount = 0
    return basefunc(skill, target)
  end
end

function GuildMountOD.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local trans_int = skill.info["Script Arg2"]
  local caster = skill.caster
  local bid = GuildMountOD.INT
  local orin_info = ed.lookupDataTable("Buff", nil, bid)
  local binfo = ed.wraptable(orin_info, {INT = trans_int})
  caster:addBuff(binfo, caster)
  if target then
    if target.info["Main Attrib"] == "INT" then
      local binfo = ed.wraptable(orin_info, {
        INT = -trans_int
      })
      target:addBuff(binfo, caster)
    else
      local binfo = ed.wraptable(orin_info, {
        INT = -trans_int * 1.25
      })
      target:addBuff(binfo, caster)
    end
  end
  return buff
end

function GuildMountOD.init_hero(hero)
  local skillult = hero.skills.GuildMountOD_ult
  local skillatk2 = hero.skills.GuildMountOD_atk2
  local skillatk3 = hero.skills.GuildMountOD_atk3
  local skillpasv = hero.passive_skill_list[1]
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, GuildMountOD.skillult_takeEffectOn)
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, GuildMountOD.skillatk2_takeEffectOn)
  end
  if skillatk3 then
    skillatk3.createBuff = override(skillatk3.createBuff, GuildMountOD.skillatk3_createBuff)
    skillatk3.canCastWithTarget = override(skillatk3.canCastWithTarget, GuildMountOD.skillatk3_canCastWithTarget)
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

return GuildMountOD.init_hero

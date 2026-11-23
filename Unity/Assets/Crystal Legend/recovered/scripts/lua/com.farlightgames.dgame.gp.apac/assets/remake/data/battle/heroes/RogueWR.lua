module("ed.battlehero", package.seeall)
local ed = ed
RogueWR = {}
RogueWR.fashion_id_1 = 111
RogueWR.hast = 200

function RogueWR.getValue(arrow, target0, target1)
  local Sub = ed.edpSub
  local Dot = ed.edpDot
  local Normalize = ed.edpNormalize
  local LengthSQ = ed.edpLengthSQ
  local pos0 = target0.position
  local pos1 = target1.position
  local vector01 = Sub(pos1, pos0)
  local vdir = Normalize(arrow.velocity)
  local lengthSQ_vector01 = LengthSQ(vector01)
  local dot_vector01_vdir = Dot(vector01, vdir)
  local cos = dot_vector01_vdir / lengthSQ_vector01 ^ 0.5
  if cos < 0.994 then
    return -1
  end
  local factor = 10
  local value = factor * lengthSQ_vector01 - (factor - 1) * dot_vector01_vdir ^ 2
  return value
end

function RogueWR.skillatk2_takeEffectOn(basefunc, skill, target, source)
  local caster = skill.caster
  local min = 9999999999
  local target1
  for unit in ed.engine:foreachAliveUnit(skill:targetCamp()) do
    if unit.buff_effects.untargetable then
    elseif unit.buffManager.invisible and unit.camp ~= caster.camp then
    elseif unit == target then
    else
      local value = RogueWR.getValue(source, target, unit)
      if value < 0 or ed.edpDistanceSQ(target.position, unit.position) > 48400 then
      elseif min > value then
        min = value
        target1 = unit
      end
    end
  end
  if target1 then
    skill.double = true
    basefunc(skill, target, source)
    basefunc(skill, target1, source)
    local tempSkill = ed.wraptable(skill, {
      caster = target,
      target = target1,
      takeEffectOn = function()
      end,
      launchPoint = function()
        return target.position, 48
      end,
      ["Chain Jumps"] = 0
    })
    ed.ChainCreate(tempSkill)
  else
    skill.double = false
    basefunc(skill, target, source)
  end
end

function RogueWR.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  buff:setAttribute("Effect", "eff_buff_WR_atk2_fashion_1.cha")
  if not skill.double then
    if skill.evo_rank and skill.evo_rank >= 1 then
      buff.timer = skill.evo_rank1["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
    else
      buff.timer = 0.6 * math.max(0.01, 1 - TEN_final / 100)
    end
  elseif skill.evo_rank and skill.evo_rank >= 3 then
    buff.timer = skill.evo_rank3["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  return buff
end

function RogueWR.skillatk3_power(basefunc, skill, source, target, damage_type)
  local power, i = basefunc(skill, source, target, damage_type)
  local caster = skill.caster
  local info = skill.info
  if skill.evo_rank and skill.evo_rank >= 1 then
    local ap_multiplier = skill.evo_rank1["Script Arg1"]
    local ap_attrib = caster.attribs.AP or 0
    power = power + ap_multiplier * ap_attrib
  end
  return power, i
end

function RogueWR.hero_reset(basefunc, hero)
  local skillatk2 = hero.skills.RogueWR_atk2
  local skillatk = hero.skills.RogueWR_atk
  local skillult = hero.skills.RogueWR_ult
  if skillatk then
    local originfo1 = skillatk.info
    skillatk.info = ed.wraptable(originfo1, {
      ["Tile Art"] = "eff_tile_WR_atk_fashion_1.cha"
    })
  end
  basefunc(hero)
end

function RogueWR.init_hero(hero)
  local skillult = hero.skills.RogueWR_ult
  local skillatk2 = hero.skills.RogueWR_atk2
  local skillatk3 = hero.skills.RogueWR_atk3
  local skillpasv = hero.passive_skill_list[1]
  if skillult then
    local plusratio = skillult.info["Plus Ratio"]
    skillult.info = ed.wraptable(skillult.info, {
      ["Plus Ratio"] = plusratio,
      ["Tile Art"] = "eff_tile_WR_ult_fashion_1.cha"
    })
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
    if skillult.evo_rank and skillult.evo_rank >= 3 then
      skillult.info = ed.wraptable(skillult.info, {
        ["Plus Ratio"] = skillult.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillatk2 then
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, RogueWR.skillatk2_takeEffectOn)
    skillatk2.createBuff = override(skillatk2.createBuff, RogueWR.skillatk2_createBuff)
    local plusratio = skillatk2.info["Plus Ratio"]
    skillatk2.info = ed.wraptable(skillatk2.info, {
      ["Plus Ratio"] = plusratio,
      ["Chain Effect"] = "eff_chain_WR_atk2_fashion_1.cha"
    })
    if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
      skillatk2.info = ed.wraptable(skillatk2.info, {
        ["Plus Ratio"] = skillatk2.evo_rank2["Script Arg1"]
      })
    end
  end
  if skillatk3 then
    local plusratio = skillatk3.info["Plus Ratio"]
    skillatk3.info = ed.wraptable(skillatk3.info, {
      ["Plus Ratio"] = plusratio,
      ["Tile Art"] = "eff_tile_WR_atk_fashion_1.cha"
    })
    if skillatk3.evo_rank and 1 <= skillatk3.evo_rank then
      skillatk3.power = override(skillatk3.power, RogueWR.skillatk3_power)
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 2 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank2["Script Arg1"]
      })
    end
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
      })
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
      skillpasv["Basic Num"] = skillpasv["Basic Num"] + skillpasv.evo_rank3["Script Arg1"]
    end
    hero:rebuild()
  end
  hero.reset = override(hero.reset, RogueWR.hero_reset)
  return hero
end

return RogueWR.init_hero

module("ed.battlehero", package.seeall)
local ed = ed
Flood = {}

function Flood.skillult_takeEffectOn(basefunc, skill, target, source, shift)
  local caster = skill.caster
  if skill.attack_counter == 1 and ed.run_with_scene and target and target.actor then
    local name = "eff_impact_Flood_ult.cha"
    if name and target.actor then
      local effect_z = 1
      target.actor:addEffect(name, effect_z)
    end
  end
  if skill.attack_counter == 2 then
    local isHit, dmg = basefunc(skill, target, source, shift)
    if isHit and dmg and 0 < dmg then
      caster:takeHeal(dmg, "hp", caster)
      if ed.run_with_scene then
        local name = "eff_point_Flood_ult.cha"
        local origin = caster.position
        ed.scene:playEffectOnScene(name, origin, {
          caster.direction,
          1
        }, nil, 1)
      end
    end
    return isHit, dmg
  end
end

function Flood.skillatk2_takeEffectOn(basefunc, skill, target, source)
  basefunc(skill, target, source)
  local caster = skill.caster
  if target then
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.info.ID == 10007001 then
        local bid = 10007002
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = target:addBuff(binfo, caster)
        buff.timer = tbuff.timer
        break
      end
    end
  end
end

function Flood.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  local buffInfo = buff.info
  local attribName = buffInfo.Tenacity
  local TEN_final = ed.Buff.getTenValue(buffInfo, owner, caster)
  if skill.evo_rank and skill.evo_rank >= 1 then
    buff.timer = buff.timer + skill.evo_rank1["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 2 then
    buff.timer = buff.timer + skill.evo_rank2["Script Arg1"] * math.max(0.01, 1 - TEN_final / 100)
  end
  if skill.evo_rank and skill.evo_rank >= 3 then
    local HPR = buff.info.HPR
    buff:setAttribute("HPR", HPR - skill.evo_rank3["Script Arg1"])
  end
  return buff
end

function Flood.hero_die(basefunc, hero, killer)
  if hero.batList then
    for i, tBat in ipairs(hero.batList) do
      if tBat:isAlive() then
        tBat:die()
      end
    end
  end
  hero.batList = {}
  basefunc(hero, killer)
end

function Flood.bat_takeDamage(basefunc, self, struct_table, damage_type, field, source, coefficient, crit_mod)
  local dmg = basefunc(self, struct_table, damage_type, field, source, coefficient, crit_mod)
  if dmg and 0 < dmg and self.father and self.father:isAlive() then
    self.father:takeHeal(dmg, "hp", self.father)
  end
  return dmg
end

function Flood.hero_handleUnitDieEvent(basefunc, self, unit, killer_unit)
  basefunc(self, unit, killer_unit)
  for i, tbuff in ipairs(unit.buff_list) do
    if tbuff.info.ID == 10007001 then
      local caster = tbuff.caster
      local skillatk2 = caster.skills.Flood_atk2
      if skillatk2 and caster == self then
        local proto = {
          _tid = 168,
          _level = caster.skills.Flood_atk2.level or 1,
          _stars = caster.stars,
          _rank = caster.rank
        }
        local config = {
          is_monster = true,
          estimate_rank = true,
          hp_mod = caster.config.hp_mod or 1,
          dps_mod = caster.config.dps_mod or 1
        }
        local Bat = ed.UnitCreate(proto, caster.camp, config)
        Bat.father = caster
        Bat.takeDamage = override(Bat.takeDamage, Flood.bat_takeDamage)
        Bat.direction = caster.direction
        local locationBat = {
          unit.position[1],
          unit.position[2] - 1
        }
        ed.engine:summonUnit(Bat, locationBat, caster)
        table.insert(caster.batList, Bat)
        local Bat2attribs = skillatk2.info["Script Arg2"] / 100
        local AttriBid = 10007004
        local AttriBinfo = ed.lookupDataTable("Buff", nil, AttriBid)
        Flood.changeBuffInfo(AttriBinfo, Bat2attribs, Bat)
        local buff = Bat:addBuff(AttriBinfo, caster)
        Bat:takeHeal(Bat.attribs.HP, "hp")
        if ed.run_with_scene then
          ed.scene:playEffectOnScene("eff_impact_Flood_atk2.cha", {
            unit.position[1],
            unit.position[2] - 2
          }, {
            unit.direction,
            1
          }, nil, 0)
        end
        local bid = 10007003
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff = unit:addBuff(binfo, caster)
        unit:removeBuff(tbuff)
        break
      end
    end
  end
end

function Flood.changeBuffInfo(buffInfo, enhance, target)
  local attrib_temp = {}
  local summoner = target.config.summoner
  for _, name in ipairs(ed.attrib_names) do
    local value = buffInfo[name] or 0
    local ele = buffInfo[name .. ".x"]
    if value ~= 0 or ele then
      attrib_temp[name] = true
    end
  end
  for name, _ in pairs(attrib_temp) do
    local x = buffInfo[name .. ".x"]
    if x then
      buffInfo[name .. ".a"] = enhance
      if name == "HP" and ed.engine.rogue_mode and target.camp == ed.emCampEnemy and (summoner.config.is_monster or summoner.config.is_boss) then
        buffInfo[name .. ".a"] = buffInfo[name .. ".a"] / target.config.hp_mod
      end
    end
  end
end

function Flood.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.batList = {}
end

function Flood.hero_true_init(hero)
  hero.reset = override(hero.reset, Flood.hero_reset)
  hero.die = override(hero.die, Flood.hero_die)
  hero.handleUnitDieEventToAll = override(hero.handleUnitDieEventToAll, Flood.hero_handleUnitDieEvent)
  local skillult = hero.skills.Flood_ult
  local skillatk2 = hero.skills.Flood_atk2
  local skillatk3 = hero.skills.Flood_atk3
  local skillpasv = hero.passive_skill_list[1]
  if skillult then
    skillult.takeEffectOn = override(skillult.takeEffectOn, Flood.skillult_takeEffectOn)
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
    skillatk2.takeEffectOn = override(skillatk2.takeEffectOn, Flood.skillatk2_takeEffectOn)
    skillatk2.createBuff = override(skillatk2.createBuff, Flood.skillatk2_createBuff)
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
    if skillatk3.evo_rank and skillatk3.evo_rank >= 3 then
      skillatk3.info = ed.wraptable(skillatk3.info, {
        ["Plus Ratio"] = skillatk3.evo_rank3["Script Arg1"]
      })
    end
  end
  if skillpasv then
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

function Flood.init_hero(hero)
  Flood.hero_true_init(hero)
  return hero
end

return Flood.init_hero

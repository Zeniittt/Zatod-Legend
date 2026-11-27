module("ed.battlehero", package.seeall)
local ed = ed
ChessNPC = {}
ChessNPC.name = "ChessNPC"
ChessNPC.fieldBasicBuffId = 1071
ChessNPC.requireLuaSuffixList = {}
ChessNPC.minX = ed.engine.stage_rect.minX
ChessNPC.minY = ed.engine.stage_rect.minY
ChessNPC.maxX = ed.engine.stage_rect.maxX
ChessNPC.maxY = ed.engine.stage_rect.maxY
ChessNPC.empty_buffID = 233
ChessNPC.human_buffID = 6026
ChessNPC.troll_buffID = 6032
ChessNPC.element_buffID = 6051
ChessNPC.knight_shieldbuffID = 6054
ChessNPC.orge_buffID = 6036
ChessNPC.orge_ragebuffID = 6058
ChessNPC.assassin_disappearbuffID = 6059
ChessNPC.assassin_appearbuffID = 6060
ChessNPC.assassin_emptybuffID = 6061
ChessNPC.orkStep2_buffID = 6072
ChessNPC.shaman_sheep_buffID = 6073
ChessNPC.assassin_crit_buffID = 6078

local function isValidCondition(info, tag, value)
  if not info or not info["Affected Tag"] then
    return false
  end
  local affectTag = info["Affected Tag"]
  local tagCount = info["Tag Count"]
  if tag == affectTag and info["Skill Name"] ~= "ChessNPC_atk" and value >= tagCount[1] and value <= tagCount[2] then
    return true
  end
  return false
end

function ChessNPC.activeSkillList(ed, field)
  for _, list in ipairs({
    field.ChessNPC_RaceTaglist,
    field.ChessNPC_AbilityTaglist
  }) do
    for tag, value in pairs(list) do
      for i, skill in ipairs(field.skill_list) do
        local info = skill.info
        if isValidCondition(info, tag, value) then
          skill:selectTarget()
          local aoe = skill.info["AOE Origin"]
          if aoe or skill.target then
            skill:takeEffectAt(field.position, field)
          end
        end
      end
    end
  end
  print("------------------------------dyncSkillLists-----------------------------------")
  for k, skillID in ipairs(field.dyncSkillLists or {}) do
    for i, skill in ipairs(field.skill_list) do
      local info = skill.info
      if info["Skill Group ID"] == skillID then
        skill:selectTarget()
        local aoe = skill.info["AOE Origin"]
        if aoe or skill.target then
          print("takeEffectAt Skill Id " .. skillID)
          skill:takeEffectAt(field.position, field)
        end
      end
    end
  end
end

function ChessNPC.ChessNPC_reset(basefunc, field)
  basefunc(field)
  local list = ed.engine:getChessTagData(field.camp)
  field.ChessNPC_RaceTaglist = list.race
  field.ChessNPC_AbilityTaglist = list.ability
  for unit in ed.engine:foreachAliveUnit(field.camp) do
    local info = unit.info["Ability Tag"]
    for i, tag in ipairs(info) do
      if tag == "assassin" then
        unit.ChessNPC_origin_pos = {
          unit.position[1],
          unit.position[2]
        }
        local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.assassin_emptybuffID)
        local bbuff = ed.BuffCreate(binfo, unit, field)
        bbuff.onRemoved = override(bbuff.onRemoved, ChessNPC.skillAssassion_emptybuffonRemoved)
        unit:addBuff(bbuff, field)
      end
    end
  end
  ChessNPC.activeSkillList(ed, field)
  field.position = {
    (ChessNPC.minX + ChessNPC.maxX) / 2,
    0
  }
  field:addBuff(ed.lookupDataTable("Buff", nil, ChessNPC.fieldBasicBuffId), field)
  field.silencetime = 10
end

function ChessNPC.skillAssassion_emptybuffonRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.owner
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.assassin_disappearbuffID)
  local bbuff = ed.BuffCreate(binfo, hero, buff.caster)
  bbuff.onRemoved = override(bbuff.onRemoved, ChessNPC.skillAssassion_buffonRemoved)
  hero:addBuff(bbuff, buff.caster)
end

function ChessNPC.collectSkillHit(basefunc, unit, caster, skill, target)
  basefunc(unit, caster, skill, target)
  if caster and target and target:isAlive() and caster.ChessNPC_human_perc and ed.rand() <= caster.ChessNPC_human_perc and skill == caster.basic_skill then
    local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.human_buffID)
    target:addBuff(binfo, unit)
  end
end

function ChessNPC.skillHuman_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Race = target.info["Race Tag"]
  if Race then
    for i, tag in ipairs(Race) do
      if tag == "human" then
        buff.owner.ChessNPC_human_perc = skill.info["Script Arg2"]
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.skillGoblin1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Race = target.info["Race Tag"]
  if Race then
    for i, tag in ipairs(Race) do
      if tag == "goblin" then
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.skillGoblin2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local temp = table.remove(skill.ChessNPC_randomlist)
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  if temp <= 3 then
    return buff
  else
    return binfo
  end
end

function ChessNPC.skillElf_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Race = target.info["Race Tag"]
  if Race then
    for i, tag in ipairs(Race) do
      if tag == "elf" then
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.skillTroll1_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Race = target.info["Race Tag"]
  if Race then
    for i, tag in ipairs(Race) do
      if tag == "troll" then
        buff.ChessNPC_trollLv = skill.ChessNPC_trollLv
        buff.ChessNPC_Troll_hp = target and target.hp or 0
        buff.update = override(buff.update, ChessNPC.Troll_buff_update)
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.skillTroll2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Race = target.info["Race Tag"]
  if Race then
    for i, tag in ipairs(Race) do
      if tag == "troll" then
        buff.ChessNPC_trollLv = skill.ChessNPC_trollLv
        buff.ChessNPC_Troll_hp = target and target.hp or 0
        buff.update = override(buff.update, ChessNPC.Troll_buff_update)
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.skillTroll3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Race = target.info["Race Tag"]
  if Race then
    for i, tag in ipairs(Race) do
      if tag == "troll" then
        buff.ChessNPC_trollLv = skill.ChessNPC_trollLv
        buff.ChessNPC_Troll_hp = target and target.hp or 0
        buff.update = override(buff.update, ChessNPC.Troll_buff_update)
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.Troll_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.owner.hp ~= buff.ChessNPC_Troll_hp then
    buff.ChessNPC_Troll_hp = buff.owner.hp
    local hp_pres = buff.owner.hp
    local hp_prev = buff.owner.attribs.HP
    local plus_ratio = (1 - math.min(math.max(hp_pres / hp_prev - 0.3, 0), 0.7) / 0.7) * (10 + buff.ChessNPC_trollLv * 10) + 10 + buff.ChessNPC_trollLv * 10
    buff:setAttribute("HAST", plus_ratio)
    buff:setAttribute("MSPD", plus_ratio)
    buff.owner:rebuild()
  end
end

function ChessNPC.skillDragon1_takeEffectOn(basefunc, skill, target, source, shift)
  local out, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  if out and target and target:isAlive() then
    local Race = target.info["Race Tag"]
    if Race then
      for i, tag in ipairs(Race) do
        if tag == "dragon" then
          target.mp = 300
        end
      end
    end
  end
  return out, dmg, Crit, lfs_amount
end

function ChessNPC.skillDragon2_takeEffectOn(basefunc, skill, target, source, shift)
  local out, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  if out and target and target:isAlive() then
    local Race = target.info["Race Tag"]
    if Race then
      for i, tag in ipairs(Race) do
        if tag == "dragon" then
          target.mp = 600
        end
      end
    end
  end
  return out, dmg, Crit, lfs_amount
end

function ChessNPC.skillTitan_takeEffectOn(basefunc, skill, target, source, shift)
  local out, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local titan_counter = skill.caster.ChessNPC_titan_counter
  local ability_ratio = math.floor(titan_counter / 2)
  if ability_ratio < 2 then
    return false
  end
  return out, dmg, Crit, lfs_amount
end

function ChessNPC.skillTitan_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local titan_counter = skill.caster.ChessNPC_titan_counter
  local ability_ratio = math.floor(titan_counter / 2)
  buff:setAttribute("HAST", math.min(10 * ability_ratio, 100))
  buff:setAttribute("MPRatio", 10 * ability_ratio)
  buff:setAttribute("MPGainRatio", 10 * ability_ratio)
  buff.owner:rebuild()
  return buff
end

function ChessNPC.skillOrge_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Race = target.info["Race Tag"]
  if Race then
    for i, tag in ipairs(Race) do
      if tag == "orge" then
        target.ChessNPC_orgeDying = true
        target.onDying = override(target.onDying, ChessNPC.skillOrge_onDying)
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.skillOrge_onDying(basefunc, unit, skiller)
  basefunc(unit, skiller)
  if unit.ChessNPC_orgeDying then
    for unit in ed.engine:foreachAliveUnit(unit.camp) do
      for i, tag in ipairs(unit.info["Race Tag"]) do
        if tag == "orge" then
          local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.orge_ragebuffID)
          unit:addBuff(binfo, unit)
        end
      end
    end
  end
end

function ChessNPC.skillOrk1_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local Race = target.info["Race Tag"]
  if Race then
    for i, tag in ipairs(Race) do
      if tag == "ork" then
        target:takeHeal(2500, "hp", target)
      end
    end
  end
  return ret, dmg, Crit, lfs_amount
end

function ChessNPC.skillOrk2_takeEffectOn(basefunc, skill, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  local Race = target.info["Race Tag"]
  if Race then
    for i, tag in ipairs(Race) do
      if tag == "ork" then
        target:takeHeal(5000, "hp", target)
      end
    end
  end
  return ret, dmg, Crit, lfs_amount
end

function ChessNPC.skillOrk_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Race = target.info["Race Tag"]
  if Race then
    for i, tag in ipairs(Race) do
      if tag == "ork" then
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.skillBeast_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  if target and target:isAlive() then
    buff:setAttribute("AD", target.attribs.AD * skill.info["Script Arg2"])
  end
  return buff
end

function ChessNPC.skillElement_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Race = target.info["Race Tag"]
  if Race then
    for i, tag in ipairs(Race) do
      if tag == "element" then
        buff.onDamaged = override(buff.onDamaged, ChessNPC.element_buff_onDamaged)
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.element_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  if source and source:isAlive() and ed.rand() < 0.3 then
    local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.element_buffID)
    source:addBuff(binfo, buff.owner)
  end
  return damage
end

function ChessNPC.skillMagician_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Ability = target.info["Ability Tag"]
  if Ability then
    for i, tag in ipairs(Ability) do
      if skill.ChessNPC_magicianLv and tag == "magician" then
        local skillult = target.manual_skill
        if skillult then
          skillult.ChessNPC_magicianLv = skill.ChessNPC_magicianLv or 0
          skillult.power = override(skillult.power, ChessNPC.skillMagician_ultPower)
        end
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.skillMagician_ultPower(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  power = power * (1 + 2 ^ (skill.ChessNPC_magicianLv or 0) * 0.1)
  return power, coeff
end

function ChessNPC.skillAssassin_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Ability = target.info["Ability Tag"]
  if Ability then
    for i, tag in ipairs(Ability) do
      if tag == "assassin" then
        local temp = 0
        if skill.ChessNPC_assassinLv == 1 then
          temp = 1
        elseif skill.ChessNPC_assassinLv == 2 then
          temp = 100
        elseif skill.ChessNPC_assassinLv == 3 then
          temp = 200
        end
        local basicskill = target.basic_skill
        buff.ChessNPC_assassinLv = skill.ChessNPC_assassinLv
        buff.onDamaged = override(buff.onDamaged, ChessNPC.assassin_buff_onDamaged)
        buff:setAttribute("CSD", temp)
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.assassin_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local hero = buff.owner
  local immunity = 0
  if damage_type == "AD" then
    immunity = hero.attribs.PIMU or 0
  elseif damage_type == "AP" then
    immunity = hero.attribs.MIMU or 0
  elseif damage_type == "Holy" then
    immunity = 0
  else
    immunity = immunity + hero.attribs.ALLIMU
  end
  local lost = hero:getLostHPAfterImmunity(damage, immunity, damage_type, source)
  if hero.hp - lost < hero.attribs.HP * (0.1 + 0.1 * buff.ChessNPC_assassinLv) then
    local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.assassin_crit_buffID)
    local cbuff = ed.BuffCreate(binfo, hero, hero)
    cbuff.timer = 3
    hero:addBuff(cbuff, hero)
  end
  return damage
end

function ChessNPC.skillAssassion_buffonRemoved(basefunc, buff)
  basefunc(buff)
  local hero = buff.owner
  hero.position[1] = math.min(780, math.max(400 + (400 - hero.ChessNPC_origin_pos[1] + 20), 20))
  hero.position[2] = hero.ChessNPC_origin_pos[2]
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.assassin_appearbuffID)
  hero:addBuff(binfo, buff.caster)
end

function ChessNPC.skillMechanic_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Ability = target.info["Ability Tag"]
  local add_buff = false
  if Ability then
    for i, tag in ipairs(Ability) do
      if tag == "mechanic" then
        add_buff = true
      end
    end
  end
  if add_buff then
    buff.ChessNPC_mechanicLv = skill.ChessNPC_mechanicLv
    buff.onRemoved = override(buff.onRemoved, ChessNPC.mechanic_buff_onRemoved)
    return buff
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.mechanic_buff_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local owner = buff.owner
  if caster then
    local skillbomb = caster.skills.ChessNPC_MechanicBomb
    if skillbomb then
      skillbomb:takeEffectAt(owner.position, owner)
      if ed.run_with_scene and ed.engine.alive_enemy_count > 0 and 0 < ed.engine.alive_alliance_count and 0 < ed.engine.time_limit then
        local effect_name = "eff_point_explode.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, owner.position, {
            owner.direction * 0.75,
            0.75
          }, nil, 1)
        end
      end
    end
    owner.ChessMec_goblin = {}
    for i = 1, 2 do
      local proto = {
        _tid = 50201,
        _level = skillbomb.level or 1,
        _stars = owner.chess_stars,
        _rank = owner.rank,
        _fashion = {
          _current_fashion = owner.fashion_id
        }
      }
      local config = {
        is_monster = true,
        estimate_rank = true,
        hp_mod = owner.config.hp_mod,
        dps_mod = owner.config.dps_mod
      }
      local gob = ed.ChessUnitCreate(proto, owner.camp, config)
      local gobskillatk = gob.skills.PCKjr_atk
      gob.onDying = override(gob.onDying, ChessNPC.mechanic_goblin_onDying)
      if gobskillatk then
        gobskillatk.start = override(gobskillatk.start, ChessNPC.mechanic_gobskillatk_start)
      end
      gob.ChessNPC_goblin_caster = caster
      gob.direction = owner.direction
      local gob_location = {
        owner.position[1],
        owner.position[2]
      }
      if owner then
        ed.engine:summonUnit(gob, gob_location, owner, "Idle")
        table.insert(owner.ChessMec_goblin, gob)
      end
    end
  end
end

function ChessNPC.mechanic_gobskillatk_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
  if caster and caster:isAlive() then
    caster:onDying(caster)
  end
end

function ChessNPC.mechanic_goblin_onDying(basefunc, unit, skiller)
  basefunc(unit, skiller)
  local caster = unit.ChessNPC_goblin_caster
  if caster and caster:isAlive() then
    local skillbomb = caster.skills.ChessNPC_MechanicBomb
    if skillbomb then
      skillbomb:takeEffectAt(unit.position, caster)
      if ed.run_with_scene and ed.engine.alive_enemy_count > 0 and 0 < ed.engine.alive_alliance_count and 0 < ed.engine.time_limit then
        local effect_name = "eff_point_explode.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, unit.position, {
            unit.direction * 0.75,
            0.75
          }, nil, 1)
        end
      end
    end
  end
end

function ChessNPC.skillHunter_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Ability = target.info["Ability Tag"]
  if Ability then
    for i, tag in ipairs(Ability) do
      if tag == "hunter" then
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.skillKnight_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Ability = target.info["Ability Tag"]
  if Ability then
    for i, tag in ipairs(Ability) do
      if tag == "knight" then
        buff.ChessNPC_knightLv = skill.ChessNPC_knightLv
        buff.onDamaged = override(buff.onDamaged, ChessNPC.knight_buff_onDamaged)
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.knight_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  if type(struct_table) == "table" then
    source = struct_table.source
  end
  local knight_counter = 0
  for unit in ed.engine:foreachAliveUnit(buff.owner.camp) do
    local Ability = unit.info["Ability Tag"]
    if Ability then
      for i, tag in ipairs(Ability) do
        if tag == "knight" and unit ~= buff.owner then
          local distanceX = math.abs(unit.position[1] - buff.owner.position[1])
          local distanceY = math.abs(unit.position[2] - buff.owner.position[2])
          if distanceX < 160 and distanceY < 60 then
            knight_counter = math.min(1, knight_counter + 1)
          end
        end
      end
    end
  end
  local dr_base = (buff.ChessNPC_knightLv or 1) * 0.1 + 0.05
  local dr_plus = 2 ^ ((buff.ChessNPC_knightLv or 1) - 1) * 0.05 * knight_counter
  local damage_return = damage * (dr_base + dr_plus)
  damage = damage * (1 - dr_base - dr_plus)
  if skill then
    local attack_range = skill.info["Max Range"]
    if attack_range < 200 and source and source:isAlive() then
      source:takeDamage(damage_return, "Holy", "hp", buff.owner)
    end
  end
  return damage
end

function ChessNPC.skillWarrior_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Ability = target.info["Ability Tag"]
  if Ability then
    for i, tag in ipairs(Ability) do
      if tag == "warrior" then
        target.ChessNPC_warrior_hpdown = false
        buff.ChessNPC_warriorLv = skill.ChessNPC_warriorLv or 0
        buff.update = override(buff.update, ChessNPC.warrior_buff_update)
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.warrior_buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local hero = buff.owner
  local hero_hp = hero.hp / hero.attribs.HP
  if hero_hp < 0.5 and not hero.ChessNPC_warrior_hpdown then
    hero.ChessNPC_warrior_hpdown = true
    local ad_ratio = 0
    if buff.ChessNPC_warriorLv then
      if buff.ChessNPC_warriorLv == 1 then
        ad_ratio = 0.1
      elseif buff.ChessNPC_warriorLv == 2 then
        ad_ratio = 0.25
      elseif buff.ChessNPC_warriorLv == 3 then
        ad_ratio = 0.5
      end
    end
    buff:setAttribute("AD", hero.attribs.AD * ad_ratio)
    buff.owner:rebuild()
  elseif 0.5 <= hero_hp and hero.ChessNPC_warrior_hpdown then
    hero.ChessNPC_warrior_hpdown = false
    buff:setAttribute("AD", 0)
    buff.owner:rebuild()
  end
end

function ChessNPC.skillGuard_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local Ability = target.info["Ability Tag"]
  if Ability then
    for i, tag in ipairs(Ability) do
      if tag == "guard" then
        local caster = skill.caster
        local GuardBoom = caster.skills.ChessNPC_GuardBoom
        if GuardBoom then
          buff.onRemoved = override(buff.onRemoved, ChessNPC.GuardBoom_onRemoved)
        end
        return buff
      end
    end
  end
  local binfo = ed.lookupDataTable("Buff", nil, ChessNPC.empty_buffID)
  return binfo
end

function ChessNPC.GuardBoom_onRemoved(basefunc, buff)
  local owner = buff.owner
  local caster = buff.caster
  local GuardBoomeffect = caster.skills.ChessNPC_GuardBoomeffect
  if owner.canguardboom == true then
    GuardBoomeffect:takeEffectAt(owner.position)
  end
  basefunc(buff)
end

function ChessNPC.skillDemon_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local skillult = target.manual_skill
  if skillult then
    skillult.ChessNPC_demonLv = skill.ChessNPC_demonLv or 0
    skillult.power = override(skillult.power, ChessNPC.skillDemon_ultPower)
  end
  buff:setAttribute("AD", buff.owner.attribs.AD * skill.ChessNPC_demonLv * 0.1)
  return buff
end

function ChessNPC.skillDemon_ultPower(basefunc, skill, source, target, damage_type)
  local power, coeff = basefunc(skill, source, target, damage_type)
  if damage_type == "AP" then
    power = power * (1 + skill.ChessNPC_demonLv * 0.1)
  end
  return power, coeff
end

function ChessNPC.skillThunder_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.thundercd = 20
  buff.update = override(buff.update, ChessNPC.Thunderbuff_update)
  return buff
end

function ChessNPC.Thunderbuff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  buff.thundercd = buff.thundercd - dt
  if buff.thundercd <= 0 then
    for unit in ed.engine:foreachAliveUnit(owner.foecamp) do
      if unit:isAlive() then
        buff.canthunder = true
      end
    end
    if buff.canthunder == true then
      owner:takeDamage(2000, "Holy", "hp", caster)
      if ed.run_with_scene then
        local effect_name = "eff_point_TitanLoong_atk2.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, owner.position, nil, nil, 1)
        end
      end
      buff.thundercd = 20
      buff.canthunder = false
    end
  end
  buff.unremoveable = true
end

function ChessNPC.collectSkill(basefunc, self, unit, skill, idx)
  local skillGainMP = self.skills.ChessNPC_GainMP
  if skillGainMP and unit.cangainmp == true and skill.info.Manual and idx == 1 then
    unit:setMP(unit.mp + 250)
  end
end

function ChessNPC.skillDragonMP_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local Ability = owner.info["Ability Tag"]
  if Ability then
    for i, tag in ipairs(Ability) do
      if tag == "magician" then
        buff:setAttribute("MPR", 50)
      end
    end
  end
  buff.unremoveable = true
  return buff
end

function ChessNPC.skill30HPBoom_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.owner.can30heal = true
  buff.update = override(buff.update, ChessNPC.Boom30buff_update)
  buff.unremoveable = true
  return buff
end

function ChessNPC.Boom30buff_update(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  local caster = buff.caster
  if owner.can30heal == true and owner.hp < owner.attribs.HP * 0.3 then
    local bid = 7047
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = ed.BuffCreate(binfo, owner, caster)
    owner:addBuff(buff, caster)
    owner.can30heal = false
  end
end

function ChessNPC.skillSorenhance_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, ChessNPC.Sorenhance_onDamaged)
  buff.unremoveable = true
  return buff
end

function ChessNPC.Sorenhance_onDamaged(basefunc, buff, damage, damage_type, source)
  local damage = basefunc(buff, damage, damage_type, source)
  if source then
    local Ability = source.info["Ability Tag"]
    if Ability then
      for i, tag in ipairs(Ability) do
        if tag == "sorceress" then
          damage = damage * 1.25
        end
      end
    end
  end
  return damage
end

function ChessNPC.skillSilence_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.owner.silencemark = true
  buff.unremoveable = true
end

function ChessNPC.skillGainMP_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.owner.cangainmp = true
  buff.unremoveable = true
end

function ChessNPC.GuardBoom_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.owner.canguardboom = true
  buff.unremoveable = true
end

function ChessNPC.update(basefunc, self, dt)
  basefunc(self, dt)
  local skillsilence = self.skills.ChessNPC_Silence
  if skillsilence then
    self.silencetime = self.silencetime - dt
    if self.silencetime == 0 then
      for unit in ed.engine:foreachAliveUnit(ed.emCampBoth) do
        if unit.silencemark == true then
          local bid = 7042
          local binfo = ed.lookupDataTable("Buff", nil, bid)
          local buff = ed.BuffCreate(binfo, unit, self)
          buff.onDamaged = override(buff.onDamaged, ChessNPC.silence_onDamaged)
          buff.unremoveable = true
          unit:addBuff(buff, self)
        end
      end
    end
  end
end

function ChessNPC.silence_onDamaged(basefunc, buff, damage, damage_type, source)
  local damage = basefunc(buff, damage, damage_type, source)
  damage = damage * 1.15
  return damage
end

function ChessNPC.init_hero(hero)
  hero.tagList = {}
  hero.setStageSkillId = ChessNPC.setStageSkillId
  hero.reset = override(hero.reset, ChessNPC.ChessNPC_reset)
  hero.update = override(hero.update, ChessNPC.update)
  hero.collectSkillHit = override(hero.collectSkillHit, ChessNPC.collectSkillHit)
  hero.collectSkill = override(hero.collectSkill, ChessNPC.collectSkill)
  local skillHuman1 = hero.skills.ChessNPC_Human1
  local skillHuman2 = hero.skills.ChessNPC_Human2
  local skillHuman3 = hero.skills.ChessNPC_Human3
  local skillGoblin1 = hero.skills.ChessNPC_Goblin1
  local skillElf1 = hero.skills.ChessNPC_Elf1
  local skillElf2 = hero.skills.ChessNPC_Elf2
  local skillElf3 = hero.skills.ChessNPC_Elf3
  local skillTroll1 = hero.skills.ChessNPC_Troll1
  local skillTroll2 = hero.skills.ChessNPC_Troll2
  local skillTroll3 = hero.skills.ChessNPC_Troll3
  local skillDragon1 = hero.skills.ChessNPC_Dragon1
  local skillDragon2 = hero.skills.ChessNPC_Dragon2
  local skillOrge = hero.skills.ChessNPC_Orge1
  local skillOrk1 = hero.skills.ChessNPC_Ork1
  local skillOrk2 = hero.skills.ChessNPC_Ork2
  local skillBeast1 = hero.skills.ChessNPC_Beast1
  local skillElement1 = hero.skills.ChessNPC_Element1
  local skillMagician1 = hero.skills.ChessNPC_Magician1
  local skillMagician2 = hero.skills.ChessNPC_Magician2
  local skillMagician3 = hero.skills.ChessNPC_Magician3
  local skillAssassin1 = hero.skills.ChessNPC_Assassin1
  local skillAssassin2 = hero.skills.ChessNPC_Assassin2
  local skillAssassin3 = hero.skills.ChessNPC_Assassin3
  local skillMechanic2 = hero.skills.ChessNPC_Mechanic2
  local skillHunter1 = hero.skills.ChessNPC_Hunter1
  local skillHunter2 = hero.skills.ChessNPC_Hunter2
  local skillHunter3 = hero.skills.ChessNPC_Hunter3
  local skillKnight1 = hero.skills.ChessNPC_Knight1
  local skillKnight2 = hero.skills.ChessNPC_Knight2
  local skillWarrior1 = hero.skills.ChessNPC_Warrior1
  local skillWarrior2 = hero.skills.ChessNPC_Warrior2
  local skillWarrior3 = hero.skills.ChessNPC_Warrior3
  local skillGuard1 = hero.skills.ChessNPC_Guard1
  local skillGuard2 = hero.skills.ChessNPC_Guard2
  local skillGuard3 = hero.skills.ChessNPC_Guard3
  local skillDemon1 = hero.skills.ChessNPC_Demon1
  local skillDemon2 = hero.skills.ChessNPC_Demon2
  local skillThunder = hero.skills.ChessNPC_Thunder
  local skillDragonMP = hero.skills.ChessNPC_DragonMP
  local skill30HPBoom = hero.skills.ChessNPC_30HPBoom
  local skillSorenhance = hero.skills.ChessNPC_Sorceressenhance
  local skillSilence = hero.skills.ChessNPC_Silence
  local skillGainMP = hero.skills.ChessNPC_GainMP
  local GuardBoom = hero.skills.ChessNPC_GuardBoom
  if GuardBoom then
    GuardBoom.createBuff = override(GuardBoom.createBuff, ChessNPC.GuardBoom_createBuff)
  end
  if skillGainMP then
    skillGainMP.createBuff = override(skillGainMP.createBuff, ChessNPC.skillGainMP_createBuff)
  end
  if skillHuman1 then
    skillHuman1.createBuff = override(skillHuman1.createBuff, ChessNPC.skillHuman_createBuff)
  end
  if skillHuman2 then
    skillHuman2.createBuff = override(skillHuman2.createBuff, ChessNPC.skillHuman_createBuff)
  end
  if skillHuman3 then
    skillHuman3.createBuff = override(skillHuman3.createBuff, ChessNPC.skillHuman_createBuff)
  end
  if skillGoblin1 then
    skillGoblin1.ChessNPC_randomlist = {}
    skillGoblin1.createBuff = override(skillGoblin1.createBuff, ChessNPC.skillGoblin1_createBuff)
  end
  if skillElf1 then
    skillElf1.createBuff = override(skillElf1.createBuff, ChessNPC.skillElf_createBuff)
  end
  if skillElf2 then
    skillElf2.createBuff = override(skillElf2.createBuff, ChessNPC.skillElf_createBuff)
  end
  if skillElf3 then
    skillElf3.createBuff = override(skillElf3.createBuff, ChessNPC.skillElf_createBuff)
  end
  if skillTroll1 then
    skillTroll1.ChessNPC_trollLv = 1
    skillTroll1.createBuff = override(skillTroll1.createBuff, ChessNPC.skillTroll1_createBuff)
  end
  if skillTroll2 then
    skillTroll2.ChessNPC_trollLv = 2
    skillTroll2.createBuff = override(skillTroll2.createBuff, ChessNPC.skillTroll2_createBuff)
  end
  if skillTroll3 then
    skillTroll3.ChessNPC_trollLv = 3
    skillTroll3.createBuff = override(skillTroll3.createBuff, ChessNPC.skillTroll3_createBuff)
  end
  if skillDragon1 then
    skillDragon1.takeEffectOn = override(skillDragon1.takeEffectOn, ChessNPC.skillDragon1_takeEffectOn)
  end
  if skillDragon2 then
    skillDragon2.takeEffectOn = override(skillDragon2.takeEffectOn, ChessNPC.skillDragon2_takeEffectOn)
  end
  if skillOrge then
    skillOrge.createBuff = override(skillOrge.createBuff, ChessNPC.skillOrge_createBuff)
  end
  if skillOrk1 then
    skillOrk1.takeEffectOn = override(skillOrk1.takeEffectOn, ChessNPC.skillOrk1_takeEffectOn)
    skillOrk1.createBuff = override(skillOrk1.createBuff, ChessNPC.skillOrk_createBuff)
  end
  if skillOrk2 then
    skillOrk2.takeEffectOn = override(skillOrk2.takeEffectOn, ChessNPC.skillOrk2_takeEffectOn)
    skillOrk2.createBuff = override(skillOrk2.createBuff, ChessNPC.skillOrk_createBuff)
  end
  if skillBeast1 then
    skillBeast1.createBuff = override(skillBeast1.createBuff, ChessNPC.skillBeast_createBuff)
  end
  if skillElement1 then
    skillElement1.createBuff = override(skillElement1.createBuff, ChessNPC.skillElement_createBuff)
  end
  if skillMagician1 then
    skillMagician1.ChessNPC_magicianLv = 1
    skillMagician1.createBuff = override(skillMagician1.createBuff, ChessNPC.skillMagician_createBuff)
  end
  if skillMagician2 then
    skillMagician2.ChessNPC_magicianLv = 2
    skillMagician2.createBuff = override(skillMagician2.createBuff, ChessNPC.skillMagician_createBuff)
  end
  if skillMagician3 then
    skillMagician3.ChessNPC_magicianLv = 3
    skillMagician3.createBuff = override(skillMagician3.createBuff, ChessNPC.skillMagician_createBuff)
  end
  if skillAssassin1 then
    skillAssassin1.ChessNPC_assassinLv = 1
    skillAssassin1.createBuff = override(skillAssassin1.createBuff, ChessNPC.skillAssassin_createBuff)
  end
  if skillAssassin2 then
    skillAssassin2.ChessNPC_assassinLv = 2
    skillAssassin2.createBuff = override(skillAssassin2.createBuff, ChessNPC.skillAssassin_createBuff)
  end
  if skillAssassin3 then
    skillAssassin3.ChessNPC_assassinLv = 3
    skillAssassin3.createBuff = override(skillAssassin3.createBuff, ChessNPC.skillAssassin_createBuff)
  end
  if skillMechanic2 then
    skillMechanic2.ChessNPC_mechanicLv = 2
    skillMechanic2.createBuff = override(skillMechanic2.createBuff, ChessNPC.skillMechanic_createBuff)
  end
  if skillHunter1 then
    skillHunter1.createBuff = override(skillHunter1.createBuff, ChessNPC.skillHunter_createBuff)
  end
  if skillHunter2 then
    skillHunter2.createBuff = override(skillHunter2.createBuff, ChessNPC.skillHunter_createBuff)
  end
  if skillHunter3 then
    skillHunter3.createBuff = override(skillHunter3.createBuff, ChessNPC.skillHunter_createBuff)
  end
  if skillKnight1 then
    skillKnight1.ChessNPC_knightLv = 1
    skillKnight1.createBuff = override(skillKnight1.createBuff, ChessNPC.skillKnight_createBuff)
  end
  if skillKnight2 then
    skillKnight2.ChessNPC_knightLv = 2
    skillKnight2.createBuff = override(skillKnight2.createBuff, ChessNPC.skillKnight_createBuff)
  end
  if skillWarrior1 then
    skillWarrior1.ChessNPC_warriorLv = 1
    skillWarrior1.createBuff = override(skillWarrior1.createBuff, ChessNPC.skillWarrior_createBuff)
  end
  if skillWarrior2 then
    skillWarrior2.ChessNPC_warriorLv = 2
    skillWarrior2.createBuff = override(skillWarrior2.createBuff, ChessNPC.skillWarrior_createBuff)
  end
  if skillWarrior3 then
    skillWarrior3.ChessNPC_warriorLv = 3
    skillWarrior3.createBuff = override(skillWarrior3.createBuff, ChessNPC.skillWarrior_createBuff)
  end
  if skillGuard1 then
    skillGuard1.ChessNPC_guardLv = 1
    skillGuard1.createBuff = override(skillGuard1.createBuff, ChessNPC.skillGuard_createBuff)
  end
  if skillGuard2 then
    skillGuard2.ChessNPC_guardLv = 2
    skillGuard2.createBuff = override(skillGuard2.createBuff, ChessNPC.skillGuard_createBuff)
  end
  if skillGuard3 then
    skillGuard3.ChessNPC_guardLv = 3
    skillGuard3.createBuff = override(skillGuard3.createBuff, ChessNPC.skillGuard_createBuff)
  end
  if skillDemon1 then
    skillDemon1.ChessNPC_demonLv = 1
    skillDemon1.createBuff = override(skillDemon1.createBuff, ChessNPC.skillDemon_createBuff)
  end
  if skillDemon2 then
    skillDemon2.ChessNPC_demonLv = 2
    skillDemon2.createBuff = override(skillDemon2.createBuff, ChessNPC.skillDemon_createBuff)
  end
  if skillThunder then
    skillThunder.createBuff = override(skillThunder.createBuff, ChessNPC.skillThunder_createBuff)
  end
  if skillDragonMP then
    skillDragonMP.createBuff = override(skillDragonMP.createBuff, ChessNPC.skillDragonMP_createBuff)
  end
  if skill30HPBoom then
    skill30HPBoom.createBuff = override(skill30HPBoom.createBuff, ChessNPC.skill30HPBoom_createBuff)
  end
  if skillSorenhance then
    skillSorenhance.createBuff = override(skillSorenhance.createBuff, ChessNPC.skillSorenhance_createBuff)
  end
  if skillSilence then
    skillSilence.createBuff = override(skillSilence.createBuff, ChessNPC.skillSilence_createBuff)
  end
  return hero
end

return ChessNPC.init_hero

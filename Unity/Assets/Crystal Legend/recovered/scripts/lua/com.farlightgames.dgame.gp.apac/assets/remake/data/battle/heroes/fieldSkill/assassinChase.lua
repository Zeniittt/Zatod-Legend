module("ed.battlehero", package.seeall)
local ed = ed
assasinChase = {}
assasinChase.kaelId = 53
assasinChase.minX = ed.engine.stage_rect.minX
assasinChase.maxX = ed.engine.stage_rect.maxX
assasinChase.deltaX = 65
assasinChase.invulnerableBuffId = 885
assasinChase.kaelDropHeight = 170
assasinChase.kaelDropTime = 6
assasinChase.kaelDropEffect = "eff_buff_Gambler_ult_highlight.cha"

function assasinChase.extraKael_update(basefunc, unit, dt)
  local ult = unit.skills.Kael_book
  if ult then
    ult.cd_remaining = 9999
  end
  unit.fieldNPC_dropTime = unit.fieldNPC_dropTime + dt
  local time = unit.fieldNPC_dropTime
  if unit.actor and unit:isAlive() and not unit.alreadyDrop then
    local height = time >= assasinChase.kaelDropTime and 0 or (assasinChase.kaelDropTime - time) * assasinChase.kaelDropHeight / assasinChase.kaelDropTime
    unit.actor.height = height
    unit.actor.zSpeed = nil
    if time >= assasinChase.kaelDropTime then
      unit.alreadyDrop = true
      if unit.dropEffect and ed.run_with_scene then
        local new_effect_list = {}
        local effect_list = ed.scene.effect_list
        for i, effect in ipairs(effect_list) do
          if unit.dropEffect and unit.dropEffect == effect then
            effect:removeFromParentAndCleanup(true)
          else
            table.insert(new_effect_list, effect)
          end
        end
        unit.dropEffect = nil
        ed.scene.effect_list = new_effect_list
      end
    end
  end
  local heroCount = 0
  for u in ed.engine:foreachAliveUnit(unit.camp) do
    if not u.config.is_summoned then
      heroCount = heroCount + 1
    end
  end
  if heroCount <= 0 then
    unit:die()
  else
    basefunc(unit, dt)
  end
end

function assasinChase.checkSepcialHero(camp, name, canSummon)
  local specialHero
  for unit in ed.engine:foreachAliveUnit(camp) do
    if not canSummon and unit.config.is_summoned then
    elseif unit.info.Name ~= name then
    else
      specialHero = unit
    end
  end
  if specialHero then
    return true, specialHero
  else
    return false, specialHero
  end
end

function assasinChase.summonKael(camp, field)
  local hpMod = 2
  local dpsMod = 1
  local skillLevel = {
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100,
    100
  }
  local proto = {
    _tid = assasinChase.kaelId,
    _level = 100,
    _stars = 5,
    _skill_levels = skillLevel,
    _rank = 16,
    _arousal = {
      _status = 1,
      _str = 200,
      _int = 200,
      _agi = 200
    }
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = hpMod,
    dps_mod = 3,
    size_mod = 1.6
  }
  local fieldKael = ed.UnitCreate(proto, camp, config)
  fieldKael:reset()
  local summonPosition = {400, 10}
  summonPosition[1] = camp == ed.emCampEnemy and assasinChase.maxX - assasinChase.deltaX or assasinChase.minX + assasinChase.deltaX
  fieldKael.direction = camp == ed.emCampEnemy and -fieldKael.direction or fieldKael.direction
  ed.engine:summonUnit(fieldKael, summonPosition, field)
  local binfo = ed.lookupDataTable("Buff", nil, assasinChase.invulnerableBuffId)
  local buff = fieldKael:addBuff(binfo, field)
  fieldKael.fieldNPC_invulenerableBuff = buff
  fieldKael.fieldNPC_dropTime = 0
  fieldKael.alreadyDrop = false
  fieldKael.global_cd = 6
  local atk = fieldKael.skills.Kael_atk
  if atk then
    local oinfo = atk.info
    atk.info = ed.wraptable(oinfo, {
      ["Max Range"] = 999
    })
    atk.max_range_sq = atk.info["Max Range"] ^ 2
  end
  fieldKael.attack_range = 999
  fieldKael.update = override(fieldKael.update, assasinChase.extraKael_update)
  if ed.run_with_scene then
    local effect = ed.scene:playEffectOnScene(assasinChase.kaelDropEffect, summonPosition, {1, 1}, nil, 1)
    fieldKael.dropEffect = effect
  end
  return fieldKael
end

function assasinChase.skill_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local field = skill.caster
  if skill and skill.cd_remaining <= 0 and not skill.Field_alreadySummonKael then
    skill.Field_alreadySummonKael = true
    local selfCampKael = assasinChase.checkSepcialHero(field.camp, "Kael", false)
    if not selfCampKael then
      local kael = assasinChase.summonKael(field.camp, field)
      ed.engine.enemyKaelHero = kael
    end
    local playerCampKael = assasinChase.checkSepcialHero(-field.camp, "Kael", false)
    if not playerCampKael then
      local kael = assasinChase.summonKael(-field.camp, field)
      ed.engine.playerKaelHero = kael
    end
  end
end

function assasinChase.init_fieldSkill(skill)
  skill.update = override(skill.update, assasinChase.skill_update)
  return skill
end

return assasinChase.init_fieldSkill

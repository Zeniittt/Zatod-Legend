module("ed.battlehero", package.seeall)
local ed = ed
extraKael = {}
extraKael.kaelId = 53
extraKael.minX = ed.engine.stage_rect.minX
extraKael.maxX = ed.engine.stage_rect.maxX
extraKael.deltaX = 65
extraKael.invulnerableBuffId = 885
extraKael.kaelDropHeight = 170
extraKael.kaelDropTime = 6
extraKael.kaelDropEffect = "eff_buff_Gambler_ult_highlight.cha"

function extraKael.extraKael_actor_update(basefunc, actor, dt)
  local unit = actor.model
  if not unit.fieldNPC_alreadyDrop then
    unit.fieldNPC_dropActorTime = unit.fieldNPC_dropActorTime and unit.fieldNPC_dropActorTime + dt or dt
    local unitTime = unit.fieldNPC_dropUnitTime
    local actorTime = unit.fieldNPC_dropActorTime
    local heightPerDt = extraKael.kaelDropHeight / extraKael.kaelDropTime
    local deltaTime = 0 <= actorTime - unitTime and actorTime - unitTime or 0
    local deltaHeight = (actorTime - unitTime) * -heightPerDt
    actor.height = unit.height + deltaHeight
  end
  basefunc(actor, dt)
end

function extraKael.extraKael_update(basefunc, unit, dt)
  unit.fieldNPC_dropUnitTime = unit.fieldNPC_dropUnitTime and unit.fieldNPC_dropUnitTime + dt or dt
  local actor = unit.actor
  if actor and not unit.field_actorOverride then
    unit.field_actorOverride = true
    actor.update = override(actor.update, extraKael.extraKael_actor_update)
  end
  local ult = unit.skills.Kael_book
  if ult then
    ult.cd_remaining = 9999
  end
  local time = unit.fieldNPC_dropUnitTime
  if unit:isAlive() and not unit.fieldNPC_alreadyDrop then
    local height = time >= extraKael.kaelDropTime and 0 or (extraKael.kaelDropTime - time) * extraKael.kaelDropHeight / extraKael.kaelDropTime
    unit.height = height
    if time >= extraKael.kaelDropTime then
      unit.fieldNPC_alreadyDrop = true
      if unit.actor then
        unit.actor.height = unit.height
      end
      if unit.fieldNPC_dropEffect and ed.run_with_scene then
        local new_effect_list = {}
        local effect_list = ed.scene.effect_list
        for i, effect in ipairs(effect_list) do
          if unit.fieldNPC_dropEffect and unit.fieldNPC_dropEffect == effect then
            effect:removeFromParentAndCleanup(true)
          else
            table.insert(new_effect_list, effect)
          end
        end
        unit.fieldNPC_dropEffect = nil
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

function extraKael.extraKael_autoTapBall(basefunc, kael)
  if kael.auto_combat then
    basefunc(kael)
  end
end

function extraKael.checkSepcialHero(camp, name, canSummon)
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

function extraKael.summonKael(camp, field)
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
    _tid = extraKael.kaelId,
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
  summonPosition[1] = camp == ed.emCampEnemy and extraKael.maxX - extraKael.deltaX or extraKael.minX + extraKael.deltaX
  fieldKael.direction = camp == ed.emCampEnemy and -fieldKael.direction or fieldKael.direction
  ed.engine:summonUnit(fieldKael, summonPosition, field)
  fieldKael.displayBall = fieldKael.camp ~= ed.emCampEnemy
  if ed.run_with_scene then
    ed.sceneui.ballPositions = {}
    ed.sceneui.ballPositions[1] = ccp(80, 340)
    ed.sceneui.ballPositions[2] = ccp(80, 340)
    ed.sceneui.ballPositions[3] = ccp(80, 340)
  end
  local binfo = ed.lookupDataTable("Buff", nil, extraKael.invulnerableBuffId)
  local buff = fieldKael:addBuff(binfo, field)
  fieldKael.fieldNPC_invulenerableBuff = buff
  fieldKael.fieldNPC_dropUnitTime = 0
  fieldKael.fieldNPC_dropActorTime = 0
  fieldKael.fieldNPC_alreadyDrop = false
  fieldKael.global_cd = 6
  fieldKael.field_actorOverride = false
  fieldKael.aiMode = false
  local atk = fieldKael.skills.Kael_atk
  if atk then
    local oinfo = atk.info
    atk.info = ed.wraptable(oinfo, {
      ["Max Range"] = 999
    })
    atk.max_range_sq = atk.info["Max Range"] ^ 2
  end
  fieldKael.attack_range = 999
  fieldKael.update = override(fieldKael.update, extraKael.extraKael_update)
  fieldKael.autoTapBall = override(fieldKael.autoTapBall, extraKael.extraKael_autoTapBall)
  if ed.run_with_scene then
    local effect = ed.scene:playEffectOnScene(extraKael.kaelDropEffect, summonPosition, {1, 1}, nil, 1)
    fieldKael.fieldNPC_dropEffect = effect
  end
  return fieldKael
end

function extraKael.skill_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local field = skill.caster
  if skill and skill.cd_remaining <= 0 and not skill.Field_alreadySummonKael then
    skill.Field_alreadySummonKael = true
    local selfCampKael = extraKael.checkSepcialHero(field.camp, "Kael", false)
    if not selfCampKael then
      local kael = extraKael.summonKael(field.camp, field)
      ed.engine.enemyKaelHero = kael
    end
    local playerCampKael = extraKael.checkSepcialHero(-field.camp, "Kael", false)
    if not playerCampKael then
      local kael = extraKael.summonKael(-field.camp, field)
      ed.engine.playerKaelHero = kael
    end
  end
end

function extraKael.init_fieldSkill(skill)
  skill.update = override(skill.update, extraKael.skill_update)
  return skill
end

return extraKael.init_fieldSkill

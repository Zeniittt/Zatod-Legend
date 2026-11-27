module("ed.battlehero", package.seeall)
local ed = ed
lovers = {}
lovers.campList = {"p", "e"}
lovers.sexList = {"m", "f"}
lovers.CPBuffId = 1161
lovers.extraDamageValue = 0.3

function lovers.findHero(camp, sex)
  local findResult
  local value = math.huge
  for unit in ed.engine:foreachAliveUnit(camp) do
    if not unit:isAlive() then
    elseif unit.config.is_summoned then
    elseif unit.CHEN_ult1time then
    elseif not unit:isHero() then
    elseif sex == "male" and unit.info.Gender ~= T("\231\148\183") then
    elseif sex == "female" and unit.info.Gender ~= T("\229\165\179") then
    elseif value > unit.attack_range then
      value = unit.attack_range
      findResult = unit
    end
  end
  return findResult
end

function lovers.isCPHero(source)
  local alreadyBuff
  if source then
    local buff_list = not source.buff_list and source.caster and source.caster.buff_list
    if type(buff_list) == "table" then
      for i, tbuff in ipairs(buff_list) do
        if tbuff.info.ID == lovers.CPBuffId then
          alreadyBuff = tbuff
          break
        end
      end
    else
      print("check Hero Fail:source type error")
    end
  end
  return alreadyBuff
end

function lovers.skill_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  if not skill.alreadyInitial then
    skill.alreadyInitial = true
    skill.CPHeroList = {
      pm = nil,
      pf = nil,
      em = nil,
      ef = nil
    }
  end
  for _, camp in ipairs(lovers.campList) do
    local cpHeroCount = 0
    for _, sex in ipairs(lovers.sexList) do
      local index = camp .. sex
      local hero = skill.CPHeroList[index]
      if not hero or not hero:isAlive() then
        local findCamp = camp == "p" and ed.emCampPlayer or ed.emCampEnemy
        local findSex = sex == "m" and "male" or "female"
        skill.CPHeroList[index] = lovers.findHero(findCamp, findSex)
      end
      if skill.CPHeroList[index] then
        cpHeroCount = cpHeroCount + 1
      end
    end
    if 2 <= cpHeroCount then
      for _, sex in ipairs(lovers.sexList) do
        local index = camp .. sex
        local hero = skill.CPHeroList[index]
        if hero and not lovers.isCPHero(hero) then
          local binfo = ed.lookupDataTable("Buff", nil, lovers.CPBuffId)
          local buff = hero:addBuff(binfo, caster)
        end
      end
    else
      for _, sex in ipairs(lovers.sexList) do
        local index = camp .. sex
        local hero = skill.CPHeroList[index]
        if hero then
          local cpBuff = lovers.isCPHero(hero)
          if hero and cpBuff then
            hero:removeBuff(cpBuff)
          end
        end
      end
    end
  end
end

function lovers.skill_buff_checkExtraDamageCondition(basefunc, buff, source, damage_type)
  local ret = basefunc(buff, source, damage_type)
  if ret then
    local owner = buff.owner
    if lovers.isCPHero(source) and not lovers.isCPHero(owner) then
      return true
    else
      return false
    end
  end
  return false
end

function lovers.skill_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("Effect", "eff_tile_TS_atk2.cha")
  buff.timer = buff.timer + 9999
  buff.extraDamageValue = lovers.extraDamageValue
  buff.checkExtraDamageCondition = override(buff.checkExtraDamageCondition, lovers.skill_buff_checkExtraDamageCondition)
  return buff
end

function lovers.init_fieldSkill(skill)
  skill.update = override(skill.update, lovers.skill_update)
  skill.createBuff = override(skill.createBuff, lovers.skill_createBuff)
  return skill
end

return lovers.init_fieldSkill

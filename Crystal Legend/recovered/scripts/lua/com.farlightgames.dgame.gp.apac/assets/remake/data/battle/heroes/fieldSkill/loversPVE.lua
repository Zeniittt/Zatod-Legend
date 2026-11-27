module("ed.battlehero", package.seeall)
local ed = ed
loversPVE = {}
loversPVE.campList = {"p", "e"}
loversPVE.sexList = {"m", "f"}
loversPVE.CPBuffId = 1161
loversPVE.extraDamageValue = 1

function loversPVE.findHero(camp, sex)
  local findResult
  local value = math.huge
  for unit in ed.engine:foreachAliveUnit(camp) do
    if not unit:isAlive() then
    elseif unit.config.is_summoned then
    elseif unit.CHEN_ult1time then
    elseif not unit.info["Unit Type"] == "Hero" then
    elseif sex == "male" and unit.info.Gender ~= T("\231\148\183") then
    elseif sex == "female" and unit.info.Gender ~= T("\229\165\179") then
    elseif value > unit.attack_range then
      value = unit.attack_range
      findResult = unit
    end
  end
  return findResult
end

function loversPVE.isCPHero(source)
  local alreadyBuff
  if source then
    local buff_list = not source.buff_list and source.caster and source.caster.buff_list
    if type(buff_list) == "table" then
      for i, tbuff in ipairs(buff_list) do
        if tbuff.info.ID == loversPVE.CPBuffId then
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

function loversPVE.skill_update(basefunc, skill, dt_action, dt_cd)
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
  for _, camp in ipairs(loversPVE.campList) do
    local cpHeroCount = 0
    for _, sex in ipairs(loversPVE.sexList) do
      local index = camp .. sex
      local hero = skill.CPHeroList[index]
      if not hero or not hero:isAlive() then
        local findCamp = camp == "p" and ed.emCampPlayer or ed.emCampEnemy
        local findSex = sex == "m" and "male" or "female"
        skill.CPHeroList[index] = loversPVE.findHero(findCamp, findSex)
      end
      if skill.CPHeroList[index] then
        cpHeroCount = cpHeroCount + 1
      end
    end
    if 2 <= cpHeroCount then
      for _, sex in ipairs(loversPVE.sexList) do
        local index = camp .. sex
        local hero = skill.CPHeroList[index]
        if hero and not loversPVE.isCPHero(hero) then
          local binfo = ed.lookupDataTable("Buff", nil, loversPVE.CPBuffId)
          local buff = hero:addBuff(binfo, caster)
        end
      end
    else
      for _, sex in ipairs(loversPVE.sexList) do
        local index = camp .. sex
        local hero = skill.CPHeroList[index]
        if hero then
          local cpBuff = loversPVE.isCPHero(hero)
          if hero and cpBuff then
            hero:removeBuff(cpBuff)
          end
        end
      end
    end
  end
end

function loversPVE.skill_buff_checkExtraDamageCondition(basefunc, buff, source, damage_type)
  local ret = basefunc(buff, source, damage_type)
  if ret then
    local owner = buff.owner
    if loversPVE.isCPHero(source) and not loversPVE.isCPHero(owner) then
      return true
    else
      return false
    end
  end
  return false
end

function loversPVE.skill_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("Effect", "eff_tile_TS_atk2.cha")
  buff.timer = buff.timer + 9999
  buff.extraDamageValue = loversPVE.extraDamageValue
  buff.checkExtraDamageCondition = override(buff.checkExtraDamageCondition, loversPVE.skill_buff_checkExtraDamageCondition)
  return buff
end

function loversPVE.init_fieldSkill(skill)
  skill.update = override(skill.update, loversPVE.skill_update)
  skill.createBuff = override(skill.createBuff, loversPVE.skill_createBuff)
  return skill
end

return loversPVE.init_fieldSkill

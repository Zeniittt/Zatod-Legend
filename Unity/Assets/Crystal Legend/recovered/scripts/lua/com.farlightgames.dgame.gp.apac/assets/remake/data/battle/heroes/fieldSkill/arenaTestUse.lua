module("ed.battlehero", package.seeall)
local ed = ed
arenaTestUse = {}
arenaTestUse.foodBuffId = 1228
arenaTestUse.foodEffectList = {
  [1] = {AP = 1100},
  [2] = {AD = 450},
  [3] = {MPRatio = 15},
  [4] = {AP = 875, AD = 350},
  [5] = {HP = 3500}
}
arenaTestUse.heroUseFood = {
  STR = 5,
  AGI = 2,
  INT = 1
}
arenaTestUse.specialHeroFood = {
  Enigma = 5,
  AW = 5,
  TB = 5,
  Sven = 5,
  TA = 5,
  JUGG = 2,
  SPE = 2,
  DK = 2,
  AA = 5,
  Monk = 2,
  Ezio = 2,
  Wolf = 5,
  Timber = 2,
  CG = 2,
  VIS = 5,
  WW = 1
}

function arenaTestUse.skill_update(basefunc, skill, dt_action, dt_cd)
  basefunc(skill, dt_action, dt_cd)
  local caster = skill.caster
  if not skill.hasInitial then
    skill.hasInitial = true
    skill.heroFoodBuffList = {}
  end
  for unit in ed.engine:foreachAliveUnit(caster.camp) do
    if skill.heroFoodBuffList[unit] then
      break
    end
    if unit == caster then
      break
    end
    if unit.config.is_summoned then
      break
    end
    if not unit:isHero() then
      break
    end
    local binfo = ed.lookupDataTable("Buff", nil, arenaTestUse.foodBuffId)
    local buff = unit:addBuff(binfo, caster)
    if buff then
      skill.heroFoodBuffList[unit] = buff
      local mainAtt = unit.info["Main Attrib"]
      local foodId = arenaTestUse.heroUseFood[mainAtt]
      if arenaTestUse.specialHeroFood[unit.name] then
        foodId = arenaTestUse.specialHeroFood[unit.name]
      end
      local foodEffect = foodId and arenaTestUse.foodEffectList[foodId] or {}
      for att, value in pairs(foodEffect) do
        buff:setAttribute(att, value)
      end
      unit:resetBuffApply(buff)
      unit.hp = unit.attribs.HP
    end
  end
end

function arenaTestUse.init_fieldSkill(skill)
  skill.update = override(skill.update, arenaTestUse.skill_update)
  return skill
end

return arenaTestUse.init_fieldSkill

local limit_hero_id = 10000
local s_hero_id = 100

function PRINT(...)
end

module("ed.multiArena", package.seeall)
MagicManager = {}

function MagicManager.CreateMagic(info)
  PRINT("magicManager create magic ", info.isHost)
  local magicId = info.magicId
  local pos = info.pos
  local level = ed.multiArena.GetMagicLevel()
  local mif = ed.MagicSkill.getSkillInfo(magicId, level)
  local skill = ed.MagicSkillCreate(mif, info.caster, pos)
  skill:start()
  ed.engine:addMagic(skill)
end

local magicDefault = 40000

function MagicId2Index(id)
  return id - magicDefault
end

function Index2MagicId(index)
  return index + magicDefault
end

function HeroId2Index(hid)
  PRINT("hero id  ", hid)
  if hid < s_hero_id then
    return hid
  elseif hid > limit_hero_id then
    return hid - limit_hero_id + s_hero_id
  end
end

function Index2HeroId(index)
  if index < s_hero_id then
    return index
  else
    return index + limit_hero_id - s_hero_id
  end
end

function GetMagicLevel()
  return 100
end

function GetRecoverySpeed(hero_num)
  return RecoverySpeed[hero_num]
end

function GetJoinBattleEnergy(hero_num)
  local index = math.min(hero_num, MaxHeroNum)
  return JoinBattleEnergy[index]
end

JoinBattleEnergy = {
  1,
  1,
  1,
  1,
  1
}
RecoverySpeed = {
  0.0125,
  0.0125,
  0.0125,
  0.0125,
  0.0125
}
battleTime = 240
MaxEnergy = 2.5
InitEnergy = 2
InitHpScale = 1
stage_rect = {
  minX = 0,
  maxX = 1000,
  minY = -150,
  maxY = 150
}
locked_host_pos_x = stage_rect.maxX * 0.31
UnitScale = 0.75
UnitIconX = 60
UnitIconY = 375
MaxHeroNum = 3
MaxMagicNum = 10

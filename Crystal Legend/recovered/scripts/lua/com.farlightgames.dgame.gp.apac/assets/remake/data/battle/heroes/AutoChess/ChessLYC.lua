module("ed.battlehero", package.seeall)
local ed = ed
ChessLYC = {}
ChessLYC.chess_hp_ratio = {
  0.25,
  0.35,
  0.45
}

function ChessLYC.skillult_start(basefunc, skill, target)
  local owner = skill.caster
  skill.caster.isWolf_LYC = true
  local bid = 339
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  basefunc(skill, target)
  if skill.caster.isDeading_LYC == true then
    skill.caster.mp = 0
  end
  owner.hp_retore = ChessLYC.chess_hp_ratio[owner.chess_stars] * owner.attribs.HP
end

function ChessLYC.skillult_finish(basefunc, skill)
  basefunc(skill)
  local owner = skill.caster
  local nextPeriodID = owner.chess_stars * 2
  owner:enterActionStageFromOneStage(nextPeriodID, 6)
  if owner.hp_retore then
    owner:takeHeal(owner.hp_retore, "hp", owner)
  end
  for i, tbuff in ipairs(owner.buff_list) do
    if tbuff.info.ID == 339 then
      local buff = tbuff
      buff.owner:removeBuff(buff)
    end
  end
  local bid = 338
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = owner:addBuff(binfo, owner)
  owner.ChessLYC_wolves = {}
  for i = 1, 2 do
    local proto = {
      _tid = 50100 + owner.chess_stars,
      _level = skill.level or 1,
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
    local animal = ed.ChessUnitCreate(proto, owner.camp, config)
    animal.direction = owner.direction
    local animal_location = {
      400 - 410 * animal.direction,
      owner.position[2] - 20 * (i - 1.5)
    }
    if owner:isAlive() then
      ed.engine:summonUnit(animal, animal_location, owner, "Idle")
      table.insert(owner.ChessLYC_wolves, animal)
    end
  end
end

function ChessLYC.skillult_canCastWithTarget(basefunc, skill, target)
  local hero = skill.caster
  if not basefunc(skill, target) or hero.mp < 1000 and skill.caster.name == "LYC" or skill.caster.isWolf_LYC == true then
    return false
  end
  return true
end

function ChessLYC.reset(basefunc, unit)
  basefunc(unit)
  unit.isWolf_LYC = false
  unit.isDeading_LYC = false
end

function ChessLYC.hero_onDying(basefunc, unit, skiller)
  basefunc(unit, skiller)
  if unit.ChessLYC_wolves and unit.ChessLYC_wolves[1] then
    for i, wolf in ipairs(unit.ChessLYC_wolves) do
      wolf:takeDamage(wolf.hp + 1, "Holy", "hp", skiller)
    end
  end
end

function ChessLYC.init_hero(hero)
  hero.chess_stars = hero.info["Chess Stars"]
  hero:setActionStageChangeByManual(true)
  local skillult = hero.skills.LYC_ult
  if skillult then
    skillult.start = override(skillult.start, ChessLYC.skillult_start)
    skillult.finish = override(skillult.finish, ChessLYC.skillult_finish)
    skillult.canCastWithTarget = override(skillult.canCastWithTarget, ChessLYC.skillult_canCastWithTarget)
    hero.onDying = override(hero.onDying, ChessLYC.hero_onDying)
  end
  return hero
end

return ChessLYC.init_hero

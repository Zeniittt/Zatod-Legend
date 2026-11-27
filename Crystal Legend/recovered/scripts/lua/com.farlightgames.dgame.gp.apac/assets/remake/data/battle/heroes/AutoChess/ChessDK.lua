module("ed.battlehero", package.seeall)
local ed = ed
ChessDK = {}
ChessDK.name = "DK"
ChessDK.emptyBuffID = 233
ChessDK.uncontrollableBuffID = 214

function ChessDK.reset(basefunc, unit)
  basefunc(unit)
  unit.DK_Form = "Human"
end

function ChessDK.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local unit = skill.caster
  if not unit["Ult Uncontrollable Buff"] then
    local binfo = ed.lookupDataTable("Buff", nil, ChessDK.uncontrollableBuffID)
    local buff = unit:addBuff(binfo, unit)
    unit["Ult Uncontrollable Buff"] = buff
  end
end

function ChessDK.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(5, 0.1, 5)
  end
end

function ChessDK.skillult_finish(basefunc, skill)
  basefunc(skill)
  local unit = skill.caster
  local nextPeriodID = unit.chess_stars * 2
  unit:enterActionStageFromOneStage(nextPeriodID, 3)
  local skillult = unit.skills[ChessDK.name .. "_ult"]
  unit.DK_Form = "Dragon1"
  local buff_uncon = unit["Ult Uncontrollable Buff"]
  if buff_uncon then
    unit:removeBuff(buff_uncon)
    unit["Ult Uncontrollable Buff"] = nil
  end
  local caster = skill.caster
  local position1 = caster.position[1] - caster.direction * 57
  if position1 < 800 and 0 < position1 then
    caster.position[1] = position1
  end
end

function ChessDK.init_hero(hero)
  hero.chess_stars = hero.info["Chess Stars"]
  hero:setActionStageChangeByManual(true)
  local skillult = hero.skills[ChessDK.name .. "_ult"]
  if skillult then
    skillult.start = override(skillult.start, ChessDK.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, ChessDK.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, ChessDK.skillult_finish)
  end
  hero.reset = override(hero.reset, ChessDK.reset)
  return hero
end

return ChessDK.init_hero

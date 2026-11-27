module("ed.battlehero", package.seeall)
local ed = ed
ChessGA = {}
ChessGA.chess_atkup = {
  0.8,
  1.3,
  1.8
}
ChessGA.chess_hprup = {
  400,
  600,
  800
}
ChessGA.ult_buffID = 6020

function ChessGA.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  if skill.attack_counter == 3 then
    skill:onPhaseFinished()
  end
end

function ChessGA.skillult_takeEffectAt(basefunc, skill, location, source)
  if skill.current_phase_idx == 1 then
    local caster = skill.caster
    local binfo = ed.lookupDataTable("Buff", nil, ChessGA.ult_buffID)
    local ultbuff = ed.BuffCreate(binfo, caster, caster)
    ultbuff:setAttribute("AD", caster.attribs.AD * ChessGA.chess_atkup[caster.chess_stars])
    ultbuff:setAttribute("HPR", ChessGA.chess_hprup[caster.chess_stars])
    caster:addBuff(ultbuff, caster)
  elseif skill.current_phase_idx == 2 then
    basefunc(skill, target, source, shift)
  end
end

function ChessGA.init_hero(hero)
  hero.chess_stars = hero.info["Chess Stars"]
  local skillult = hero.skills.GA_ult
  if skillult then
    skillult.onAttackFrame = override(skillult.onAttackFrame, ChessGA.skillult_onAttackFrame)
    skillult.takeEffectAt = override(skillult.takeEffectAt, ChessGA.skillult_takeEffectAt)
  end
  return hero
end

return ChessGA.init_hero

module("ed.battlehero", package.seeall)
local ed = ed
ChessBH = {}

function ChessBH.skillatk_start(basefunc, skill, target)
  basefunc(skill, target)
  local unit = skill.caster
  skill:startPhase(skill.BHphaseID)
  if skill.BHphaseID == 3 then
    skill.BHphaseID = 1
  else
    skill.BHphaseID = skill.BHphaseID + 1
  end
end

function ChessBH.skillatk_onPhaseFinished(basefunc, self)
  self:finish()
end

function ChessBH.init_hero(hero)
  local skillatk = hero.skills.BH_atk
  if skillatk then
    skillatk.BHphaseID = 1
    skillatk.start = override(skillatk.start, ChessBH.skillatk_start)
    skillatk.onPhaseFinished = override(skillatk.onPhaseFinished, ChessBH.skillatk_onPhaseFinished)
  end
  return hero
end

return ChessBH.init_hero

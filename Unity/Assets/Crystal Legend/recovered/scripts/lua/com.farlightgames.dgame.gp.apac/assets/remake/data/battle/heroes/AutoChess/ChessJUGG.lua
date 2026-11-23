module("ed.battlehero", package.seeall)
local ed = ed
ChessJUGG = {}
ChessJUGG.JUGG_sawake_MultiRatio = 0.8
ChessJUGG.JUGG_HP_Ratio = 70
ChessJUGG.JUGG_MP_Ratio = 0.9
ChessJUGG.JUGG_ult_buffID = 6079

function ChessJUGG.skillult_start(basefunc, skill, target)
  local caster = skill.caster
  local target = target
  local v = 180
  local bid = ChessJUGG.JUGG_ult_buffID
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  caster.walk_v = {
    caster.direction * v,
    0
  }
  basefunc(skill, target)
end

function ChessJUGG.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
  local skill = skill
  local caster = skill.caster
  if skill.attack_counter and skill.attack_counter == 4 then
    local v = -caster.walk_v[1]
    caster.walk_v = {v, 0}
  elseif skill.attack_counter and skill.attack_counter == 8 then
    caster.walk_v = {0, 0}
  end
end

function ChessJUGG.skillult_finish(basefunc, skill)
  skill.caster.walk_v = {0, 0}
  skill.caster.direction = skill.caster.direction * -1
  basefunc(skill)
end

function ChessJUGG.init_hero(hero)
  local skillult = hero.skills.JUGG_ult
  if skillult then
    skillult.start = override(skillult.start, ChessJUGG.skillult_start)
    skillult.onAttackFrame = override(skillult.onAttackFrame, ChessJUGG.skillult_onAttackFrame)
    skillult.finish = override(skillult.finish, ChessJUGG.skillult_finish)
  end
  return hero
end

return ChessJUGG.init_hero

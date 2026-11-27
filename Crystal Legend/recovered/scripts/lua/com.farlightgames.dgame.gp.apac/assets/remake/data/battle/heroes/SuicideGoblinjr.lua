module("ed.battlehero", package.seeall)
local ed = ed
SuicideGoblinjr = {}

function SuicideGoblinjr.skillatk_start(basefunc, skill, target)
  local caster = skill.caster
  local bid = 56
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = caster:addBuff(binfo, caster)
  basefunc(skill, target)
end

function SuicideGoblinjr.skillatk_takeEffectAt(basefunc, skill, location, source)
  local caster = skill.caster
  basefunc(skill, location, source)
  caster:die(caster)
end

function SuicideGoblinjr.init_hero(hero)
  local skillatk = hero.skills.SuicideGoblinjr_atk
  if skillatk then
    skillatk.start = override(skillatk.start, SuicideGoblinjr.skillatk_start)
    skillatk.takeEffectAt = override(skillatk.takeEffectAt, SuicideGoblinjr.skillatk_takeEffectAt)
  end
  return hero
end

return SuicideGoblinjr.init_hero

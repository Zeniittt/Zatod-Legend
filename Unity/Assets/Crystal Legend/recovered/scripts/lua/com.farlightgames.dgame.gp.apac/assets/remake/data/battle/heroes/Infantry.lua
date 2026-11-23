module("ed.battlehero", package.seeall)
local ed = ed
Infantry = {}

function Infantry.enterActionStageFromOneStage(basefunc, unit, nStage, id)
  basefunc(unit, nStage, id)
  if nStage == 2 then
    local bid = 822
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    binfo = ed.wraptable(binfo, {
      ARM = unit.level * 2.15 * 2,
      MR = unit.level * 1.34 * 2
    })
    unit:addBuff(binfo, unit)
  end
end

function Infantry.init_hero(hero)
  hero.enterActionStageFromOneStage = override(hero.enterActionStageFromOneStage, Infantry.enterActionStageFromOneStage)
  return hero
end

return Infantry.init_hero

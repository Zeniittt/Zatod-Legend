module("ed.battlehero", package.seeall)
local ed = ed
Hedgehog = {}
Hedgehog.emptyBuffID = 233

function Hedgehog.buff_update(basefunc, buff, dt)
  local positionX = buff.owner.position[1]
  if 0 <= positionX and positionX <= 800 then
    buff.timer = 0
  end
  basefunc(buff, dt)
end

function Hedgehog.reset(basefunc, unit)
  basefunc(unit)
  local binfo = ed.lookupDataTable("Buff", nil, Hedgehog.emptyBuffID)
  binfo = ed.wraptable(binfo, {
    ["Control Effects"] = {
      "untargetable"
    }
  })
  local buff = unit:addBuff(binfo, unit)
  if buff then
    buff.update = override(buff.update, Hedgehog.buff_update)
  end
end

function Hedgehog.update(basefunc, unit, dt)
  if unit.HedgehogLeftLife then
    unit.HedgehogLeftLife = unit.HedgehogLeftLife - dt
    if unit.HedgehogLeftLife <= 0 then
      unit:die()
      return
    end
  end
  basefunc(unit, dt)
end

function Hedgehog.init_hero(hero)
  hero.reset = override(hero.reset, Hedgehog.reset)
  hero.update = override(hero.update, Hedgehog.update)
  return hero
end

return Hedgehog.init_hero

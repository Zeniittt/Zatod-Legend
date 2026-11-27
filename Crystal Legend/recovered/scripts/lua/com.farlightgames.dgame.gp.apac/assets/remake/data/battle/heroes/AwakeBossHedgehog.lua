module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossHedgehog = {}
AwakeBossHedgehog.emptyBuffID = 233

function AwakeBossHedgehog.buff_update(basefunc, buff, dt)
  local positionX = buff.owner.position[1]
  if 0 <= positionX and positionX <= 800 then
    buff.timer = 0
  end
  basefunc(buff, dt)
end

function AwakeBossHedgehog.reset(basefunc, unit)
  basefunc(unit)
  local binfo = ed.lookupDataTable("Buff", nil, AwakeBossHedgehog.emptyBuffID)
  binfo = ed.wraptable(binfo, {
    ["Control Effects"] = {
      "untargetable"
    }
  })
  local buff = unit:addBuff(binfo, unit)
  if buff then
    buff.update = override(buff.update, AwakeBossHedgehog.buff_update)
  end
end

function AwakeBossHedgehog.update(basefunc, unit, dt)
  if unit.AwakeBossHedgehogLeftLife then
    unit.AwakeBossHedgehogLeftLife = unit.AwakeBossHedgehogLeftLife - dt
    if unit.AwakeBossHedgehogLeftLife <= 0 then
      unit:die()
      return
    end
  end
  basefunc(unit, dt)
end

function AwakeBossHedgehog.init_hero(hero)
  hero.reset = override(hero.reset, AwakeBossHedgehog.reset)
  hero.update = override(hero.update, AwakeBossHedgehog.update)
  return hero
end

return AwakeBossHedgehog.init_hero

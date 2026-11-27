module("ed.battlehero", package.seeall)
local ed = ed
RogueSheep = {}

function RogueSheep.update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero:isAlive() then
    local timer = hero.attack_timer - dt
    local walktimer = hero.walktimer - dt
    hero.state = ed.emUnitState_Walk
    hero:setAction("Move", true)
    while walktimer <= 0 do
      walktimer = walktimer + 2
      hero.RogueSheeptime = hero.RogueSheeptime + 1
      hero.RogueSheepP = math.max(0.5, ed.rand() * 2)
    end
    local v
    if hero.RogueSheeptime % 2 == 0 then
      v = 150 * (hero.RogueSheepP or 1)
    elseif hero.RogueSheeptime % 2 == 1 then
      v = -150 * (hero.RogueSheepP or 1)
    end
    hero.walk_v = {v, 0}
    hero.attack_timer = timer
    hero.walktimer = walktimer
  end
end

function RogueSheep.init_hero(hero)
  hero.update = override(hero.update, RogueSheep.update)
  hero.attack_timer = 0
  hero.walktimer = 0
  hero.RogueSheeptime = 0
  return hero
end

return RogueSheep.init_hero

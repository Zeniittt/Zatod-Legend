module("ed.battlehero", package.seeall)
local ed = ed
RogueGoldenSheep = {}

function RogueGoldenSheep.update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero:isAlive() then
    local timer = hero.attack_timer - dt
    local walktimer = hero.walktimer - dt
    hero.state = ed.emUnitState_Walk
    hero:setAction("Move", true)
    while walktimer <= 0 do
      walktimer = walktimer + 2
      hero.RogueGoldenSheeptime = hero.RogueGoldenSheeptime + 1
      hero.RogueGoldenSheepP = math.max(0.5, ed.rand() * 2)
    end
    local v
    if hero.RogueGoldenSheeptime % 2 == 0 then
      v = 150 * (hero.RogueGoldenSheepP or 1)
    elseif hero.RogueGoldenSheeptime % 2 == 1 then
      v = -150 * (hero.RogueGoldenSheepP or 1)
    end
    hero.walk_v = {v, 0}
    hero.attack_timer = timer
    hero.walktimer = walktimer
  end
end

function RogueGoldenSheep.init_hero(hero)
  hero.update = override(hero.update, RogueGoldenSheep.update)
  hero.attack_timer = 0
  hero.walktimer = 0
  hero.RogueGoldenSheeptime = 0
  return hero
end

return RogueGoldenSheep.init_hero

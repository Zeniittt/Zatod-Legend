module("ed.battlehero", package.seeall)
local ed = ed
FleeingSheep = {}

function FleeingSheep.atk2_start(basefunc, skill, target)
  local caster = skill.caster
  local target = target
  local v = 200
  local bid = 31021
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local buff = ed.BuffCreate(binfo, caster, caster)
  buff:setAttribute("fearrange", 5)
  local rand = ed.rand()
  if 0.5 < rand then
    caster:addBuff(buff, caster)
  else
    caster.walk_v = {
      caster.direction * v,
      0
    }
  end
  basefunc(skill, target)
end

function FleeingSheep.init_hero(hero)
  local atk2 = hero.skills.FleeingSheep_atk2
  if atk2 then
    atk2.start = override(atk2.start, FleeingSheep.atk2_start)
  end
  return hero
end

return FleeingSheep.init_hero

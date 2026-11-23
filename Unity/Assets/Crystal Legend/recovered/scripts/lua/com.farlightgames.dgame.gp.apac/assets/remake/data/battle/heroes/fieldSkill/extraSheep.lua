module("ed.battlehero", package.seeall)
local ed = ed
extraSheep = {}

function extraSheep.sheep_update(basefunc, unit, dt)
  basefunc(unit, dt)
  if unit:isAlive() then
    local timer = unit.attack_timer - dt
    local walktimer = unit.walktimer - dt
    while timer <= 0 do
      timer = timer + 1
    end
    unit.state = ed.emUnitState_Walk
    unit:setAction("Move", true)
    while walktimer <= 0 do
      walktimer = walktimer + 2
      unit.bless3315time = unit.bless3315time + 1
      unit.bless3315p = math.max(0.5, ed.rand() * 2)
    end
    local v
    if unit.bless3315time % 2 == 0 then
      v = 100 * (unit.bless3315p or 1)
    elseif unit.bless3315time % 2 == 1 then
      v = -100 * (unit.bless3315p or 1)
    end
    unit.walk_v = {v, 0}
    unit.attack_timer = timer
    unit.walktimer = walktimer
  end
end

function extraSheep.init_fieldSkill(skill)
  local sheepid = 200044
  local proto = {
    _tid = sheepid,
    _level = 1,
    _stars = 5,
    _rank = 11
  }
  local config = {
    is_monster = true,
    estimate_rank = true,
    hp_mod = 1,
    dps_mod = 1,
    size_mod = 1.5
  }
  local sheep1 = ed.UnitCreate(proto, 1, config)
  sheep1:setDeathWithEffectOrNot(true)
  sheep1.direction = 1
  local location = {300, 0}
  ed.engine:summonUnit(sheep1, location, skill.caster)
  local bid = 99000003
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  local buff = ed.BuffCreate(binfo, sheep1, caster)
  sheep1:addBuff(buff, caster)
  sheep1.attack_timer = 0
  sheep1.walktimer = 0
  sheep1.bless3315time = 0
  local sheep2 = ed.UnitCreate(proto, -1, config)
  sheep2:setDeathWithEffectOrNot(true)
  sheep2.direction = -1
  local location = {500, 0}
  ed.engine:summonUnit(sheep2, location, skill.caster)
  local bid = 99000003
  local binfo = ed.lookupDataTable("Buff", nil, bid)
  local caster = skill.caster
  local buff = ed.BuffCreate(binfo, sheep2, caster)
  sheep2:addBuff(buff, caster)
  sheep2.attack_timer = 0
  sheep2.walktimer = 0
  sheep2.bless3315time = 0
  return skill
end

return extraSheep.init_fieldSkill

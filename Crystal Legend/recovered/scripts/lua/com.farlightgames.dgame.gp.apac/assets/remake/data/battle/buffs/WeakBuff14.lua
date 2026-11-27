local function WeakBuff14_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local owner = buff.owner
  if owner and not buff.isInited then
    buff.isInited = true
    local mirror = ed.SoloUnitCreate({
      _hid = owner.tid
    }, owner.camp)
    local binfo = ed.lookupDataTable("Buff", nil, 89)
    local buff1 = mirror:addBuff(binfo, mirror)
    mirror.direction = owner.direction
    local location = {
      owner.position[1] + 40 * owner.camp,
      owner.position[2] - 15
    }
    ed.engine:summonUnit(mirror, location, owner, "Birth")
    mirror:setDeathWithEffectOrNot(true)
    table.insert(owner.mirrorList, mirror)
    mirror.owner = owner
  end
end

local function initBuff(buff)
  local owner = buff.owner
  local value = ed.getDataTable("SoloCardSkill")[90]["Level Arg 1"][buff.rank]
  owner.deWeakRatio = value / 100
  return buff
end

return initBuff

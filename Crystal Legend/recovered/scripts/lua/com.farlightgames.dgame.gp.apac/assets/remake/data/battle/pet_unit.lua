local base = ed.Unit
local petUnit = {
  mt = {}
}
petUnit.mt.__index = petUnit
setmetatable(petUnit, base.mt)
ed.petUnit = petUnit

local function Create(proto, camp, config, extraData)
  config.what = "petUnit"
  config.estimate_rank = true
  local tid = proto._type_id
  local level = 1
  local prt = ed.copyProto(proto)
  prt._tid = tid
  prt._level = level
  local unit = ed.UnitCreate(prt, camp, config, extraData)
  unit.owner = config.owner
  unit.battledata = unit.owner.battledata
  setmetatable(unit, petUnit.mt)
  return unit
end

petUnit.Create = Create
ed.petUnitCreate = Create

local function chessPetCreate(proto, camp, config, extraData)
  config.what = "petUnit"
  config.estimate_rank = true
  local tid = proto._pid
  local prt = ed.copyProto(proto)
  prt._tid = tid
  prt._level = 0
  local unit = ed.ChessUnitCreate(prt, camp, config, extraData)
  unit.owner = config.owner
  unit.battledata = unit.owner.battledata
  setmetatable(unit, petUnit.mt)
  return unit
end

petUnit.chessPetCreate = chessPetCreate
ed.chessPetCreate = chessPetCreate

function petUnit.update(basefunc, self, dt)
  basefunc(self, dt)
  local sp = self.position
  local op = self.owner.position
  sp[1] = op[1]
  sp[2] = op[2]
end

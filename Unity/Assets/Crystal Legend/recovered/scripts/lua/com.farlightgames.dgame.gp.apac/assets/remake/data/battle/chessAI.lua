local base = ed.Ai
local chessAI = newclass(base.mt)

local function createChessAIForUnit(unit)
  return chessAI.create(unit)
end

ed.createChessAIForUnit = createChessAIForUnit

function chessAI:stMinDisTarget(ftList)
  ftList = ftList or {}
  local owner = self.owner
  local minDistanSQ = math.huge
  local target
  for unit in ed.engine:foreachAliveUnit(self.owner.foecamp) do
    if unit ~= owner and not unit.buff_effects.untargetable and not unit.buffManager.invisible and (not unit.controlledTarget or unit.controlledTarget.camp ~= self.owner.camp) then
      local distanceSQ = (owner.position[1] - unit.position[1]) * (owner.position[1] - unit.position[1])
      if minDistanSQ > distanceSQ and not ftList[unit.tid] then
        minDistanSQ = distanceSQ
        target = unit
      end
    end
  end
  return target, minDistanSQ
end

function chessAI.create(owner)
  local self = base.create(owner)
  setmetatable(self, chessAI.mt)
  return self
end

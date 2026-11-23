local class = newclass("g")
ed.KillMore = class

function class:check(conditionCfg)
  local result = true
  local battleDataCollect = ed.engine.battleDataCollect
  if battleDataCollect.enemykillnum > battleDataCollect.allykillnum then
    result = false
  end
  self.result = result
  return result
end

function class.handleUnitDieEventOnce(basefunc, self, unit, killer_unit)
  if unit.camp == ed.emCampPlayer and not unit.config.summoner then
    self.enemykillnum = self.enemykillnum + 1
    self.righteffectnum = self.righteffectnum + 1
  end
  if unit.camp == ed.emCampEnemy and not unit.config.summoner then
    self.allykillnum = self.allykillnum + 1
    self.lefteffectnum = self.lefteffectnum + 1
  end
end

function class:getResult()
  return self.result
end

function class:getShowData()
  local battleDataCollect = ed.engine.battleDataCollect
  local leftEffect = false
  local rightEffect = false
  if battleDataCollect.lefteffectnum >= 8 then
    leftEffect = true
    battleDataCollect.lefteffectnum = battleDataCollect.lefteffectnum - 8
  end
  if 8 <= battleDataCollect.righteffectnum then
    rightEffect = true
    battleDataCollect.righteffectnum = battleDataCollect.righteffectnum - 8
  end
  return {
    title = T("\229\135\187\230\157\128\230\149\176\230\155\180\233\171\152\231\154\132\228\184\128\230\150\185\229\143\150\232\131\156"),
    leftTitle = T("\230\136\145\230\150\185\229\135\187\230\157\128\230\149\176"),
    leftScore = battleDataCollect.allykillnum,
    leftEffect = leftEffect,
    rightTitle = T("\230\149\140\230\150\185\229\135\187\230\157\128\230\149\176"),
    rightScore = battleDataCollect.enemykillnum,
    rightEffect = rightEffect
  }
end

function class.create(specialConditionCfg)
  local self = setmetatable({}, {__index = class})
  local battleDataCollect = ed.engine.battleDataCollect
  battleDataCollect.allykillnum = 0
  battleDataCollect.lefteffectnum = 0
  battleDataCollect.enemykillnum = 0
  battleDataCollect.righteffectnum = 0
  battleDataCollect.handleUnitDieEventOnce = override(battleDataCollect.handleUnitDieEventOnce, class.handleUnitDieEventOnce)
  return self
end

return class

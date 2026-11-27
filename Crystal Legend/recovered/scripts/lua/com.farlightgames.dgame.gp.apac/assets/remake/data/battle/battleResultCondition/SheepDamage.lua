local class = newclass("g")
ed.SheepDamage = class

function class:check(conditionCfg)
  local result = true
  local battleDataCollect = ed.engine.battleDataCollect
  if battleDataCollect.enemydmg > battleDataCollect.allydmg then
    result = false
  end
  self.result = result
  return result
end

function class.collectHPchange(basefunc, self, config)
  if config.unit.info.ID == 200044 and config.hp_change < 0 then
    if config.unit.camp == ed.emCampPlayer then
      self.enemydmg = math.floor(self.enemydmg - config.hp_change)
      self.righteffectnum = math.floor(self.righteffectnum - config.hp_change)
    end
    if config.unit.camp == ed.emCampEnemy then
      self.allydmg = math.floor(self.allydmg - config.hp_change)
      self.lefteffectnum = math.floor(self.lefteffectnum - config.hp_change)
    end
  end
end

function class:getResult()
  return self.result
end

function class:getShowData()
  local battleDataCollect = ed.engine.battleDataCollect
  local leftEffect = false
  local rightEffect = false
  if battleDataCollect.lefteffectnum >= 80000 then
    leftEffect = true
    battleDataCollect.lefteffectnum = battleDataCollect.lefteffectnum - 80000
  end
  if 80000 <= battleDataCollect.righteffectnum then
    rightEffect = true
    battleDataCollect.righteffectnum = battleDataCollect.righteffectnum - 80000
  end
  return {
    title = T("\229\175\185\231\190\138\233\128\160\230\136\144\228\188\164\229\174\179\230\155\180\233\171\152\231\154\132\228\184\128\230\150\185\229\143\150\232\131\156"),
    leftTitle = T("\230\136\145\230\150\185\228\188\164\229\174\179"),
    leftScore = battleDataCollect.allydmg,
    leftEffect = leftEffect,
    rightTitle = T("\230\149\140\230\150\185\228\188\164\229\174\179"),
    rightScore = battleDataCollect.enemydmg,
    rightEffect = rightEffect
  }
end

function class.create(specialConditionCfg)
  local self = setmetatable({}, {__index = class})
  local battleDataCollect = ed.engine.battleDataCollect
  battleDataCollect.allydmg = 0
  battleDataCollect.enemydmg = 0
  battleDataCollect.lefteffectnum = 0
  battleDataCollect.righteffectnum = 0
  battleDataCollect.collectHPchange = override(battleDataCollect.collectHPchange, class.collectHPchange)
  return self
end

return class

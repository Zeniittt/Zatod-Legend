local class = newclass("g")
ed.rogueRevelation2 = class

function class.revelationpower(basefunc, self, target, damage_type)
  local info = self.info
  local totalap = 0
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    if not unit.config.is_summoned then
      local ap = unit.attribs.AP
      totalap = totalap + ap
    end
  end
  local ratio = info["Script Arg1"]
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getBless(2102) then
    ratio = ed.engine.rogueSkillMgr.rogueBlessList[2102].info["Script Arg1"]
  end
  local power = totalap * ratio
  return power, 1
end

function class.init(rogueRevelation)
  rogueRevelation.power = override(rogueRevelation.power, class.revelationpower)
  return rogueRevelation
end

return class.init

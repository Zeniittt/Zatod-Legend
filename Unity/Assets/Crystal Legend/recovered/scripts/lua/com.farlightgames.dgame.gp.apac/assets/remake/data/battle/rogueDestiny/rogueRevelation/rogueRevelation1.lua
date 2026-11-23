local class = newclass("g")
ed.rogueRevelation1 = class

function class.revelationpower(basefunc, self, target, damage_type)
  local info = self.info
  local totalad = 0
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    if not unit.config.is_summoned then
      local ad = unit.attribs.AD
      totalad = totalad + ad
    end
  end
  local ratio = info["Script Arg1"]
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getBless(1102) then
    ratio = ed.engine.rogueSkillMgr.rogueBlessList[1102].info["Script Arg1"]
  end
  local power = totalad * ratio
  return power, 1
end

function class.revelationtakeEffectAt(basefunc, self, location)
  basefunc(self, location)
  if ed.run_with_scene then
    ed.scene:startCameraShakeAnimationY(8, 0.3, 5)
  end
end

function class.init(rogueRevelation)
  rogueRevelation.power = override(rogueRevelation.power, class.revelationpower)
  rogueRevelation.takeEffectAt = override(rogueRevelation.takeEffectAt, class.revelationtakeEffectAt)
  return rogueRevelation
end

return class.init

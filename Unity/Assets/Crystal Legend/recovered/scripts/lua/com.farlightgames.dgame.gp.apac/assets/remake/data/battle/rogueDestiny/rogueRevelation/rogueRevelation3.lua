local class = newclass("g")
ed.rogueRevelation3 = class

function class.revelationpower(basefunc, self, target, damage_type)
  local info = self.info
  local totalhp = 0
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    if not unit.config.is_summoned then
      local hp = unit.attribs.HP
      totalhp = totalhp + hp
    end
  end
  local ratio = info["Script Arg1"]
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getBless(3102) then
    ratio = ed.engine.rogueSkillMgr.rogueBlessList[3102].info["Script Arg1"]
  end
  local power = totalhp * ratio
  if self.bless3103trigger then
    power = 2 * power
  end
  return power, 1
end

function class.revelationtakeEffectAt(basefunc, self, location)
  local oriinfo = self.info
  if ed.engine.rogue_mode and ed.engine.rogueSkillMgr:getBless(3103) then
    local p = ed.engine.rogueSkillMgr.rogueBlessList[3103].info["Script Arg1"] / 100
    if p >= ed.rand() then
      self.info = ed.wraptable(oriinfo, {
        ["Point Effect"] = "eff_UI_revelation3_2.cha"
      })
      self.bless3103trigger = true
    end
  end
  basefunc(self, location)
  self.info = oriinfo
end

function class.onFinish(basefunc, self)
  self.bless3103trigger = false
end

function class.init(rogueRevelation)
  rogueRevelation.bless3103trigger = false
  rogueRevelation.power = override(rogueRevelation.power, class.revelationpower)
  rogueRevelation.takeEffectAt = override(rogueRevelation.takeEffectAt, class.revelationtakeEffectAt)
  rogueRevelation.onFinish = override(rogueRevelation.onFinish, class.onFinish)
  return rogueRevelation
end

return class.init

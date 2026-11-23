local class = newclass("g")
ed.rogueBless7301 = class

function class.initBless(bless)
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    if not unit.config.is_summoned then
      unit.basic_skill.info["Ignore Shield"] = true
      local adratio = unit.basic_skill.info["Plus Ratio"]
      if bless.isReinforced then
        unit.basic_skill.info = ed.wraptable(unit.basic_skill.info, {
          ["Plus Ratio"] = adratio + bless.info["Script Arg5"]
        })
      end
    end
  end
  return bless
end

return class.initBless

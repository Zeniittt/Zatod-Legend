local class = newclass("g")
ed.rogueBless1301 = class

function class.initBless(bless)
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    if not unit.config.is_summoned then
      local adratio = unit.basic_skill.info["Plus Ratio"]
      unit.basic_skill.info = ed.wraptable(unit.basic_skill.info, {
        ["Plus Ratio"] = adratio + (bless.isReinforced and bless.info["Script Arg5"] or bless.info["Script Arg1"])
      })
    end
  end
  return bless
end

return class.initBless

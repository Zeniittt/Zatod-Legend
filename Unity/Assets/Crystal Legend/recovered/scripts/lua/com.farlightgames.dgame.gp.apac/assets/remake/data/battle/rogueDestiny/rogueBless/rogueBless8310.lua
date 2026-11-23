local class = newclass("g")
ed.rogueBless8310 = class

function class.initBless(bless)
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    if not unit.config.is_summoned then
      local manual = unit.manual_skill
      unit.bless8310list = {}
      if manual then
        manual.info = ed.wraptable(manual.info, {
          ["CRIT%"] = 100 + (bless.isReinforced and bless.info["Script Arg5"] or bless.info["Script Arg1"])
        })
      end
      for _, skill in pairs(unit.skills) do
        if string.match(skill.info["Skill Name"], "ult") and not unit.bless8310list[skill.info["Skill Name"]] then
          unit.bless8310list[skill.info["Skill Name"]] = true
          if skill.info["Damage Type"] then
            local plusratio = skill.info["Plus Ratio"]
            skill.info = ed.wraptable(skill.info, {
              ["CRIT%"] = 100 + (bless.isReinforced and bless.info["Script Arg5"] or bless.info["Script Arg1"])
            })
          end
        end
      end
    end
  end
  return bless
end

return class.initBless

local class = newclass("g")
ed.rogueBless7310 = class

function class.initBless(bless)
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    if not unit.config.is_summoned then
      local manual = unit.manual_skill
      unit.bless7310list = {}
      if manual.info["Damage Type"] then
        local plusratio = manual.info["Plus Ratio"]
        manual.info["Ignore Shield"] = true
        if bless.isReinforced and plusratio then
          manual.info = ed.wraptable(manual.info, {
            ["Plus Ratio"] = plusratio + bless.info["Script Arg5"]
          })
        end
      elseif unit.name == "DP" then
        local plusratio = manual.info["Plus Ratio"]
        manual.info["Ignore Shield"] = true
        if bless.isReinforced and plusratio then
          manual.info = ed.wraptable(manual.info, {
            ["Plus Ratio"] = plusratio + bless.info["Script Arg5"]
          })
        end
      else
        for _, skill in pairs(unit.skills) do
          if string.match(skill.info["Skill Name"], "ult") and not unit.bless7310list[skill.info["Skill Name"]] then
            unit.bless7310list[skill.info["Skill Name"]] = true
            if skill.info["Damage Type"] then
              local plusratio = skill.info["Plus Ratio"]
              skill.info["Ignore Shield"] = true
              if bless.isReinforced and plusratio then
                skill.info = ed.wraptable(skill.info, {
                  ["Plus Ratio"] = plusratio + bless.info["Script Arg5"]
                })
              end
            end
          end
        end
      end
    end
  end
  return bless
end

return class.initBless

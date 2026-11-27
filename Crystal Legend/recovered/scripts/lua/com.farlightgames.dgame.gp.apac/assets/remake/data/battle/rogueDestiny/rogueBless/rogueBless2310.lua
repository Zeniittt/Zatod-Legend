local class = newclass("g")
ed.rogueBless2310 = class

function class.initBless(bless)
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    if not unit.config.is_summoned then
      local manual = unit.manual_skill
      unit.bless2310list = {}
      if manual.info["Damage Type"] and manual.info["Plus Attr"] == "AP" then
        local plusratio = manual.info["Plus Ratio"]
        local ratio = (bless.isReinforced and bless.info["Script Arg5"] or bless.info["Script Arg1"]) / 100
        if plusratio then
          manual.info = ed.wraptable(manual.info, {
            ["Plus Ratio"] = plusratio + plusratio * ratio
          })
        end
      elseif unit.name == "DP" then
        local plusratio = manual.info["Plus Ratio"]
        local ratio = (bless.isReinforced and bless.info["Script Arg5"] or bless.info["Script Arg1"]) / 100
        if plusratio then
          manual.info = ed.wraptable(manual.info, {
            ["Plus Ratio"] = plusratio + plusratio * ratio
          })
        end
      else
        for _, skill in pairs(unit.skills) do
          if string.match(skill.info["Skill Name"], "ult") and not unit.bless2310list[skill.info["Skill Name"]] then
            unit.bless2310list[skill.info["Skill Name"]] = true
            if skill.info["Damage Type"] and skill.info["Plus Attr"] == "AP" then
              local plusratio = skill.info["Plus Ratio"]
              local ratio = (bless.isReinforced and bless.info["Script Arg5"] or bless.info["Script Arg1"]) / 100
              if plusratio then
                skill.info = ed.wraptable(skill.info, {
                  ["Plus Ratio"] = plusratio + plusratio * ratio
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

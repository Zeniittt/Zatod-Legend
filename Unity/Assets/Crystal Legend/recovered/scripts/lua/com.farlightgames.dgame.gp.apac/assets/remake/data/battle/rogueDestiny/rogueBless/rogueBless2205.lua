local class = newclass("g")
ed.rogueBless2205 = class

function class.initBless(bless)
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    if not unit.config.is_summoned then
      for _, skill in pairs(unit.skills) do
        if skill.info["Damage Type"] == "AP" then
          local lfsratio
          local needchange = false
          if bless.isReinforced then
            lfsratio = bless.info["Script Arg5"]
            if lfsratio > skill.info["LFS%"] then
              needchange = true
            end
          else
            lfsratio = bless.info["Script Arg1"]
            if lfsratio > skill.info["LFS%"] then
              needchange = true
            end
          end
          if needchange then
            skill.info = ed.wraptable(skill.info, {
              ["LFS%"] = bless.isReinforced and bless.info["Script Arg5"] or bless.info["Script Arg1"]
            })
          end
        end
      end
    end
  end
  return bless
end

return class.initBless

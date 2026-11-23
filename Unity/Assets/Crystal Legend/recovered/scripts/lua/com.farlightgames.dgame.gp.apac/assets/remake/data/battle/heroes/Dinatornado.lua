module("ed.battlehero", package.seeall)
local ed = ed
Dinatornado = {}

function Dinatornado.init_hero(hero)
  local tornadoatk2 = hero.skills.tornado_atk2
  if hero.config.summoner and hero.config.summoner:isAlive() then
    local dinault = hero.config.summoner.skills.Dina_ult
    if tornadoatk2 and dinault then
      if dinault.evo_rank and dinault.evo_rank >= 1 then
        tornadoatk2.info = ed.wraptable(tornadoatk2.info, {
          ["Plus Ratio"] = dinault.evo_rank1["Script Arg1"]
        })
      end
      if dinault.evo_rank and dinault.evo_rank >= 2 then
        local buff_info = tornadoatk2.info.buff_info
        tornadoatk2.info = ed.wraptable(tornadoatk2.info, {
          buff_info = ed.wraptable(buff_info, {
            Time = buff_info.Time + dinault.evo_rank2["Script Arg1"]
          })
        })
      end
      if dinault.evo_rank and dinault.evo_rank >= 3 then
        tornadoatk2.info = ed.wraptable(tornadoatk2.info, {
          ["Plus Ratio"] = dinault.evo_rank3["Script Arg1"]
        })
      end
    end
  end
  return hero
end

return Dinatornado.init_hero

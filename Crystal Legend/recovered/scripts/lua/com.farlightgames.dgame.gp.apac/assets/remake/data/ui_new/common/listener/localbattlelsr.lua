module("ed", package.seeall)
local LocalBattleLsr = {}
LocalBattleLsr.__index = LocalBattleLsr
ui.localbattlelsr = LocalBattleLsr
local base = ui.baselsr
setmetatable(LocalBattleLsr, base.mt)

function LocalBattleLsr.create()
  local local_battle_lsr = base.create("localbattle")
  setmetatable(local_battle_lsr, LocalBattleLsr)
  return local_battle_lsr
end

function LocalBattleLsr:Exit()
  playEffect(sound.deo.common_back)
end

function LocalBattleLsr:Victory()
  playEffect(sound.deo.battle_win)
end

function LocalBattleLsr:Defeat()
  playEffect(sound.deo.battle_lose)
end

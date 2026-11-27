local ed = ed or {}
local speedRate = {
  1,
  1.5,
  2
}

function ed.setBattleSpeedIdx(idx)
  if idx < 1 or 3 < idx then
    return
  end
  ed.storage.setValue("BATTLE_SPEED_IDX", idx)
end

function ed.getBattleSpeedIdx()
  local value = ed.storage.getInt("BATTLE_SPEED_IDX") or 1
  return 0 < value and value or 1
end

function ed.getBattleSpeedRate()
  if not ed.engine.running then
    return 1.3
  end
  return ed.checkIsOpenAddSpeed() and speedRate[ed.getBattleSpeedIdx()] or 1
end

ed.isTestBattle = false
local openConfig = {
  pvp = true,
  tbc = true,
  guildist = true,
  babel = true,
  multistage = true,
  tower = true,
  stage = true,
  ancients = true,
  nightmare = true,
  legendArena = true,
  videoplayer = true,
  starGate = true,
  chaos_tower = true,
  cupArena = true,
  seasonArena = true,
  peakArena = true,
  guildClash = true,
  crevicedefend = true
}

function ed.checkIsOpenAddSpeed()
  if ed.isTestBattle then
    return ed.isTestBattle
  elseif ed.engine then
    if ed.engine.replayMode then
      return true
    else
      return openConfig[ed.engine:ctMode2String()]
    end
  end
  return false
end

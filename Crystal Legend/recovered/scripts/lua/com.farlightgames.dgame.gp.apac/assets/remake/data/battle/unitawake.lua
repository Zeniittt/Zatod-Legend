local ed = ed

local function canAwake(tid)
  return false
end

ed.canAwake = canAwake

local function canSuperAwake(tid)
  return false
end

ed.canSuperAwake = canSuperAwake

local function awakeLevelOk(hid)
  if ed.player.heroes[hid] and ed.canAwake(hid) then
    return ed.player.heroes[hid]._rank > 11 and ed.player.heroes[hid]._level >= 90
  end
  return false
end

ed.awakeLevelOk = awakeLevelOk

local function getAwakeHeroCnt()
  local cnt = 0
  for k, v in pairs(ed.player.heroes or {}) do
    if ed.player.heroes[k]._arousal and ed.player.heroes[k]._arousal._status == 1 and ed.canAwake(ed.player.heroes[k]._tid) then
      cnt = cnt + 1
    end
  end
  return cnt
end

ed.getAwakeHeroCnt = getAwakeHeroCnt

do_battle_log = EDFLAGWIN32 or EDFLAGSVR

function btlog(...)
  local s = string.format(...)
  if print_battle_log then
    print(s)
  end
  local logbuffer = ed.getLogBuffer()
  if logbuffer then
    logbuffer:append(s)
    logbuffer:append("\n")
  end
end

function getBtlog()
  return tostring(ed.getLogBuffer())
end

function playerlog(owner, warschool, hero_list, bookReadingLv, bonus)
  local log = "--------------------\n"
  log = log .. "---" .. owner .. "---\n"
  log = log .. "-- startBattleTime  " .. tostring(ed.startBattleTime) .. "--- \n"
  btlog(log)
end

function logBeforeBt(hero_list, enemy_list, warschool, bookReadingLevels, params)
  if enemy_list then
    playerlog("Self", nil, hero_list, 0)
    playerlog("Oppo", nil, enemy_list, 0)
  elseif params and params.manualBattle then
    playerlog("Manual", nil, hero_list, 0)
  else
    playerlog("Self", nil, hero_list, 0)
  end
end

local ballbuffer = ed.StringBufferCreate()

function klog(...)
  local s = string.format(...)
  if ballbuffer then
    ballbuffer:append(s)
    ballbuffer:append("\n")
  end
end

ed.klog = klog
local deepProjectionX = ed.deepProjectionX
local deepProjectionY = ed.deepProjectionY

local function toMultiArenaPosition(x, y, height)
  local maxX = ed.engine.stage_rect.maxX
  local maxY = ed.engine.stage_rect.maxY - ed.engine.stage_rect.minY
  local scaleX = maxX / 800
  local scaleY = maxY / 240
  y = ((y - 265) * scaleX - height) / deepProjectionY
  x = x * scaleY - y * deepProjectionX
  return x, y
end

local function toLogicalPosition(view_position, height)
  local height = height or 0
  local x = view_position.x
  local y = view_position.y
  if ed.engine:isTowerWarsMode() then
    y = ((y - 265) * 2 - height) / deepProjectionY
    x = x * 2 - y * deepProjectionX
  elseif ed.engine.multiarena_mode then
    x, y = toMultiArenaPosition(x, y, height)
  else
    local maxX = ed.engine.stage_rect.maxX
    local fixScale = ed.display.winSize.width / maxX
    y = ((y - 265) / fixScale - height) / deepProjectionY
    x = x / fixScale - y * deepProjectionX
  end
  return {x, y}
end

ed.toLogicalPosition = toLogicalPosition

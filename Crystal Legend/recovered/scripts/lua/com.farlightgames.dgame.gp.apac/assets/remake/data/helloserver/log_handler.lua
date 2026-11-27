module("log_handler", package.seeall)

local function insertElement(tb, ...)
  local amount = select("#", ...)
  for i = 1, amount do
    local tar = select(i, ...)
    if tar then
      table.insert(tb, tar)
    end
  end
end

local function team2string(team, uid)
  local format = "u%i [%s, %s, %s, %s, %s]"
  local paras = {uid}
  for i, hero in ipairs(team) do
    local name = ed.lookupDataTable("Unit", "Name", hero._tid)
    table.insert(paras, name .. " " .. hero._stars .. "-" .. hero._level)
  end
  for i = #team + 1, 5 do
    table.insert(paras, "")
  end
  return string.format(format, unpack(paras))
end

local function chessTeam2String(team, user)
  local format = "u%i [%s, %s, %s, %s, %s, %s]"
  local paras = {
    user._user_key._user_id
  }
  if type(team._heroes) == "table" then
    for i, hero in ipairs(team._heroes) do
      local name = ed.lookupDataTable("ChessUnit", "Name", hero._hid)
      table.insert(paras, name .. " " .. hero._hid)
    end
    for i = #team._heroes + 1, 6 do
      table.insert(paras, "")
    end
  else
    for i = 1, 6 do
      table.insert(paras, "")
    end
  end
  return string.format(format, unpack(paras))
end

local function Solo2String(team, user)
  local format = "u%i [%s]"
  local paras = {
    user._user_key._user_id
  }
  if type(team._hero) == "table" then
    local name = ed.lookupDataTable("SoloUnit", "Name", team._hero._hid)
    table.insert(paras, name .. " " .. team._hero._hid)
  else
    table.insert(paras, "")
  end
  return string.format(format, unpack(paras))
end

local function team2stringUidString(team, uid)
  local format = "u%s [%s, %s, %s, %s, %s]"
  local paras = {uid}
  for i, hero in ipairs(team) do
    local name = ed.lookupDataTable("Unit", "Name", hero._tid)
    table.insert(paras, name .. " " .. hero._stars .. "-" .. hero._level)
  end
  for i = #team + 1, 5 do
    table.insert(paras, "")
  end
  return string.format(format, unpack(paras))
end

function log(job, result, time, serverTime, battle_result, team_info)
  local msg = job.msg
  local format = "%i\t%s vs %s -> %s (%is)"
  local paras = {
    msg._checkid
  }
  if job.type == "stage" then
    local s = string.format("[Stage %i] (%i ops, %i stars)", msg._stageid, #(msg._operations or {}), msg._stars)
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = s
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "arena" then
    local arg1 = team2string(msg._self_heroes, msg._userid)
    local arg2 = team2string(msg._oppo_heroes, msg._oppo_userid)
    local arg3 = result and "victory" or "defeat"
    insertElement(paras, arg1, arg1, arg3, time)
  elseif job.type == "tbc" or job.type == "throne_tower" then
    local arg1 = team2string(msg._self_heroes, msg._userid)
    local arg2 = team2string(msg._oppo_heroes, msg._oppo_userid)
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg1, arg3, time)
  elseif job.type == "chaos_tower" then
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = result and "Pass" or "CHEAT!!"
    local arg3 = ""
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "wca" then
    local arg1 = team2string(msg._self_heroes, msg._userid) or ""
    local arg2 = team2string(msg._oppo_heroes, msg._oppo_userid)
    local arg3 = result == 3 and "victory" or "defeat!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "excav" then
    if job.msg._battle_type == "robot" then
      local arg1 = team2string(msg._self_heroes, msg._userid)
      local arg2 = team2string(msg._oppo_heroes, 0)
      local arg3 = result and "victory" or "defeat"
      insertElement(paras, arg1, arg2, arg3, time)
    else
      local arg1 = team2string(msg._self_heroes, msg._userid)
      local arg2 = team2string(msg._oppo_heroes, msg._oppo_userid)
      local arg3 = result and "Pass" or "CHEAT!!"
      insertElement(paras, arg1, arg2, arg3, time)
    end
  elseif job.type == "dreamland" then
    local s = string.format("[Dreamland Stage %i] (%i ops, damage: %d)", msg._stageid, #(msg._operations or {}), msg._damage)
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, s, arg3, time)
  elseif job.type == "monsterseal" then
    local s = string.format("[Monsterseal Stage %i] (%i ops, damage: %d)", msg._stageid, #(msg._operations or {}), msg._damage)
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = s
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "guild" then
    local s = string.format("[Stage %i]", msg._stageid)
    local arg1 = team2string(msg._self_heroes, msg._userid)
    local arg2 = s
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "ancients" then
    local s = string.format("[Ancients Difficulty %i]", msg._difficulty) or ""
    local arg1 = team2string(msg._self_heroes, msg._userid) or ""
    local arg2 = s
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "toppvp" then
    format = "%i\t%i vs %i -> %s (%is)\n"
    local arg1 = msg._userid
    local arg2 = msg._oppo_userid
    local arg3 = result and "victory" or "defeat"
    insertElement(paras, arg1, arg2, arg3, time)
    local round = job.round
    for i = 1, round do
      format = format .. "[round %i]\t%s vs %s -> %s\n"
      local arg1 = i
      local arg2 = team2string(msg._self_heroes[i]._heroes, msg._userid)
      local arg3 = team2string(msg._oppo_heroes[i]._heroes, msg._oppo_userid)
      local arg4 = "ignored"
      if battle_result[i] then
        arg4 = battle_result[i] == 0 and "victory" or "defeat"
      end
      insertElement(paras, arg1, arg2, arg3, arg4)
    end
  elseif job.type == "guildClash" or job.type == "gcw" then
    local arg1 = team2string(msg._self_heroes, msg._userid)
    local arg2 = team2string(msg._oppo_heroes, 0)
    local arg3 = result and "victory" or "defeat"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "quest" then
    format = "%i\t%s vs enemy:%i -> %s (%is)"
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = msg._enemyid
    local arg3 = result and "victory" or "defeat"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "test_battle_check" then
    if msg._type == "pvp" then
      format = "%i\t%s vs %s -> %s (%is)"
      local arg1 = team2string(msg._self_heroes, msg._userid)
      local arg2 = team2string(msg._oppo_heroes, 0)
      local arg3 = result and "Pass" or "CHEAT!!"
      insertElement(paras, arg1, arg2, arg3, time)
    elseif msg._type == "guild" or msg._type == "dreamland" then
      format = "%i\t%s vs stage %i -> %s (%is)"
      local arg1 = team2string(msg._self_heroes, msg._userid)
      local arg2 = msg._stage_id
      local arg3 = result and "Pass" or "CHEAT!!"
      insertElement(paras, arg1, arg2, arg3, time)
    end
  elseif job.type == "siege" then
    format = "%i\t%s -> %s (%is)"
    local arg1 = team2string(msg._self_heroes, msg._userid)
    local arg2 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, time)
  elseif job.type == "nightmare" then
    format = "%i\t%s\twave:%i -> %s (%is)"
    local arg1 = team2string(msg._self_heroes, msg._userid)
    local arg2 = msg._current_wave_idx
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "assassinate" then
    local arg1 = team2string(msg._self_heroes, msg._userid)
    local arg2 = team2string(msg._oppo_heroes, msg._oppo_userid)
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "multiplayer" then
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = msg._is_manual_battle and "[Manual]" or "[Auto]"
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "babel" then
    local s = string.format("[Stage %i] (%i ops, %i stars)", msg._stageid, #(msg._operations or {}), msg._stars)
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = s
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "nian" then
    local s = string.format("[Nian Stage %i] (%i ops, damage: %d)", msg._stageid, #(msg._operations or {}), msg._damage)
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, s, arg3, time)
  elseif job.type == "legend" then
    format = "%i\t%i vs %s -> %s (%is)\n"
    local arg1 = msg._userid
    local arg2 = msg._oppo_deviceid
    local arg3 = result and "victory" or "defeat"
    insertElement(paras, arg1, arg2, arg3, time)
    local round = msg._round
    for i = 1, round do
      if not msg._oppo_heroes[i] or not msg._self_heroes[i] then
        break
      end
      format = format .. "[round %i]\t%s vs %s -> %s\n"
      local arg1 = i
      local arg2 = team2string(msg._self_heroes[i]._heroes, msg._userid)
      local arg3 = team2stringUidString(msg._oppo_heroes[i]._heroes, msg._oppo_deviceid)
      local arg4 = "ignored"
      if battle_result[i] then
        arg4 = battle_result[i] == 0 and "victory" or "defeat"
      end
      insertElement(paras, arg1, arg2, arg3, arg4)
    end
  elseif job.type == "stargate" then
    format = "%i\t%i vs %s -> %s (%is)\n"
    local arg1 = msg._userid
    local arg2 = msg._oppo_deviceid
    local arg3 = result and "victory" or "defeat"
    insertElement(paras, arg1, arg2, arg3, time)
    local round = #team_info
    for i = 1, round do
      local info = team_info[i]
      local self_team_idx = info.self_team_idx
      local oppo_team_idx = info.oppo_team_idx
      if not msg._oppo_heroes[oppo_team_idx] or not msg._self_heroes[self_team_idx] then
        break
      end
      format = format .. "[round %i]\t%s vs %s -> %s\n"
      local arg1 = i
      local arg2 = team2string(msg._self_heroes[self_team_idx]._heroes, msg._userid)
      local arg3 = team2stringUidString(msg._oppo_heroes[oppo_team_idx]._heroes, msg._oppo_deviceid)
      local arg4 = "ignored"
      if battle_result[i] then
        if battle_result[i] == 0 then
          arg4 = "victory"
        elseif battle_result[i] == 3 then
          arg4 = "timeout"
        else
          arg4 = "defeat"
        end
      end
      insertElement(paras, arg1, arg2, arg3, arg4)
    end
  elseif job.type == "multiarena" then
    local arg1 = team2string(msg._host_team._lord, msg._userid) or ""
    local arg2 = team2string(msg._guest_team._lord, 0)
    local arg3 = result == 3 and "victory" or "defeat!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "multistage" then
    local s = string.format("[Stage %i] (%i ops)", msg._stageid, #(msg._operations or {}))
    local arg1 = team2string(msg._self_heroes, msg._userid)
    local arg2 = s
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "msb" then
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = msg._is_manual_battle and "[Manual]" or "[Auto]"
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "chess" then
    local arg1 = chessTeam2String(battle_result._self_team, battle_result._self_user)
    local arg2 = battle_result._oppo_type
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "solo" then
    local arg1 = Solo2String(battle_result._self_team, battle_result._self_user)
    local arg2 = battle_result._oppo_type
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "arcanaTrial" then
    local s = string.format("[Hero %i ArcanaLevel %i]", msg._hero_id, msg._arcana_level)
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = s
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "mythBoss" then
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = ""
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "fiveBoss" then
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = ""
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "raceTower" then
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = ""
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "cuparena" then
    format = "%i\t%i vs %s -> %s (%is)\n"
    local arg1 = msg._userid
    local arg2 = msg._oppo_roleid
    local arg3 = result and "victory" or "defeat"
    insertElement(paras, arg1, arg2, arg3, time)
    local round = 5
    if #(msg._oppo_heroes or {}) > 5 or #(msg._self_heroes or {}) > 5 then
      round = 7
    end
    for i = 1, round do
      if not msg._oppo_heroes[i] or not msg._self_heroes[i] then
        break
      end
      format = format .. "[round %i]\t%s vs %s -> %s\n"
      local arg1 = i
      local arg2 = team2string(msg._self_heroes[i]._heroes, msg._userid)
      local arg3 = team2stringUidString(msg._oppo_heroes[i]._heroes, msg._oppo_roleid)
      local arg4 = "ignored"
      if battle_result[i] then
        arg4 = battle_result[i] == 0 and "victory" or "defeat"
      end
      insertElement(paras, arg1, arg2, arg3, arg4)
    end
  elseif job.type == "guildMount" then
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = ""
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "seasonArena" then
    format = "%i\t%i vs %s -> %s (%is)\n"
    local arg1 = msg._userid
    local oppoDeviceId = msg._oppo_key._device_id
    local arg2 = oppoDeviceId
    local arg3 = result and "victory" or "defeat"
    insertElement(paras, arg1, arg2, arg3, time)
    local round = #team_info
    for i = 1, round do
      local info = team_info[i]
      local self_team_idx = info.self_team_idx
      local oppo_team_idx = info.oppo_team_idx
      if not msg._oppo_heroes[oppo_team_idx] or not msg._self_heroes[self_team_idx] then
        break
      end
      format = format .. "[round %i]\t%s vs %s -> %s\n"
      local arg1 = i
      local arg2 = team2string(msg._self_heroes[self_team_idx]._heroes or {}, msg._userid)
      local arg3 = team2stringUidString(msg._oppo_heroes[oppo_team_idx]._heroes or {}, oppoDeviceId)
      local arg4 = "ignored"
      if battle_result[i] then
        if battle_result[i] == 0 then
          arg4 = "victory"
        elseif battle_result[i] == 3 then
          arg4 = "timeout"
        else
          arg4 = "defeat"
        end
      end
      insertElement(paras, arg1, arg2, arg3, arg4)
    end
  elseif job.type == "seasonTower" then
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = ""
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "fancyTower" then
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = ""
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "fancyAbyss" then
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = ""
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "activityAdventure" or job.type == "awakeStage" then
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = ""
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "peakArena" then
    format = "%i\t%i vs %s -> %s (%is)\n"
    local arg1 = msg._userid
    local roleId = msg._self_roleid
    local arg2 = roleId
    local arg3 = result and "victory" or "defeat"
    insertElement(paras, arg1, arg2, arg3, time)
    local round = #team_info
    for i = 1, round do
      local info = team_info[i]
      local self_team_idx = info.self_team_idx
      local oppo_team_idx = info.oppo_team_idx
      if not msg._oppo_heroes[oppo_team_idx] or not msg._self_heroes[self_team_idx] then
        break
      end
      format = format .. "[round %i]\t%s vs %s -> %s\n"
      local arg1 = i
      local arg2 = team2string(msg._self_heroes[self_team_idx]._heroes or {}, msg._userid)
      local arg3 = team2stringUidString(msg._oppo_heroes[oppo_team_idx]._heroes or {}, roleId)
      local arg4 = "ignored"
      if battle_result[i] then
        if battle_result[i] == 0 then
          arg4 = "victory"
        elseif battle_result[i] == 3 then
          arg4 = "timeout"
        else
          arg4 = "defeat"
        end
      end
      insertElement(paras, arg1, arg2, arg3, arg4)
    end
  elseif job.type == "hadesHeat" then
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = ""
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "rogueCheck" then
    local arg1 = team2string(msg._heroes, msg._userid)
    local arg2 = ""
    local arg3 = result and "Pass" or "CHEAT!!"
    insertElement(paras, arg1, arg2, arg3, time)
  elseif job.type == "crevicedefend" then
    format = "%i\t%i vs %s -> %s (%is)\n"
    local arg1 = msg._userid
    local arg2 = ""
    local arg3 = result and "victory" or "defeat"
    insertElement(paras, arg1, arg2, arg3, time)
    local round = #team_info
    for i = 1, round do
      local info = team_info[i]
      local self_team_idx = info.self_team_idx
      if not msg._self_heroes[self_team_idx] then
        break
      end
      format = format .. "[round %i]\t%s vs %s -> %s\n"
      local arg1 = i
      local arg2 = team2string(msg._self_heroes[self_team_idx]._heroes or {}, msg._userid)
      local arg4 = "ignored"
      if battle_result[i] then
        if battle_result[i] == 0 then
          arg4 = "victory"
        elseif battle_result[i] == 3 then
          arg4 = "timeout"
        else
          arg4 = "defeat"
        end
      end
      insertElement(paras, arg1, arg2, arg3, arg4)
    end
  end
  format = format .. " server(%fs) type(%s)"
  table.insert(paras, serverTime)
  local type = job.type or ""
  table.insert(paras, type)
  local s = string.format(format, unpack(paras))
  print(s)
end

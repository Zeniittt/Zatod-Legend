bot_analyze = {output_folder = ""}
local analyze_generationNum = 5
local gens_teamdata = {}
bot_analyze.analyze_generationNum = analyze_generationNum

local function update_gens_teamdata(g, gen_teamdata)
  gens_teamdata[g] = gen_teamdata
  local keys = {}
  for key in pairs(gens_teamdata) do
    table.insert(keys, key)
  end
  table.sort(keys)
  while #keys > analyze_generationNum do
    gens_teamdata[keys[1]] = nil
    table.remove(keys, 1)
  end
end

local function analyze_team(g, teamList)
  local hero_stats = {}
  local lineup_stats = {}
  for i = 1, #teamList do
    local team = teamList[i]
    local position = i
    local score = team.score
    local winCnt = team.winCnt
    local battleCnt = team.battleCnt
    local lineup = {}
    local displayNames = {}
    for _, hero in ipairs(team.heroes) do
      table.insert(lineup, hero.name)
      displayNames[hero.name] = ed.lookupDataTable("Unit", "Display Name", hero._tid) or ""
    end
    table.sort(lineup)
    local lineup_key = table.concat(lineup, ",")
    if not lineup_stats[lineup_key] then
      local displayNamesKey = {}
      for i, name in ipairs(lineup) do
        table.insert(displayNamesKey, displayNames[name])
      end
      local displayNames_key = table.concat(displayNamesKey, ",")
      lineup_stats[lineup_key] = {
        count = 0,
        battle_count = 0,
        win_count = 0,
        total_position = 0,
        total_score = 0,
        displayNames = displayNames_key
      }
    end
    lineup_stats[lineup_key].count = lineup_stats[lineup_key].count + 1
    lineup_stats[lineup_key].battle_count = lineup_stats[lineup_key].battle_count + battleCnt
    lineup_stats[lineup_key].win_count = lineup_stats[lineup_key].win_count + winCnt
    lineup_stats[lineup_key].total_position = lineup_stats[lineup_key].total_position + position
    lineup_stats[lineup_key].total_score = lineup_stats[lineup_key].total_score + score
    for _, hero in ipairs(team.heroes) do
      local name = hero.name
      local tid = hero._tid
      if not hero_stats[name] then
        hero_stats[name] = {
          tid = tid,
          count = 0,
          battle_count = 0,
          win_count = 0,
          total_position = 0,
          total_score = 0,
          partnerships = {}
        }
      end
      hero_stats[name].count = hero_stats[name].count + 1
      hero_stats[name].battle_count = hero_stats[name].battle_count + battleCnt
      hero_stats[name].win_count = hero_stats[name].win_count + winCnt
      hero_stats[name].total_position = hero_stats[name].total_position + position
      hero_stats[name].total_score = hero_stats[name].total_score + score
      for _, partner in ipairs(team.heroes) do
        if partner.name ~= name then
          hero_stats[name].partnerships[partner.name] = (hero_stats[name].partnerships[partner.name] or 0) + 1
        end
      end
    end
  end
  update_gens_teamdata(g, {lineup_stats = lineup_stats, hero_stats = hero_stats})
  local aggregated_lineup_stats = {}
  local aggregated_hero_stats = {}
  for _, data in pairs(gens_teamdata) do
    for lineup, stats in pairs(data.lineup_stats) do
      if not aggregated_lineup_stats[lineup] then
        aggregated_lineup_stats[lineup] = {
          count = 0,
          battle_count = 0,
          win_count = 0,
          total_position = 0,
          total_score = 0,
          displayNames = stats.displayNames
        }
      end
      aggregated_lineup_stats[lineup].count = aggregated_lineup_stats[lineup].count + stats.count
      aggregated_lineup_stats[lineup].battle_count = aggregated_lineup_stats[lineup].battle_count + stats.battle_count
      aggregated_lineup_stats[lineup].win_count = aggregated_lineup_stats[lineup].win_count + stats.win_count
      aggregated_lineup_stats[lineup].total_position = aggregated_lineup_stats[lineup].total_position + stats.total_position
      aggregated_lineup_stats[lineup].total_score = aggregated_lineup_stats[lineup].total_score + stats.total_score
    end
    for hero, stats in pairs(data.hero_stats) do
      if not aggregated_hero_stats[hero] then
        aggregated_hero_stats[hero] = {
          tid = stats.tid,
          count = 0,
          battle_count = 0,
          win_count = 0,
          total_position = 0,
          total_score = 0,
          partnerships = {}
        }
      end
      aggregated_hero_stats[hero].count = aggregated_hero_stats[hero].count + stats.count
      aggregated_hero_stats[hero].battle_count = aggregated_hero_stats[hero].battle_count + stats.battle_count
      aggregated_hero_stats[hero].win_count = aggregated_hero_stats[hero].win_count + stats.win_count
      aggregated_hero_stats[hero].total_position = aggregated_hero_stats[hero].total_position + stats.total_position
      aggregated_hero_stats[hero].total_score = aggregated_hero_stats[hero].total_score + stats.total_score
      for partner, count in pairs(stats.partnerships) do
        aggregated_hero_stats[hero].partnerships[partner] = (aggregated_hero_stats[hero].partnerships[partner] or 0) + count
      end
    end
  end
  print("bot_analyze.output_folder:", bot_analyze.output_folder)
  local file = io.open(string.format(bot_analyze.output_folder .. "/analysis_%i_team.csv", analyze_generationNum), "w")
  file:write("\233\152\181\229\174\185,\233\152\181\229\174\185,\233\152\181\229\174\185,\233\152\181\229\174\185,\233\152\181\229\174\185,\228\184\138\229\156\186\230\172\161\230\149\176,\232\131\156\229\156\186\230\172\161\230\149\176,\229\185\179\229\157\135\230\142\146\229\144\141,\229\185\179\229\157\135\229\136\134\230\149\176,\229\164\135\230\179\168,\229\164\135\230\179\168,\229\164\135\230\179\168,\229\164\135\230\179\168,\229\164\135\230\179\168\n")
  for lineup, stats in pairs(aggregated_lineup_stats) do
    local avg_position = stats.total_position / stats.count
    local avg_score = stats.total_score / stats.count
    file:write(string.format("%s,%d,%d,%.2f,%.2f,%s\n", lineup, stats.battle_count, stats.win_count, avg_position, avg_score, stats.displayNames))
  end
  file:close()
  local file = io.open(string.format(bot_analyze.output_folder .. "/analysis_%i_heroes.csv", analyze_generationNum), "w")
  file:write("\232\139\177\233\155\132,\228\184\138\229\156\186\230\172\161\230\149\176,\232\131\156\229\156\186\230\172\161\230\149\176,\229\185\179\229\157\135\230\142\146\229\144\141,\229\185\179\229\157\135\229\136\134\230\149\176,\229\144\136\228\189\156\232\139\177\233\155\1321,\229\144\136\228\189\156\232\139\177\233\155\1322,\229\144\136\228\189\156\232\139\177\233\155\1323,\229\144\136\228\189\156\232\139\177\233\155\1324\n")
  for hero, stats in pairs(aggregated_hero_stats) do
    local avg_position = stats.total_position / stats.count
    local avg_score = stats.total_score / stats.count
    local displayName = ed.lookupDataTable("Unit", "Display Name", stats.tid) or ""
    local partnerships = {}
    for partner, count in pairs(stats.partnerships) do
      table.insert(partnerships, {name = partner, count = count})
    end
    table.sort(partnerships, function(a, b)
      return a.count > b.count
    end)
    file:write(string.format("%s(%s),%d,%d,%.2f,%.2f,%s,%s,%s,%s\n", hero, displayName, stats.battle_count, stats.win_count, avg_position, avg_score, partnerships[1] and partnerships[1].name or "\230\151\160", partnerships[2] and partnerships[2].name or "\230\151\160", partnerships[3] and partnerships[3].name or "\230\151\160", partnerships[4] and partnerships[4].name or "\230\151\160"))
  end
  file:close()
end

bot_analyze.analyze_team = analyze_team

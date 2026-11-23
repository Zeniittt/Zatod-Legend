local types = {
  diamond = "Diamond",
  gold = "Gold",
  item = "Item",
  hero = "Hero",
  vitality = "Vitality",
  playerexp = "PlayerEXP",
  crusadepoint = "CrusadePoint",
  arenapoint = "ArenaPoint",
  guildpoint = "GuildCoin",
  dreampoint = "dreampoint",
  wood = "Wood",
  iron = "Iron",
  crystal = "Crystal",
  gcwpoint = "gcwpoint",
  energy = "Energy",
  guildheroexp = "GuildHeroExp",
  dungeonenergy = "DungeonEnergy",
  peakarenapoint = "PeakArenaPoint",
  guildClashPoint = "GuildClashPoint",
  legend_equip = "legend_equip",
  riseStarPoint = "riseStarPoint"
}
local names = {
  diamond = T("\233\146\187\231\159\179"),
  gold = T("\233\135\145\229\184\129"),
  item = T("\233\129\147\229\133\183"),
  hero = T("\232\139\177\233\155\132"),
  vitality = T("\228\189\147\229\138\155"),
  playerexp = T("\231\187\143\233\170\140"),
  crusadepoint = T("\231\186\162\233\190\153\233\128\134\233\179\158"),
  arenapoint = T("\231\171\158\230\138\128\229\184\129"),
  guildpoint = T("\229\133\172\228\188\154\229\184\129"),
  dreampoint = T("\230\162\166\228\185\139\230\150\176\229\143\182"),
  wood = T("\230\156\168\230\157\144"),
  iron = T("\233\147\129"),
  crystal = T("\230\176\180\230\153\182"),
  gcwpoint = "gcwpoint",
  energy = "Energy",
  guildheroexp = T("\229\133\172\228\188\154\231\187\143\233\170\140"),
  peakmedal = T("\229\183\133\229\179\176\229\139\139\231\171\160"),
  dungeonenergy = T("\232\131\189\233\135\143"),
  peakarenapoint = T("\229\183\133\229\179\176\229\184\129"),
  guildClashPoint = T("\229\133\172\228\188\154\230\136\152\229\184\129"),
  guildmountpoint = T("\233\173\148\231\149\140\232\174\168\228\188\144\229\184\129"),
  riseStarPoint = T("\230\181\129\229\133\137\229\190\174\231\178\146")
}
local config = {
  getResType = function(name)
    return types[string.lower(name)]
  end,
  getResName = function(name)
    return names[string.lower(name)]
  end,
  ResType = types
}
return config

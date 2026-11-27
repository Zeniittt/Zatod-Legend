local ranklistData = {}
ed.ranklistData = ranklistData
local config = {
  [1] = {
    mode = "pvp_r",
    name = T("\231\171\158\230\138\128\229\156\186(\229\174\158\230\151\182)"),
    tipsText = T("\231\171\158\230\138\128\229\156\186\230\142\146\232\161\140\239\188\154"),
    systemMode = "PVP"
  },
  [2] = {
    mode = "pvp",
    name = T("\231\171\158\230\138\128\229\156\186(\230\175\143\230\151\165)"),
    tipsText = T("\231\171\158\230\138\128\229\156\186\230\142\146\232\161\140\239\188\154"),
    systemMode = "PVP"
  },
  [3] = {
    mode = "guildliveness",
    name = T("\229\133\172\228\188\154\230\180\187\232\183\131\230\142\146\232\161\140"),
    tipsText = T("\230\156\128\232\191\145\228\184\137\229\164\169\230\180\187\232\183\131\229\128\188\239\188\154"),
    systemMode = "Guild"
  },
  [8] = {
    mode = "full_hero_gs",
    name = T("\229\133\168\229\145\152\230\136\152\229\138\155\230\142\146\232\161\140"),
    tipsText = T("\230\137\128\230\156\137\232\139\177\233\155\132\230\128\187\230\136\152\229\138\155\239\188\154")
  },
  [9] = {
    mode = "hero_team_gs",
    name = T("\229\176\143\233\152\159\230\136\152\229\138\155\230\142\146\232\161\140"),
    tipsText = T("\230\156\128\233\171\152\228\186\148\228\186\186\230\128\187\230\136\152\229\138\155\239\188\154")
  },
  [10] = {
    mode = "hero_evo_star",
    name = T("\232\139\177\233\155\132\230\152\159\231\186\167\230\142\146\232\161\140"),
    tipsText = T("\232\139\177\233\155\132\230\128\187\230\152\159\231\186\167\239\188\154"),
    tipsIconres = "UI/alpha/HVGA/detail_star.png"
  },
  [11] = {
    mode = "hero_arousal",
    name = T("\232\163\133\229\164\135\230\180\151\231\187\131\230\142\146\232\161\140"),
    tipsText = T("\230\180\151\231\130\188\230\128\187\229\177\158\230\128\167\239\188\154"),
    systemMode = "Awake"
  },
  [14] = {
    mode = "arousal_cnt",
    name = T("\232\139\177\233\155\132\232\167\137\233\134\146\230\149\176\233\135\143"),
    tipsText = T("\232\139\177\233\155\132\232\167\137\233\134\146\230\149\176\233\135\143\239\188\154"),
    systemMode = "Awake"
  },
  [17] = {
    mode = "dreamland_individual",
    name = T("\229\141\149\228\186\186\230\168\161\229\188\143\239\188\136\230\156\172\230\156\141\239\188\137"),
    tipsText = T("\230\156\128\233\171\152\228\188\164\229\174\179\232\190\147\229\135\186\239\188\154"),
    itemSize = ed.DGSizeMake(512, 75),
    systemMode = "Dreamland",
    canSameRank = true
  },
  [18] = {
    mode = "dreamland_guild",
    name = T("\229\133\172\228\188\154\228\188\164\229\174\179\230\128\187\229\146\140"),
    tipsText = T("\229\133\172\228\188\154\228\188\164\229\174\179\230\128\187\229\146\140\239\188\154"),
    itemSize = ed.DGSizeMake(512, 75),
    systemMode = "Dreamland"
  },
  [19] = {
    mode = "real_arena",
    name = T("\229\133\168\230\156\141\231\167\175\229\136\134\230\142\146\232\161\140"),
    tipsText = T("\231\142\139\232\128\133\231\167\175\229\136\134\239\188\154"),
    systemMode = "RealArena"
  },
  [20] = {
    mode = "last_season_real_arena",
    name = T("\228\184\138\232\181\155\229\173\163\232\135\179\229\176\138\231\142\139\232\128\133"),
    tipsText = T("\231\142\139\232\128\133\231\167\175\229\136\134\239\188\154"),
    systemMode = "RealArena"
  },
  [21] = {
    mode = "dream_guild_individual",
    name = T("\229\133\172\228\188\154\230\136\144\229\145\152\232\180\161\231\140\174"),
    tipsText = T("\230\156\128\233\171\152\228\188\164\229\174\179\232\190\147\229\135\186\239\188\154"),
    itemSize = ed.DGSizeMake(512, 75),
    systemMode = "Dreamland"
  },
  [23] = {
    mode = "super_arousal_cnt",
    name = T("\231\165\158\229\153\168\230\149\176\233\135\143"),
    tipsText = T("\231\165\158\229\153\168\230\149\176\233\135\143\239\188\154"),
    systemMode = "Awake"
  },
  [24] = {
    mode = "rune_hero_arousal",
    name = T("\231\172\166\231\159\179\230\180\151\231\130\188\230\142\146\232\161\140"),
    tipsText = T("\231\172\166\231\159\179\230\180\151\231\130\188\230\128\187\229\177\158\230\128\167\239\188\154"),
    systemMode = "Awake"
  },
  [36] = {
    mode = "dreamland_individual_multi",
    name = T("\232\129\148\230\156\186\230\168\161\229\188\143\239\188\136\230\156\172\230\156\141\239\188\137"),
    tipsText = T("\230\156\128\233\171\152\228\188\164\229\174\179\232\190\147\229\135\186\239\188\154"),
    itemSize = ed.DGSizeMake(512, 75),
    systemMode = "Dreamland",
    canSameRank = true
  },
  [37] = {
    mode = "dreamland_individual_global",
    name = T("\229\133\168\230\156\141\230\142\146\232\161\140"),
    tipsText = T("\230\156\128\233\171\152\228\188\164\229\174\179\232\190\147\229\135\186\239\188\154"),
    itemSize = ed.DGSizeMake(512, 75),
    systemMode = "Dreamland",
    canSameRank = true
  },
  [38] = {
    mode = "local_legend_arena",
    name = T("\230\156\172\230\156\141\229\174\158\230\151\182\230\142\146\232\161\140"),
    tipsText = T("\228\188\160\229\165\135\231\171\158\230\138\128\229\156\186\239\188\154"),
    systemMode = "LegendArena",
    canSameRank = true
  },
  [39] = {
    mode = "global_legend_arena",
    name = T("\229\133\168\230\156\141\229\174\158\230\151\182\230\142\146\232\161\140"),
    tipsText = T("\228\188\160\229\165\135\231\171\158\230\138\128\229\156\186\239\188\154"),
    systemMode = "LegendArena",
    canSameRank = true
  },
  [40] = {
    mode = "multi_arena",
    name = T("\231\167\175\229\136\134\230\142\146\232\161\140"),
    tipsText = T("\231\142\139\232\128\133\231\167\175\229\136\134\239\188\154"),
    systemMode = "MultiArena",
    canSameRank = true
  },
  [41] = {
    mode = "last_season_multi_arena",
    name = T("\228\184\138\232\181\155\229\173\163\231\167\175\229\136\134\230\142\146\232\161\140"),
    tipsText = T("\231\142\139\232\128\133\231\167\175\229\136\134\239\188\154"),
    systemMode = "MultiArena"
  },
  [42] = {
    mode = "local_ms",
    name = T("\230\156\172\230\156\141"),
    tipsText = T("\231\142\139\232\128\133\231\167\175\229\136\134\239\188\154"),
    systemMode = "Multistage",
    itemSize = ed.DGSizeMake(512, 75),
    canSameRank = true
  },
  [43] = {
    mode = "global_ms",
    name = T("\229\133\168\230\156\141"),
    tipsText = T("\231\142\139\232\128\133\231\167\175\229\136\134\239\188\154"),
    systemMode = "Multistage",
    itemSize = ed.DGSizeMake(512, 75),
    canSameRank = true
  },
  [44] = {
    mode = "real_arena_local",
    name = T("\230\156\172\229\156\176\231\167\175\229\136\134\230\142\146\232\161\140"),
    tipsText = T("\231\142\139\232\128\133\231\167\175\229\136\134\239\188\154"),
    systemMode = "RealArena"
  },
  [45] = {
    mode = "local_legend_arena_y",
    name = T("\230\156\172\230\156\141\230\152\168\230\151\165\231\187\147\231\174\151\230\142\146\232\161\140"),
    tipsText = T("\228\188\160\229\165\135\231\171\158\230\138\128\229\156\186\239\188\154"),
    systemMode = "LegendArena",
    canSameRank = true
  },
  [46] = {
    mode = "global_legend_arena_y",
    name = T("\229\133\168\230\156\141\230\152\168\230\151\165\231\187\147\231\174\151\230\142\146\232\161\140"),
    tipsText = T("\228\188\160\229\165\135\231\171\158\230\138\128\229\156\186\239\188\154"),
    systemMode = "LegendArena",
    canSameRank = true
  },
  [47] = {
    mode = "stargate_top_rank",
    name = T("\229\144\141\230\172\161\230\142\146\232\161\140"),
    tipsText = T("\230\183\183\228\185\177\230\152\159\233\151\168\231\167\175\229\136\134\239\188\154"),
    systemMode = "starGate"
  },
  [48] = {
    mode = "stargate_score_rank",
    name = T("\231\167\175\229\136\134\230\142\146\232\161\140"),
    tipsText = T("\230\183\183\228\185\177\230\152\159\233\151\168\231\167\175\229\136\134\239\188\154"),
    systemMode = "starGate",
    canSameRank = true
  },
  [49] = {
    mode = "autochess_rank",
    name = "\230\174\181\228\189\141\230\142\146\232\161\140",
    tipsText = "\230\154\180\232\181\176\230\163\139\230\174\181\228\189\141\230\142\146\232\161\140",
    systemMode = "starGate"
  },
  [50] = {
    mode = "magicstone_rank",
    name = "\230\136\152\229\138\155\230\142\146\232\161\140",
    tipsText = "\231\165\158\232\176\149\231\189\151\231\155\152\230\136\152\229\138\155\230\142\146\232\161\140",
    systemMode = "MagicStone"
  },
  [51] = {
    mode = "seasontower_rank",
    name = "\230\156\172\230\156\141\230\142\146\232\161\140",
    tipsText = "\228\184\135\231\142\139\228\185\139\229\161\148\230\156\172\230\156\141\230\142\146\232\161\140",
    systemMode = "LostLand",
    itemSize = ed.DGSizeMake(512, 75),
    canSameRank = true
  },
  [52] = {
    mode = "seasontower_rank_global",
    name = "\229\133\168\230\156\141\230\142\146\232\161\140",
    tipsText = "\228\184\135\231\142\139\228\185\139\229\161\148\229\133\168\230\156\141\230\142\146\232\161\140",
    systemMode = "LostLand",
    itemSize = ed.DGSizeMake(512, 75),
    canSameRank = true
  },
  [53] = {
    mode = "real_arena",
    name = "\231\167\175\229\136\134\230\142\146\232\161\140",
    tipsText = "\232\175\184\231\142\139\228\186\137\233\156\184\230\174\181\228\189\141\230\142\146\232\161\140",
    systemMode = "real_arena"
  },
  [54] = {
    mode = "collect_point_local",
    name = "\230\148\182\232\151\143\230\156\172\230\156\141",
    tipsText = "\230\148\182\232\151\143\231\167\175\229\136\134\230\156\172\230\156\141\230\142\146\232\161\140\230\166\156"
  },
  [55] = {
    mode = "collection_point_global",
    name = "\230\148\182\232\151\143\229\133\168\230\156\141",
    tipsText = "\230\148\182\232\151\143\231\167\175\229\136\134quan\230\156\141\230\142\146\232\161\140\230\166\156"
  },
  [56] = {
    mode = "solo_rank",
    name = "\231\167\175\229\136\134\230\142\146\232\161\140",
    tipsText = "\229\133\168\230\152\142\230\152\159\231\167\175\229\136\134\230\142\146\232\161\140",
    systemMode = "starGate"
  }
}
local config_str = {
  top_gs = {
    tipsText = T("\230\156\128\233\171\15215\228\186\186\230\128\187\230\136\152\229\138\155")
  },
  full_hero_gs = {
    tipsText = T("\229\133\168\229\145\152\230\128\187\230\136\152\229\138\155")
  },
  hero_team_gs = {
    tipsText = T("\230\156\128\233\171\152\228\186\148\228\186\186\230\136\152\229\138\155")
  },
  hero_arousal = {
    tipsText = T("\230\180\151\231\130\188\230\128\187\229\177\158\230\128\167")
  },
  arousal_cnt = {
    tipsText = T("\232\139\177\233\155\132\232\167\137\233\134\146\230\149\176\233\135\143")
  },
  rune_hero_arousal = {
    tipsText = T("\231\172\166\231\159\179\230\180\151\231\130\188\230\128\187\229\177\158\230\128\167")
  },
  super_arousal_cnt = {
    tipsText = T("\231\165\158\229\153\168\230\149\176\233\135\143")
  },
  honourpoint = {
    tipsText = T("\229\183\133\229\179\176\229\184\129\231\180\175\231\167\175")
  },
  honourpoint_r = {
    tipsText = T("\229\183\133\229\179\176\229\184\129\231\180\175\231\167\175")
  },
  dreamland_individual = {
    tipsText = T("\230\156\128\233\171\152\228\188\164\229\174\179\232\190\147\229\135\186")
  },
  dreamland_guild = {
    tipsText = T("\229\133\172\228\188\154\230\128\187\228\188\164\229\174\179")
  },
  dream_guild_individual = {
    tipsText = T("\230\156\128\233\171\152\228\188\164\229\174\179\232\190\147\229\135\186")
  },
  last_season_real_arena = {
    tipsText = T("\231\142\139\232\128\133\231\167\175\229\136\134")
  },
  playoffs_point = {
    tipsText = T("\231\167\175\229\136\134\232\181\155\231\167\175\229\136\134")
  },
  playoffs_apply = {
    tipsText = T("\231\142\139\232\128\133\231\167\175\229\136\134")
  },
  multi_arena = {
    tipsText = T("\231\142\139\232\128\133\231\167\175\229\136\134")
  },
  last_season_multi_arena = {
    tipsText = T("\231\142\139\232\128\133\231\167\175\229\136\134")
  },
  real_arena_local = {
    tipsText = T("\231\142\139\232\128\133\231\167\175\229\136\134")
  },
  stargate_score_rank = {
    tipsText = T("\230\183\183\228\185\177\230\152\159\233\151\168\231\167\175\229\136\134")
  },
  autochess_rank = {
    tipsText = T("\230\174\181\228\189\141")
  },
  magicstone_rank = {
    tipsText = T("\230\136\152\229\138\155")
  },
  pvp_r = {
    tipsText = T("\229\133\172\228\188\154")
  },
  pvp = {
    tipsText = T("\229\133\172\228\188\154")
  },
  hero_evo_star = {
    tipsText = T("\232\139\177\233\155\132\230\128\187\230\152\159\231\186\167")
  },
  guildliveness = {
    tipsText = T("\228\184\137\229\164\169\230\180\187\232\183\131\229\128\188")
  },
  dreamland_individual_global = {
    tipsText = T("\230\156\128\233\171\152\228\188\164\229\174\179\232\190\147\229\135\186")
  },
  real_arena = {
    tipsText = T("\231\167\175\229\136\134")
  },
  solo_rank = {
    tipsText = T("\231\167\175\229\136\134")
  }
}
local treeList = {
  {
    name = T("<lable color=ccc3(255,245,235) fontSize=f19 strokeColor=rankStrokeColor1 strokeSize=1>\231\171\158\230\138\128\229\156\186</lable> "),
    name2 = T("<lable color=ccc3(66,70,91) fontSize=f19 strokeColor=rankStrokeColor2 strokeSize=2>\231\171\158\230\138\128\229\156\186</lable> "),
    tree = {
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\231\171\158\230\138\128\229\156\186(\229\174\158\230\151\182)</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\231\171\158\230\138\128\229\156\186(\229\174\158\230\151\182)</lable>"),
        limitWidth = 100,
        data = {
          config = config[1]
        }
      },
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\231\171\158\230\138\128\229\156\186(\230\175\143\230\151\165)</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\231\171\158\230\138\128\229\156\186(\230\175\143\230\151\165)</lable>"),
        limitWidth = 100,
        data = {
          config = config[2]
        }
      }
    },
    isVis = "Pvp"
  },
  {
    name = T("<lable color=ccc3(255,245,235) fontSize=f19 strokeColor=rankStrokeColor1 strokeSize=1>\230\136\152\230\150\151\229\138\155</lable> "),
    name2 = T("<lable color=ccc3(66,70,91) fontSize=f19 strokeColor=rankStrokeColor2 strokeSize=2>\230\136\152\230\150\151\229\138\155</lable> "),
    tree = {
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\229\133\168\229\145\152\230\128\187\230\136\152\229\138\155</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\229\133\168\229\145\152\230\128\187\230\136\152\229\138\155</lable>"),
        limitWidth = 100,
        data = {
          config = config[8]
        }
      },
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\229\176\143\233\152\159\230\136\152\229\138\155\230\142\146\232\161\140</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\229\176\143\233\152\159\230\136\152\229\138\155\230\142\146\232\161\140</lable>"),
        limitWidth = 100,
        data = {
          config = config[9]
        }
      },
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\232\139\177\233\155\132\230\152\159\231\186\167\230\142\146\232\161\140</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\232\139\177\233\155\132\230\152\159\231\186\167\230\142\146\232\161\140</lable>"),
        limitWidth = 100,
        data = {
          config = config[10]
        }
      }
    }
  },
  {
    name = T("<lable color=ccc3(255,245,235) fontSize=f19 strokeColor=rankStrokeColor1 strokeSize=1>\229\133\172\228\188\154</lable> "),
    name2 = T("<lable color=ccc3(66,70,91) fontSize=f19 strokeColor=rankStrokeColor2 strokeSize=2>\229\133\172\228\188\154</lable> "),
    tree = {
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\228\184\137\229\164\169\230\128\187\230\180\187\232\183\131</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\228\184\137\229\164\169\230\128\187\230\180\187\232\183\131</lable>"),
        limitWidth = 100,
        data = {
          config = config[3]
        }
      }
    },
    isVis = "Guild"
  },
  {
    name = T("<lable color=ccc3(255,245,235) fontSize=f19 strokeColor=rankStrokeColor1 strokeSize=1>\228\184\187\232\166\129\231\142\169\230\179\149</lable><sprite src=UI/alpha/1080P/rankingscene/arrow_1.png >"),
    name2 = T("<lable color=ccc3(66,70,91) fontSize=f19 strokeColor=rankStrokeColor2 strokeSize=2>\228\184\187\232\166\129\231\142\169\230\179\149</lable><sprite src=UI/alpha/1080P/rankingscene/arrow.png >"),
    limitWidth = 100,
    tree = {
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\230\176\184\231\148\159\230\162\166\229\162\131</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\230\176\184\231\148\159\230\162\166\229\162\131</lable>"),
        limitWidth = 100,
        tree = {
          {
            name = T("<lable color=ccc3(196,196,196) fontSize=f16>\230\156\172\230\156\141</lable>   "),
            name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\230\156\172\230\156\141</lable>   "),
            limitWidth = 100,
            data = {
              config = config[17]
            }
          },
          {
            name = T("<lable color=ccc3(196,196,196) fontSize=f16>\229\133\168\230\156\141</lable>   "),
            name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\229\133\168\230\156\141</lable>   "),
            limitWidth = 100,
            data = {
              config = config[37]
            }
          },
          {
            name = T("<lable color=ccc3(196,196,196) fontSize=f16>\229\133\172\228\188\154\228\188\164\229\174\179\230\128\187\229\146\140</lable>   "),
            name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\229\133\172\228\188\154\228\188\164\229\174\179\230\128\187\229\146\140</lable>   "),
            limitWidth = 100,
            data = {
              config = config[18]
            }
          }
        },
        isVis = "Dreamland"
      },
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\230\154\180\232\181\176\230\163\139</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\230\154\180\232\181\176\230\163\139</lable>"),
        limitWidth = 100,
        tree = {
          {
            name = T("<lable color=ccc3(196,196,196) fontSize=f16>\230\174\181\228\189\141\230\142\146\232\161\140</lable>   "),
            name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\230\174\181\228\189\141\230\142\146\232\161\140</lable>   "),
            limitWidth = 100,
            data = {
              config = config[49]
            }
          }
        }
      },
      not ed.isAreaOverSea() and {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\232\175\184\231\142\139\228\186\137\233\156\184</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\232\175\184\231\142\139\228\186\137\233\156\184</lable>"),
        limitWidth = 100,
        tree = {
          {
            name = T("<lable color=ccc3(196,196,196) fontSize=f16>\231\167\175\229\136\134\230\142\146\232\161\140</lable>   "),
            name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\231\167\175\229\136\134\230\142\146\232\161\140</lable>   "),
            limitWidth = 100,
            data = {
              config = config[53]
            }
          }
        }
      } or nil,
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\230\150\151\232\155\144\232\155\144</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\230\150\151\232\155\144\232\155\144</lable>"),
        limitWidth = 100,
        tree = {
          {
            name = T("<lable color=ccc3(196,196,196) fontSize=f16>\231\167\175\229\136\134\230\142\146\232\161\140</lable>   "),
            name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\231\167\175\229\136\134\230\142\146\232\161\140</lable>   "),
            limitWidth = 100,
            data = {
              config = config[56]
            }
          }
        }
      }
    },
    isVis = "other"
  },
  {
    name = T("<lable color=ccc3(255,245,235) fontSize=f19 strokeColor=rankStrokeColor1 strokeSize=1>\230\148\182\232\151\143</lable> "),
    name2 = T("<lable color=ccc3(66,70,91) fontSize=f19 strokeColor=rankStrokeColor2 strokeSize=2>\230\148\182\232\151\143</lable> "),
    tree = {
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\230\156\172\230\156\141</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\230\156\172\230\156\141</lable>"),
        limitWidth = 100,
        data = {
          config = config[54]
        }
      },
      {
        name = T("<lable color=ccc3(196,196,196) fontSize=f16>\229\133\168\230\156\141</lable>"),
        name2 = T("<lable color=ccc3(255,245,235) fontSize=f16>\229\133\168\230\156\141</lable>"),
        limitWidth = 100,
        data = {
          config = config[55]
        }
      }
    },
    isVis = "other"
  }
}
local sendDataConfig = {
  local_legend_arena = {
    type = "legend_arena",
    board = "dynamic",
    custom = 1
  },
  global_legend_arena = {
    type = "legend_arena",
    board = "dynamic",
    custom = 0
  },
  local_legend_arena_y = {
    type = "legend_arena",
    board = "static",
    custom = 1
  },
  global_legend_arena_y = {
    type = "legend_arena",
    board = "static",
    custom = 0
  },
  dreamland_individual = {
    type = "dreamland_individual",
    board = "dynamic"
  },
  dreamland_guild = {
    type = "dreamland_guild",
    board = "dynamic"
  },
  dreamland_individual_multi = {
    type = "dreamland_individual_multi",
    board = "static"
  },
  dreamland_individual_global = {
    type = "dreamland_individual_global",
    board = "static"
  },
  dream_guild_individual = {
    type = "dream_guild_individual",
    board = "static"
  },
  real_arena = {type = "real_arena", board = "static"},
  real_arena_local = {
    type = "real_arena_local",
    board = "static"
  },
  last_season_real_arena = {
    type = "last_season_real_arena",
    board = "static"
  },
  playoffs_apply = {
    type = "playoffs_apply",
    board = "static"
  },
  playoffs_point = {
    type = "playoffs_point",
    board = "static"
  },
  multi_arena = {
    type = "multi_arena",
    board = "static"
  },
  last_season_multi_arena = {
    type = "last_season_multi_arena",
    board = "static"
  },
  guildliveness = {
    type = "guildliveness"
  },
  full_hero_gs = {
    type = "full_hero_gs"
  },
  hero_team_gs = {
    type = "hero_team_gs"
  },
  hero_evo_star = {
    type = "hero_evo_star"
  },
  hero_arousal = {
    type = "hero_arousal"
  },
  arousal_cnt = {
    type = "arousal_cnt"
  },
  super_arousal_cnt = {
    type = "super_arousal_cnt"
  },
  rune_hero_arousal = {
    type = "rune_hero_arousal"
  },
  local_ms = {
    type = "multi_stage",
    board = "local"
  },
  global_ms = {
    type = "multi_stage",
    board = "global"
  },
  stargate_top_rank = {
    type = "stargate_rank"
  },
  stargate_score_rank = {
    type = "stargate_score_rank"
  },
  autochess_rank = {
    type = "chess_score_rank"
  },
  magicstone_rank = {
    type = "magicstone_gs"
  },
  seasontower_rank = {
    type = "season_tower_rank",
    board = "local"
  },
  seasontower_rank_global = {
    type = "season_tower_rank",
    board = "global"
  },
  solo_rank = {
    type = "solo_score_rank"
  },
  collect_point_local = {
    type = "collect_point_local"
  },
  collection_point_global = {
    type = "collection_point_global"
  }
}
ranklistData.myInfo = {}
ranklistData.rankData = {}

function ranklistData:getTreeList()
  self.treeList = {}
  for treeid, tree in ipairs(ed.copyTable(treeList)) do
    if tree.isVis and tree.isVis == "other" then
      local trees = {
        name = tree.name,
        name2 = tree.name2,
        tree = {},
        isVis = "other",
        limitWidth = tree.limitWidth
      }
      for i, v in ipairs(tree.tree) do
        if v.isVis and ed.playerlimit:moduleIsOpened(v.isVis) or not v.isVis then
          table.insert(trees.tree, v)
        end
      end
      table.insert(self.treeList, trees)
    elseif tree.isVis and ed.playerlimit:moduleIsOpened(tree.isVis) or not tree.isVis then
      table.insert(self.treeList, tree)
    end
  end
  return self.treeList
end

function ranklistData:getTreeListIndex(level, index)
  if level == 0 then
    return 1, 1
  end
  local name = treeList[level].tree[index].name
  local newLevel, newIndex = level, index
  for treeid, tree in ipairs(self.treeList or treeList) do
    newLevel = treeid
    for i, v in ipairs(tree.tree) do
      newIndex = i
      if v.name == name then
        return newLevel, newIndex
      end
    end
  end
  return newLevel, newIndex
end

function ranklistData:transferPvpList(mode, data)
  local cfgStr = self:getConfigStr(mode)
  local listData = {}
  local myInfo
  data = data._rank_list or {}
  for i, v in ipairs(data) do
    local vv = v[".data"] or {}
    local summary = vv._summary
    if summary then
      local config = {
        user_id = v._user_id,
        name = summary._name,
        vip = summary._vip,
        uid = summary._uid,
        babel_level = summary._babel_level,
        avatar = summary._avatar,
        level = summary._level,
        guild_name = summary._guild_name,
        rankNum = i,
        cfgStr = cfgStr,
        roleId = summary._role_id,
        medal = summary._medal
      }
      table.insert(listData, config)
      if not myInfo and summary._uid == ed.getUserid() and summary._role_id == ed.getRoleId() then
        myInfo = config
      end
    end
  end
  self.myInfo[mode] = myInfo
  self.rankData[mode] = listData
end

function ranklistData:transferList(mode, data)
  local cfgStr = self:getConfigStr(mode)
  local listData = {}
  local myInfo, myUid, myRid, selfItem, selfRank
  if data._self_item then
    local vv = data._self_item[".data"] or {}
    local summary = vv._user_summary
    summary = summary or vv._guild_summary or {}
    summary = summary[".data"] or summary
    myUid = summary._uid
    myRid = summary._role_id
    selfItem = data._self_item
    selfRank = data._self_ranking
  end
  data = data._ranklist_item or {}
  for i, v in ipairs(data) do
    local vv = v[".data"] or {}
    local summary = vv._user_summary
    summary = summary or vv._guild_summary or {}
    summary = summary[".data"] or summary
    local president = summary._president or {}
    president = president[".data"] or president
    if summary._name then
      local config = {
        param1 = v._param1,
        param2 = v._param2,
        param3 = v._param3,
        name = summary._name,
        vip = summary._vip,
        uid = summary._uid,
        id = summary._id or 0,
        babel_level = summary._babel_level,
        avatar = summary._avatar,
        level = summary._level,
        rankNum = i,
        cfgStr = cfgStr,
        roleId = summary._role_id,
        member_cnt = summary._member_cnt,
        slogan = summary._slogan or "",
        president = president or {},
        medal = summary._medal
      }
      table.insert(listData, config)
      if not myInfo and myUid and summary._uid == myUid and myRid and summary._role_id == myRid then
        myInfo = config
      end
    end
  end
  if not myInfo and selfItem then
    local v = selfItem[".data"] or {}
    local summary = v._user_summary
    summary = summary or v._guild_summary
    if summary then
      summary = summary[".data"] or summary
      local president = summary._president or {}
      president = president[".data"] or president
      myInfo = {
        param1 = v._param1,
        param2 = v._param2,
        param3 = v._param3,
        name = summary._name,
        vip = summary._vip,
        uid = summary._uid,
        id = summary._id or 0,
        babel_level = summary._babel_level,
        avatar = summary._avatar,
        level = summary._level,
        rankNum = selfRank,
        cfgStr = cfgStr,
        roleId = summary._role_id,
        member_cnt = summary._member_cnt,
        slogan = summary._slogan or "",
        president = president or {},
        medal = summary._medal
      }
    end
  end
  if not myInfo and (mode == "collect_point_local" or mode == "collection_point_global") then
    myInfo = {
      name = ed.player:getName(),
      vip = 0,
      uid = ed.getUserid(),
      avatar = ed.player:getAvatar(),
      level = ed.player:getLevel(),
      rankNum = 0,
      cfgStr = cfgStr,
      roleId = ed.getRoleId(),
      param1 = 0,
      param2 = 0
    }
  end
  self.myInfo[mode] = myInfo
  self.rankData[mode] = listData
end

function ranklistData:getModeListMyData(mode, data)
  return self.myInfo[mode] or {}
end

function ranklistData:setModeListData(mode, data)
  self.rankData[mode] = data or {}
end

function ranklistData:setModeListDataNil(mode)
  self.rankData[mode] = nil
end

function ranklistData:getModeListData(mode)
  return self.rankData[mode] or "nil"
end

function ranklistData:getDataConfig(mode)
  return sendDataConfig[mode] or {}
end

function ranklistData:getConfigStr(mode)
  return config_str[mode] or {}
end

ed.uieditor = ed.uieditor or {}
ed.uieditor.battlePreparePages = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(207.5, 540)
    },
    t = "Layer",
    base = {
      name = "Panel_Pages",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
      name = "Panel_dreamland",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 61)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "Panel_dreamland",
      name = "ysmj_modPos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(103, 273)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6277",
      z = 0,
      parent = "Panel_dreamland",
      text = T("BOSS\228\187\139\231\187\141:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12.5, 229)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_title",
      z = 0,
      parent = "Panel_Pages",
      text = "",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 509)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6277_Copy0",
      z = 0,
      parent = "Panel_dreamland",
      text = T("\228\187\138\230\151\165\229\137\169\228\189\153\230\172\161\230\149\176\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89, 23)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "Panel_dreamland",
      name = "ysmj_num_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(157.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
      name = "Panel_crusade",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 61)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(180, 100)
    },
    t = "Layer",
    base = {
      parent = "Panel_dreamland",
      name = "ysmj_monster_txt",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12.5, 112.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
      name = "Panel_stageDetail",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 61)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
      name = "Panel_attack",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 61)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "yz_level_1",
      z = 0,
      parent = "Panel_crusade",
      text = T("\231\173\137    \231\186\167:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 262.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 185, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_crusade",
      res = "UI/alpha/1080P/battle/battle_prepare_name_bg.png",
      name = "yuanzheng_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 298.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
      name = "Panel_exerciseStageDetail",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 61)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 227, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "yz_level_2",
      z = 0,
      parent = "Panel_crusade",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(193, 262.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "yz_guil_1",
      z = 0,
      parent = "Panel_crusade",
      text = T("\229\133\172    \228\188\154:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 237)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
      name = "Panel_FancyTower",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 61)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "yz_guil_2",
      z = 0,
      parent = "Panel_crusade",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(193, 237)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "det_xiao",
      z = 0,
      parent = "Panel_stageDetail",
      text = T("\228\189\147\229\138\155\230\182\136\232\128\151:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 312.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "Panel_crusade",
      name = "Panel_headPos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(103, 362.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "gaveitm",
      z = 0,
      parent = "Panel_stageDetail",
      text = T("\231\187\147\231\174\151\229\165\150\229\138\177:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 278.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
      name = "Panel_ActivityAdventure",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 61)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "Panel_stageDetail",
      name = "tiLiPos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(95, 313)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "yuanzheng_name",
      z = 0,
      parent = "yuanzheng_name_bg",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92.5, 14)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 100)
    },
    t = "Layer",
    base = {
      parent = "Panel_stageDetail",
      name = "gaveItemPos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(15, 163.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
      name = "Panel_FancyAbyss",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 61)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(178, 80)
    },
    t = "Layer",
    base = {
      parent = "Panel_stageDetail",
      name = "detBossTxt",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13.5, 336)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 185, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_attack",
      res = "UI/alpha/1080P/battle/battle_prepare_name_bg.png",
      name = "jjc_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104, 298.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "Panel_attack",
      name = "jjc_headPos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(102.5, 362)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
      name = "Panel_share_fight",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 61)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 150)
    },
    t = "Layer",
    base = {
      parent = "Panel_attack",
      name = "jjc_titStrpanel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4, 131.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
      name = "Panel_HadesHeat",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 56)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "Panel_exerciseStageDetail",
      name = "shuiCi_modPos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(103, 273)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "shuiCi_6277",
      z = 0,
      parent = "Panel_exerciseStageDetail",
      text = T("\231\187\147\231\174\151\229\165\150\229\138\177:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 220.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
      name = "Panel_GuildClash",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 56)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6277shuiCi",
      z = 0,
      parent = "Panel_exerciseStageDetail",
      text = T("\228\187\138\230\151\165\229\137\169\228\189\153\230\172\161\230\149\176\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89, 23)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "Panel_exerciseStageDetail",
      name = "shuiCi_num_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(157.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
      name = "Panel_GuildMount",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 61)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(180, 100)
    },
    t = "Layer",
    base = {
      parent = "Panel_exerciseStageDetail",
      name = "shuiCi_monster_txt",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12.5, 104)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_tower",
      z = 0,
      parent = "Panel_FancyTower",
      text = T("\233\155\134\230\152\159\230\157\161\228\187\182:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18, 392)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "jjc_role_name",
      z = 0,
      parent = "jjc_name_bg",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92.5, 14)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(178, 80)
    },
    t = "Layer",
    base = {
      parent = "Panel_exerciseStageDetail",
      name = "exercise_txt",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13, 335.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_tower_mon",
      z = 0,
      parent = "Panel_FancyTower",
      text = T("\230\182\136\232\128\151\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(49, 23)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(180, 120)
    },
    t = "Layer",
    base = {
      parent = "Panel_FancyTower",
      name = "tower_txt",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12.5, 250)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(180, 100)
    },
    t = "Layer",
    base = {
      parent = "Panel_FancyTower",
      name = "tower_item_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12, 102.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_tower_item",
      z = 0,
      parent = "Panel_FancyTower",
      text = T("\233\128\154\229\133\179\229\165\150\229\138\177:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18, 220)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_adventure_mon",
      z = 0,
      parent = "Panel_ActivityAdventure",
      text = T("\230\182\136\232\128\151\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(49, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "jjc_level_1",
      z = 0,
      parent = "jjc_titStrpanel",
      text = T("\231\173\137    \231\186\167:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 130.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 227, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "jjc_level_2",
      z = 0,
      parent = "jjc_titStrpanel",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(188.5, 130.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(247, 162, 27),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_mony",
      z = 0,
      parent = "Panel_FancyTower",
      text = "99",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108, 23)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(180, 100)
    },
    t = "Layer",
    base = {
      parent = "Panel_ActivityAdventure",
      name = "adventure_item_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12, 102.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "jjc_zhanLi_1",
      z = 0,
      parent = "jjc_titStrpanel",
      text = T("\230\128\187 \230\136\152 \229\138\155:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 31)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 225, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "jjc_zhanLi_2",
      z = 0,
      parent = "jjc_titStrpanel",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(188.5, 31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4, x = 0.4},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_FancyTower",
      res = "UI/alpha/1080P/icon/fancytower_candle.png",
      name = "img_mony",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142, 25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_adventure_item",
      z = 0,
      parent = "Panel_ActivityAdventure",
      text = T("\233\128\154\229\133\179\229\165\150\229\138\177:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17, 220)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(124, 192, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "jjc_paim_2",
      z = 0,
      parent = "jjc_titStrpanel",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(188.5, 81)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "jjc_paim_1",
      z = 0,
      parent = "jjc_titStrpanel",
      text = T("\229\189\147\229\137\141\230\142\146\229\144\141:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 81)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(247, 162, 27),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_adventure_cost",
      z = 0,
      parent = "Panel_ActivityAdventure",
      text = "99",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "jjc_shenLi_2",
      z = 0,
      parent = "jjc_titStrpanel",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(188.5, 56)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "jjc_shenLi_1",
      z = 0,
      parent = "jjc_titStrpanel",
      text = T("\232\131\156 \229\156\186 \230\149\176:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 56)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_ActivityAdventure",
      res = "UI/alpha/1080P/activityadventure/actvitality/adventure_vitality_icon_1.png",
      name = "img_money",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142, 25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(180, 100)
    },
    t = "Layer",
    base = {
      parent = "Panel_FancyAbyss",
      name = "fancyabyss_item_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12, 182.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "jjc_guild_2",
      z = 0,
      parent = "jjc_titStrpanel",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(188.5, 106)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "jjc_guild_1",
      z = 0,
      parent = "jjc_titStrpanel",
      text = T("\229\133\172    \228\188\154:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 106)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(178, 80)
    },
    t = "Layer",
    base = {
      parent = "Panel_ActivityAdventure",
      name = "adventure_stage_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12.5, 335)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_fancyabyss_item",
      z = 0,
      parent = "Panel_FancyAbyss",
      text = T("\233\128\154\229\133\179\229\165\150\229\138\177:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17, 300)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 25)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_6740",
      z = 0,
      parent = "jjc_titStrpanel",
      res = "UI/alpha/1080P/battle/battle_prepare_txt_bg.png",
      capInsets = CCRectMake(50, 5, 30, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.5, 56)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 25)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_6740_Copy0",
      z = 0,
      parent = "jjc_titStrpanel",
      res = "UI/alpha/1080P/battle/battle_prepare_txt_bg.png",
      capInsets = CCRectMake(50, 5, 30, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.5, 105.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(178, 80)
    },
    t = "Layer",
    base = {
      parent = "Panel_FancyAbyss",
      name = "fancyabyss_stage_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12.5, 335)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_FancyAbyss",
      res = "UI/alpha/1080P/skilltower/abyss/abyss_totaltime_icon.png",
      name = "img_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25, 300.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 191, h = 1},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_FancyAbyss",
      res = "UI/alpha/1080P/skilltower/abyss/abyss_line.png",
      name = "bg_buff",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 310.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 185, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_share_fight",
      res = "UI/alpha/1080P/battle/battle_prepare_name_bg.png",
      name = "share_fight_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104, 298.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "Panel_share_fight",
      name = "share_fight_headPos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(102.5, 362)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 150)
    },
    t = "Layer",
    base = {
      parent = "Panel_share_fight",
      name = "share_fight_titStrpanel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4, 131.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
      name = "Panel_AwakeStage",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 61)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "Panel_HadesHeat",
      name = "hades_boss_pos",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(50.5, 253)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "hades_heat_boss_desc",
      z = 0,
      parent = "Panel_HadesHeat",
      text = T("\231\165\158\231\129\181\230\173\166\229\163\171"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(103.5, 238.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 240, h = 59},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_HadesHeat",
      res = "UI/alpha/1080P/hades/hades_prepare_heat_bg.png",
      name = "hades_heat_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 68)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 268.5, h = 236},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_HadesHeat",
      res = "UI/alpha/1080P/nianmonster/nian_pre_firework_tattoo.png",
      name = "image_firework_tattoo",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103, 369)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_firework",
      z = 0,
      parent = "Panel_HadesHeat",
      text = T("\231\136\134\231\171\185\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(27, 150.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "Panel_GuildClash",
      name = "guildClash_boss_pos",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(54.5, 279)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(56, 56)
    },
    t = "Layer",
    base = {
      parent = "Panel_HadesHeat",
      name = "panel_firework",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(74, 113)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guildClash_tips1",
      z = 0,
      parent = "Panel_GuildClash",
      text = T("\229\133\172\228\188\154\233\152\159\228\188\141\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(89.5, 259)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guildClash_guild_team_amount",
      z = 0,
      parent = "Panel_GuildClash",
      text = "123",
      size = 16
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(127, 259)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guildClash_my_team_amount",
      z = 0,
      parent = "Panel_GuildClash",
      text = "1",
      size = 16
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(127, 226.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guildClash_tips2",
      z = 0,
      parent = "Panel_GuildClash",
      text = T("\230\136\145\231\154\132\233\152\159\228\188\141\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(89.5, 227)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "Panel_GuildMount",
      name = "boss_modPos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(103, 273)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 220.5, h = 97.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_GuildClash",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/formation_nature_titlefloor.png",
      name = "guildClash_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103, 457.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(190, 5)
    },
    t = "Layer",
    base = {
      parent = "Panel_GuildMount",
      name = "boss_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9, 227.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(0.5, 0.5)
    },
    t = "Layer",
    base = {
      parent = "Panel_GuildMount",
      name = "stage_buff",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(103, 96.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4565",
      z = 0,
      parent = "img_time",
      text = T("\230\156\128\231\159\173\232\128\151\230\151\182"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(33.5, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "share_fight_role_name",
      z = 0,
      parent = "share_fight_name_bg",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92.5, 14)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_fancyabyss_time",
      z = 0,
      parent = "img_time",
      text = "00:30:25",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149.5, 20.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(180.5, 119)
    },
    t = "Layer",
    base = {
      parent = "bg_buff",
      name = "layer_buff",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(3.5, -121)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "share_fight_level_1",
      z = 0,
      parent = "share_fight_titStrpanel",
      text = T("\231\173\137    \231\186\167:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 130.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 227, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "share_fight_level_2",
      z = 0,
      parent = "share_fight_titStrpanel",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(188.5, 130.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "share_fight_zhanLi_1",
      z = 0,
      parent = "share_fight_titStrpanel",
      text = T("\230\128\187 \230\136\152 \229\138\155:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 81.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 225, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "share_fight_zhanLi_2",
      z = 0,
      parent = "share_fight_titStrpanel",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(188.5, 81.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "share_fight_guild_2",
      z = 0,
      parent = "share_fight_titStrpanel",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(188.5, 106)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "share_fight_guild_1",
      z = 0,
      parent = "share_fight_titStrpanel",
      text = T("\229\133\172    \228\188\154:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 106)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 25)
    },
    t = "Scale9Sprite",
    base = {
      name = "share_fight_image1",
      z = 0,
      parent = "share_fight_titStrpanel",
      res = "UI/alpha/1080P/battle/battle_prepare_txt_bg.png",
      capInsets = CCRectMake(50, 5, 30, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.5, 105.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_heat",
      z = 0,
      parent = "hades_heat_bg",
      text = "1234",
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85.5, 31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68, h = 67},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "hades_heat_bg",
      res = "UI/alpha/1080P/hades/hades_hot.png",
      name = "image_heat_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154.5, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.6, h = 30.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "hades_heat_bg",
      res = "UI/alpha/1080P/hero/hero_info_detail_bg.png",
      name = "hades_heat_btn_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guildClash_title",
      z = 0,
      parent = "guildClash_title_bg",
      text = T("\228\184\173\232\183\175\229\184\131\233\152\178"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.25, 45.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Buff_title",
      z = 0,
      parent = "stage_buff",
      text = T("\233\173\148\231\129\181\233\162\134\229\159\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 57.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42.5, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "guildClash_title_bg",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/tab_midroad_selected.png",
      name = "guildClash_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.25, 44.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(190, 92.5)
    },
    t = "Layer",
    base = {
      parent = "stage_buff",
      name = "buff_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-94.5, -52)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "as_energy_title",
      z = 0,
      parent = "Panel_AwakeStage",
      text = T("\232\131\189\233\135\143\230\182\136\232\128\151:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(13.5, 312.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "as_reward_title",
      z = 0,
      parent = "Panel_AwakeStage",
      text = T("\231\187\147\231\174\151\229\165\150\229\138\177:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(13.5, 278.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 100)
    },
    t = "Layer",
    base = {
      parent = "Panel_AwakeStage",
      name = "as_reward_panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(15, 163.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(178, 80)
    },
    t = "Layer",
    base = {
      parent = "Panel_AwakeStage",
      name = "as_des",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13.5, 336)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_AwakeStage",
      res = "UI/alpha/1080P/icon/dungeon_energy.png",
      name = "as_power_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(127.5, 312.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "as_power_number",
      z = 0,
      parent = "Panel_AwakeStage",
      text = "12",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(92.5, 312.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 100)
    },
    t = "Layer",
    base = {
      parent = "Panel_AwakeStage",
      name = "as_efficiency_panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(15, 25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "as_efficiency_title",
      z = 0,
      parent = "Panel_AwakeStage",
      text = T("\230\137\171\232\141\161\230\149\136\231\142\135\230\143\144\229\141\135\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(13.5, 140)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_AwakeStage",
      res = "UI/alpha/1080P/dungeon/stageinfo/buff_icon_bg.png",
      name = "as_buff_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 117.5)
    },
    t = "Layer",
    base = {
      parent = "Panel_AwakeStage",
      name = "as_condition_panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(15, 115.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "as_condition_title",
      z = 0,
      parent = "Panel_AwakeStage",
      text = T("\232\142\183\232\131\156\230\157\161\228\187\182\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(13.5, 248)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "hades_heat_btn_detail",
      res = "UI/alpha/1080P/hero/hero_info_detail.png",
      name = "ImageView_749",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 17)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 192, 92),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "as_buff",
      z = 0,
      parent = "as_buff_bg",
      text = T("200%\229\188\186\229\140\150"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(36.75, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "as_buff_bg",
      res = "UI/alpha/1080P/dungeon/stageinfo/buff_icon.png",
      name = "ImageView_848",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.75, 11.5)
    }
  }
}

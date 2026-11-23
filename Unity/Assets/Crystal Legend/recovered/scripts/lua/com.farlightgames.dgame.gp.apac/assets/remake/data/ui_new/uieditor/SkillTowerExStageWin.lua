ed.uieditor = ed.uieditor or {}
ed.uieditor.SkillTowerExStageWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(196, 508.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 126.5, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/skilltower/title_tower1.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(186.75, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skilltower/abyss/abyss_rank_icon.png",
      name = "btn_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(828.5, 507)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg_title",
      name = "layer_buff",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-84.75, -486.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "icon_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 267, h = 41.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skilltower/abyss/abyss_totaltime_bg.png",
      name = "bg_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(670.5, 506.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_rank",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "icon_redLight",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.4, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_buff",
      res = "UI/alpha/1080P/common/milestone_loot_raise.png",
      name = "buff1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(352.5, 503.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.4, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_buff",
      res = "UI/alpha/1080P/common/crusade_buff_energe.png",
      name = "buff2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(390, 503.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 156),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank",
      z = 0,
      parent = "btn_rank",
      text = T("\231\171\158\233\128\159\230\142\146\232\161\140"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.4, h = 32.4},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_buff",
      res = "UI/alpha/1080P/common/crusade_buff_double.png",
      name = "buff3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(427.5, 504)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.4, h = 33},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_buff",
      res = "UI/alpha/1080P/common/crusade_buff_energe.png",
      name = "buff4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(465, 504)
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
    base = {name = "layer_main", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(466, 293.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124, h = 41},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skilltower/abyss/abyss_buff_icon.png",
      name = "btn_buff",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(957, 507)
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
      parent = "bg_time",
      res = "UI/alpha/1080P/skilltower/abyss/abyss_totaltime_icon.png",
      name = "icon_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.5, 22.75)
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
      name = "label_time",
      z = 0,
      parent = "bg_time",
      text = T("\229\176\154\230\156\170\233\128\154\229\133\179\229\133\168\233\131\168\229\177\130\230\149\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(87.5, 22.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 215, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skilltower/abyss/abyss_countdown_bg_1.png",
      name = "bg_endtime",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(711.5, 457)
    },
    t = "Scale9Sprite",
    base = {
      name = "frame_main",
      z = 1,
      parent = "layer_main",
      res = "UI/alpha/1080P/skilltower/frame_stage.png",
      capInsets = CCRectMake(150, 150, 150, 150)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111.5, -28)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 156),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buff",
      z = 0,
      parent = "btn_buff",
      text = T("\230\156\172\230\156\159\230\149\136\230\158\156"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 223.5, h = 129.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame_main",
      res = "UI/alpha/1080P/skilltower/abyss/abyss_floor_choose_frame.png",
      name = "light_frame",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-87.75, 237)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(711, 457)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_stage_lock",
      z = 2,
      parent = "frame_main",
      res = "UI/alpha/1080P/skilltower/bg_unstage_tower1.png",
      capInsets = CCRectMake(150, 150, 150, 150)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(354.25, 228.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 960, h = 540},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame_main",
      res = "UI/alpha/1080P/battle_bg/bbg_island_mirage.jpg",
      name = "bg_stage",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355.75, 228.5)
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
      parent = "frame_main",
      name = "layer_battle",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(355.75, 228.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(149, 123, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_5123",
      z = 0,
      parent = "bg_endtime",
      text = T("\233\135\141\231\187\132\229\128\146\232\174\161\230\151\182\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(664, 416)
    },
    t = "Layer",
    base = {
      parent = "frame_main",
      name = "layer_enemy",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(22.75, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -136.5, h = 110},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame_main",
      res = "UI/alpha/1080P/summon/new/summon_rule_arrow.png",
      name = "arrow_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.75, 234.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17, h = 17},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_endtime",
      res = "UI/alpha/1080P/skilltower/main_tower_countdown_icon.png",
      name = "ImageView_5124",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 136.5, h = 110},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame_main",
      res = "UI/alpha/1080P/summon/new/summon_rule_arrow.png",
      name = "arrow_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(661.25, 234.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 231, 247),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_5125",
      z = 0,
      parent = "bg_endtime",
      text = T("12\229\164\1691\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(128.5, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 247, 152),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4672",
      z = 0,
      parent = "bg_stage_lock",
      text = T("\229\189\147\229\137\141\229\177\130\231\186\167"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355.5, 247.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 247, 152),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_unlock_contition",
      z = 0,
      parent = "bg_stage_lock",
      text = T("\230\136\152\233\152\159\232\190\190\229\136\176\231\173\137\231\186\16746\231\186\167\229\144\142\229\188\128\230\148\190\230\140\145\230\136\152"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355.5, 209)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 253, h = 101.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/skilltower/abyss/abyss_player_info.png",
      name = "bg_playerinfo",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-332, -151.5)
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
      parent = "layer_battle",
      name = "layer_right",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125.5, h = 44.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/skilltower/abyss/abyss_floorname_bg.png",
      name = "bg_floor",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-0.5, 184.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.999989, h = 65.999989},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_playerinfo",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 39.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 100),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guild",
      z = 0,
      parent = "bg_playerinfo",
      text = T("\228\188\151\231\165\158\228\185\139\229\183\133"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(67.5, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3716",
      z = 0,
      parent = "bg_playerinfo",
      text = T("\229\133\168\230\156\141\230\156\128\229\191\171\232\174\176\229\189\149"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(14.5, 85.25)
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
      name = "label_name",
      z = 0,
      parent = "bg_playerinfo",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(66.5, 49.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 40)
    },
    t = "Layer",
    base = {
      parent = "layer_right",
      name = "layer_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(117, -133)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reward",
      z = 0,
      parent = "layer_right",
      text = T("\233\128\154\229\133\179\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(318.5, -79)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(137.5, 45),
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(10, 22, 0.5, 19.5),
      name = "btn_start",
      z = 0,
      parent = "layer_right",
      text = "",
      press = "UI/alpha/1080P/common/button_com_big.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(257.5, -176)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_passtime1",
      z = 0,
      parent = "layer_right",
      text = T("\233\128\154\229\133\179\230\151\182\233\151\180"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(318.5, -115)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_passtime2",
      z = 0,
      parent = "layer_right",
      text = "22:10:00",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(318.5, -138)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 119),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_floor",
      z = 0,
      parent = "bg_floor",
      text = T("\231\172\172\228\184\128\229\177\130"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 23.75)
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
      name = "label_wave",
      z = 0,
      parent = "bg_floor",
      text = T("\231\172\1723/3\230\179\162"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.25, -0.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.4, h = 59.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_right",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(296, 177)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_start",
      z = 0,
      parent = "btn_start",
      text = T("\230\140\145 \230\136\152"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.75, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.599998464, h = 26.399998416},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_start",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "icon_battle",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.25, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.11, x = 1.11},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.06, h = 41.625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_record",
      res = "UI/alpha/1080P/pvp/record.png",
      name = "icon_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 32)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.11, x = 1.11},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_record",
      z = 0,
      parent = "btn_record",
      text = T("\233\128\154\229\133\179\232\174\176\229\189\149"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 5.5)
    }
  }
}

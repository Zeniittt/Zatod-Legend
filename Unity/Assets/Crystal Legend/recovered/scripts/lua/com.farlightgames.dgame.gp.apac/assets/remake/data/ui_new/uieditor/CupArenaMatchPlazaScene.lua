ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaMatchPlazaScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 642.5, h = 387},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_bg_2.png",
      name = "bg_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292.5, 185.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 168, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_defense_button.png",
      name = "btn_defense",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(455.5, 44)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1320, 100)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(200, 55, 500, 5),
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_bg_1.png",
      name = "bg_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, -25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(134.5, 100)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(0, 57.5, 0.5, 2.5),
      res = "UI/alpha/1080P/toparena/toparena_bg_1.png",
      name = "bg_challenge",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(814, -74)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(134.5, 100)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(0, 57.5, 0.5, 2.5),
      res = "UI/alpha/1080P/toparena/toparena_bg_1.png",
      name = "bg_camp",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(641, -62.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "panel_challenge",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "panel_match",
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
      fix_wh = {w = 750, h = 520},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_match",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_player_bg.png",
      name = "bg_my_info",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(689.5, 289)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 301, h = 400.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_match",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_camp_gate.png",
      name = "img_hero_frame",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(25, 113)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.2, h = 25.85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_defense",
      res = "UI/alpha/1080P/pvp/lineup.png",
      name = "ImageView_11167",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.5, 20.5)
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
      name = "label_defense",
      z = 0,
      parent = "btn_defense",
      text = T("\233\152\178\229\174\136\233\152\181\229\174\185"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 359, h = 91},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_match",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_camp_info_bg2.png",
      name = "bg_camp_info",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(173.5, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 263, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_hero_frame",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_camp_name.png",
      name = "bg_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149.5, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1320, 270)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(300, 130, 570, 40),
      res = "UI/alpha/1080P/cuparena/cuparena_dec.png",
      name = "img_cloud",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, -98)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 155, h = 53},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_challenge",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_tab_2.png",
      name = "btn_challenge",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.25, 105.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 155, h = 53},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_camp",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_tab_2.png",
      name = "btn_camp",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.25, 105.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 311.5, h = 41.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_player_info.png",
      name = "bg_my_score",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487, 363.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 311.5, h = 41.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_player_info.png",
      name = "bg_my_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487.5, 319)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 311.5, h = 41.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_player_info.png",
      name = "bg_my_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487.5, 274.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150, h = 150},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_info",
      res = "UI/alpha/1080P/cuparena/cuparena_rank_medal_1.png",
      name = "img_my_grade",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(215, 317)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 162, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_rank_bg.png",
      name = "bg_my_grade_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(215, 241.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 263, h = 105.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_time_bg.png",
      name = "bg_start_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(432.5, 137.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75, h = 75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_camp_info",
      res = "UI/alpha/1080P/cuparena/cuparena_camp_symbol_min_1.png",
      name = "img_camp",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_camp_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_camp_task_icon.png",
      name = "btn_task",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(316.5, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 189.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_camp_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_camp_info_bg1.png",
      name = "ImageView_11142_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184, 61)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 189.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_camp_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_camp_info_bg1.png",
      name = "ImageView_11142_Copy2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184, 32)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(314.5, 100)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_dialog",
      z = 0,
      parent = "panel_match",
      res = "UI/alpha/1080P/cuparena/cuparena_dialog_frame.png",
      capInsets = CCRectMake(50, 42.5, 0.5, 5)
    },
    layout = {
      anchor = ccp(0, 0.67),
      position = ccp(220, 380)
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
      name = "label_rank_for_camp",
      z = 0,
      parent = "ImageView_11142_Copy1",
      text = T("\233\152\181\232\144\165\230\142\146\229\144\141\239\188\1541"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(28.75, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 311.5, h = 41.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_player_info.png",
      name = "bg_my_total_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487, 230)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131.75, h = 45.05},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_challenge",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_tab_2.png",
      name = "btn_challenge_dark",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.25, 103.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131.75, h = 45.05},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_camp",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_tab_2.png",
      name = "btn_camp_dark",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.25, 103.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_challenge",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_tab_icon_1.png",
      name = "ImageView_11171_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 36)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 255, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_challenge_down",
      z = 0,
      parent = "btn_challenge",
      text = T("\230\140\145\230\136\152"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91, 35)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 255, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_challenge_up",
      z = 0,
      parent = "btn_challenge",
      text = T("\230\140\145\230\136\152"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91, 35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_camp",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_tab_icon.png",
      name = "ImageView_11171_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 36)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 255, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_camp_down",
      z = 0,
      parent = "btn_camp",
      text = T("\233\152\181\232\144\165"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91, 35)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 255, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_camp_up",
      z = 0,
      parent = "btn_camp",
      text = T("\233\152\181\232\144\165"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91, 35)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 253, 242),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_my_score",
      z = 0,
      parent = "bg_my_score",
      text = T("\231\167\175\229\136\134\239\188\1541"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(52.25, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 253, 242),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_my_medal",
      z = 0,
      parent = "bg_my_medal",
      text = T("\229\139\139\231\171\160\239\188\1541"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(52.25, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_medal",
      res = "UI/alpha/1080P/toparena/toparena_star_icon_2.png",
      name = "img_my_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(165.25, 20.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 253, 242),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_my_rank",
      z = 0,
      parent = "bg_my_rank",
      text = T("\233\152\181\232\144\165\229\134\133\230\142\146\229\144\141\239\188\1541"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(52.25, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_grade_name",
      res = "UI/alpha/1080P/cuparena/cuparena_rank_medal_1_name.png",
      name = "img_my_grade_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84, 23.75)
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
      name = "label_task",
      z = 0,
      parent = "btn_task",
      text = T("\228\187\187\229\138\161"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.75, 9)
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
      name = "label_total_medal",
      z = 0,
      parent = "ImageView_11142_Copy2",
      text = T("\230\128\187\229\139\139\231\171\160\239\188\154123456"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(28.75, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 14.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_task",
      res = "UI/alpha/1080P/cuparena/cuparena_reward_redpoint.png",
      name = "img_task_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.25, 39)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 253, 242),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_my_total_rank",
      z = 0,
      parent = "bg_my_total_rank",
      text = T("\230\128\187\230\142\146\229\144\141\239\188\1541"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(52.25, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_challenge_dark",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_tab_icon_1.png",
      name = "ImageView_11171_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 36)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 255, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_challenge_down_dark",
      z = 0,
      parent = "btn_challenge_dark",
      text = T("\230\140\145\230\136\152"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91, 35)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 255, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_challenge_up_dark",
      z = 0,
      parent = "btn_challenge_dark",
      text = T("\230\140\145\230\136\152"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91, 35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_camp_dark",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_tab_icon.png",
      name = "ImageView_11171_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 36)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 255, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_camp_down_dark",
      z = 0,
      parent = "btn_camp_dark",
      text = T("\233\152\181\232\144\165"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91, 35)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 255, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_camp_up_dark",
      z = 0,
      parent = "btn_camp_dark",
      text = T("\233\152\181\232\144\165"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91, 35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.17, x = 1.17},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.965, h = 16.965},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_challenge_dark",
      res = "UI/alpha/1080P/cuparena/cuparena_reward_redpoint.png",
      name = "img_challenge_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134.5, 56)
    }
  }
}

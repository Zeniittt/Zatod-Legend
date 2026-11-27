ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloMainPanel = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
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
      fix_wh = {w = 731, h = 123.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/bottom_1.png",
      name = "bg_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(484, 61)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.5, h = 53.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/chesscard/treasure_1.png",
      name = "treasure1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(218.5, 49.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(103, 77, 57),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tip_treasure1",
      z = 0,
      parent = "treasure1",
      text = "1",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.75, 34.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.4000001, x = 1.4000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.6000019, h = 26.6000019},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "treasure1",
      res = "UI/alpha/1080P/chesscard/power_num_bg.png",
      name = "redpoint_treasure1",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.75, 46.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.5, h = 53.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/chesscard/treasure_1.png",
      name = "treasure2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(280.5, 49.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(103, 77, 57),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tip_treasure11",
      z = 0,
      parent = "treasure1",
      text = T("\229\155\158\229\144\136"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.75, 16.75)
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
      name = "label_use_treasure1",
      z = 0,
      parent = "redpoint_treasure1",
      text = "1",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.5, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63.5, h = 63.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "treasure1",
      res = "UI/alpha/1080P/chesscard/power_selected.png",
      name = "power_selected1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.75, 26.75)
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
      parent = "bg",
      name = "bg_player_panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(78, 156)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.5, h = 53.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/chesscard/treasure_1.png",
      name = "treasure3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(343, 49.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(103, 77, 57),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tip_treasure2",
      z = 0,
      parent = "treasure2",
      text = "5",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.75, 34.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.4000001, x = 1.4000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.6000019, h = 26.6000019},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "treasure2",
      res = "UI/alpha/1080P/chesscard/power_num_bg.png",
      name = "redpoint_treasure2",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.75, 46.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(260, 99.5)
    },
    t = "Layer",
    base = {
      parent = "bg_bottom",
      name = "layer_faction",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(425.5, 0.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(103, 77, 57),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tip_treasure12",
      z = 0,
      parent = "treasure2",
      text = T("\229\155\158\229\144\136"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.75, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63.5, h = 63.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "treasure2",
      res = "UI/alpha/1080P/chesscard/power_selected.png",
      name = "power_selected2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.75, 26.75)
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
      parent = "bg",
      name = "bg_oppo_panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(823.5, 156)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_heroname",
      z = 0,
      parent = "bg_bottom",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.5, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.5, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_player_panel",
      res = "UI/alpha/1080P/chesscard/lv.png",
      name = "bg_player_lv",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(7, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(103, 77, 57),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tip_treasure3",
      z = 0,
      parent = "treasure3",
      text = "10",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.75, 34.25)
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
      name = "label_use_treasure2",
      z = 0,
      parent = "redpoint_treasure2",
      text = "1",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.5, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.4000001, x = 1.4000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.6000019, h = 26.6000019},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "treasure3",
      res = "UI/alpha/1080P/chesscard/power_num_bg.png",
      name = "redpoint_treasure3",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.75, 46.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.5, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/chesscard/skill_1.png",
      name = "bg_skill1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 73.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 163.5, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_player_panel",
      res = "UI/alpha/1080P/chesscard/green_1.png",
      name = "bg_player_hp_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84, 51)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(103, 77, 57),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tip_treasure13",
      z = 0,
      parent = "treasure3",
      text = T("\229\155\158\229\144\136"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.75, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63.5, h = 63.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "treasure3",
      res = "UI/alpha/1080P/chesscard/power_selected.png",
      name = "power_selected3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.75, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.5, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/chesscard/skill_1.png",
      name = "bg_skill2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150, h = 11.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_player_panel",
      res = "UI/alpha/1080P/chesscard/blue_1.png",
      name = "bg_player_mp_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 34.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(213, 212, 212),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_player_level",
      z = 0,
      parent = "bg_player_lv",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.25, 19.25)
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
      name = "Label_001",
      z = 0,
      parent = "bg_bottom",
      text = T("\229\174\157\231\137\169"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(284, 106.75)
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
      name = "label_name_player",
      z = 0,
      parent = "bg_player_panel",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80, 74)
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
      name = "label_use_treasure3",
      z = 0,
      parent = "redpoint_treasure3",
      text = "1",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.5, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 493.5, h = 66.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/player_fream.png",
      name = "bg_top",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(483.5, 507)
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
      name = "Label_002",
      z = 0,
      parent = "bg_bottom",
      text = T("\230\181\129\230\180\190"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(560.5, 106.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 120)
    },
    t = "Layer",
    base = {
      parent = "bg_player_panel",
      name = "Panel_9728",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(29, 85)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 163.5, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppo_panel",
      res = "UI/alpha/1080P/chesscard/green_1.png",
      name = "bg_oppo_hp_bar",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-84, 51)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 163.5, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_player_hp_bar",
      res = "UI/alpha/1080P/chesscard/green_2.png",
      name = "player_hp_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.75, 12.5)
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
      name = "label_player_hp",
      z = 3,
      parent = "bg_player_hp_bar",
      text = "362/582",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.75, 12.5)
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
      name = "Label_003",
      z = 0,
      parent = "bg_bottom",
      text = T("\230\138\128\232\131\189"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 107.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204, h = 26},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_player_panel",
      res = "UI/alpha/1080P/chesscard/topbar_4.png",
      name = "bg_player_oattr",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105, -11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.5, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppo_panel",
      res = "UI/alpha/1080P/chesscard/lv.png",
      name = "bg_oppo_lv",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-7, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_player_panel",
      res = "UI/alpha/1080P/chesscard/3.png",
      name = "icon_player_attr5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16.5, -2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150, h = 11.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppo_panel",
      res = "UI/alpha/1080P/chesscard/blue_1.png",
      name = "bg_oppo_mp_bar",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-90, 34.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150, h = 11.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_player_mp_bar",
      res = "UI/alpha/1080P/chesscard/blue_2.png",
      name = "player_mp_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75, 5.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_player_panel",
      res = "UI/alpha/1080P/chesscard/4.png",
      name = "icon_player_attr6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, -2)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_oppo",
      z = 0,
      parent = "bg_oppo_panel",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-80, 74)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_player_panel",
      res = "UI/alpha/1080P/chesscard/9.png",
      name = "icon_player_attr7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115.5, -2)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 120)
    },
    t = "Layer",
    base = {
      parent = "bg_oppo_panel",
      name = "Panel_9729",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-127, 86)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 163.5, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppo_hp_bar",
      res = "UI/alpha/1080P/chesscard/green_2.png",
      name = "oppo_hp_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.75, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 209, 191),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_oppo_hp",
      z = 3,
      parent = "bg_oppo_hp_bar",
      text = "362/582",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.75, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(164.5, 75.5)
    },
    t = "Layer",
    base = {
      parent = "bg_player_panel",
      name = "Panel_905",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-12, -13.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21, h = 27},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_oppo_panel",
      res = "UI/alpha/1080P/chesscard/victory.png",
      name = "icon_oppo_victroy",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-43, 74)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 82.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/skill/button.png",
      name = "btn_log",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 80.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 171, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_top",
      res = "UI/alpha/1080P/chesscard/win_gold_bg.png",
      name = "bg_gold",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(626.25, 40.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 149, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_player_panel",
      res = "UI/alpha/1080P/chesscard/buff_bg.png",
      name = "ImageView_1870",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86.5, 17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppo_panel",
      res = "UI/alpha/1080P/chesscard/3.png",
      name = "icon_oppo_attr5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-147, -2)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(213, 212, 212),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_oppo_lv",
      z = 0,
      parent = "bg_oppo_lv",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.25, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppo_panel",
      res = "UI/alpha/1080P/chesscard/4.png",
      name = "icon_oppo_attr6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-92, -2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 82.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/skill/button.png",
      name = "btn_all_info",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.5, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppo_panel",
      res = "UI/alpha/1080P/chesscard/9.png",
      name = "icon_oppo_attr7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-39, -3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 65, h = 77},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_top",
      res = "UI/alpha/1080P/chesscard/topbar_5.png",
      name = "bg_watch1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(162.75, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150, h = 11.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppo_mp_bar",
      res = "UI/alpha/1080P/chesscard/blue_2.png",
      name = "oppo_mp_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75, 5.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(165.5, 75.5)
    },
    t = "Layer",
    base = {
      parent = "bg_oppo_panel",
      name = "Panel_906",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-152.5, -14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 132, h = 78.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_top",
      res = "UI/alpha/1080P/chesscard/topbar_6.png",
      name = "bg_watch2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(191.25, 27.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 149, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppo_panel",
      res = "UI/alpha/1080P/chesscard/buff_bg.png",
      name = "ImageView_1869",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-86, 18)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_player_attr5",
      z = 0,
      parent = "icon_player_attr5",
      text = "18",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(19, 8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      fix_wh = {w = 43.2, h = 44},
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
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_quit",
      z = 0,
      parent = "bg_top",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-203.75, 37.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_gold",
      res = "UI/alpha/1080P/chesscard/skill/gold.png",
      name = "icon_gold",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92.5, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_player_attr6",
      z = 0,
      parent = "icon_player_attr6",
      text = "18",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(19, 8)
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
      name = "label_gold",
      z = 0,
      parent = "bg_gold",
      text = "9999",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131.5, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_gold",
      res = "UI/alpha/1080P/chesscard/victory.png",
      name = "ImageView_312",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16.5, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_player_attr7",
      z = 0,
      parent = "icon_player_attr7",
      text = "18",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(19, 8)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 236, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_oppo_victory",
      z = 0,
      parent = "icon_oppo_victroy",
      text = "3",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18, 6.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 225, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_313",
      z = 0,
      parent = "bg_gold",
      text = T("\232\191\158\232\131\156"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_oppo_attr5",
      z = 0,
      parent = "icon_oppo_attr5",
      text = "18",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(19, 8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.0999957, h = 20.2999971},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_watch1",
      res = "UI/alpha/1080P/chesscard/eyes.png",
      name = "ImageView_7583",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 64.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_1870",
      res = "UI/alpha/1080P/chesscard/1.png",
      name = "icon_player_attr1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(5, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_oppo_attr6",
      z = 0,
      parent = "icon_oppo_attr6",
      text = "18",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(19, 8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.0999957, h = 20.2999971},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_watch2",
      res = "UI/alpha/1080P/chesscard/eyes.png",
      name = "ImageView_7583_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66, 65.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_1870",
      res = "UI/alpha/1080P/chesscard/5.png",
      name = "icon_player_attr2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_1870",
      res = "UI/alpha/1080P/chesscard/2.png",
      name = "icon_player_attr3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.5, 11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_1870",
      res = "UI/alpha/1080P/chesscard/6.png",
      name = "icon_player_attr4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122.5, 11)
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
      name = "Label_12498",
      z = 0,
      parent = "btn_log",
      text = T("\230\151\165\229\191\151"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.25, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_oppo_attr7",
      z = 0,
      parent = "icon_oppo_attr7",
      text = "18",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(19, 8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_log",
      res = "UI/alpha/1080P/chesscard/log.png",
      name = "btn_log_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.75, 21)
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
      name = "Label_12498_Copy0",
      z = 0,
      parent = "btn_all_info",
      text = T("\231\142\169\229\174\182"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.25, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_quit",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "ImageView_3150",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_1869",
      res = "UI/alpha/1080P/chesscard/1.png",
      name = "icon_oppo_attr1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(4, 11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_1869",
      res = "UI/alpha/1080P/chesscard/5.png",
      name = "icon_oppo_attr2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_all_info",
      res = "UI/alpha/1080P/chesscard/playerdetails.png",
      name = "btn_all_info_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.75, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_1869",
      res = "UI/alpha/1080P/chesscard/2.png",
      name = "icon_oppo_attr3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.5, 11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_1869",
      res = "UI/alpha/1080P/chesscard/6.png",
      name = "icon_oppo_attr4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(127, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 195, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_player_attr1",
      z = 0,
      parent = "icon_player_attr1",
      text = "18",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.5, 8)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 195, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_player_attr2",
      z = 0,
      parent = "icon_player_attr2",
      text = "18",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.5, 8)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 195, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_player_attr3",
      z = 0,
      parent = "icon_player_attr3",
      text = "18",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.5, 8)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 195, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_player_attr4",
      z = 0,
      parent = "icon_player_attr4",
      text = "18",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.5, 8)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 195, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_oppo_attr1",
      z = 0,
      parent = "icon_oppo_attr1",
      text = "18",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.5, 8)
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
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(753.5, 514)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 195, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_oppo_attr2",
      z = 0,
      parent = "icon_oppo_attr2",
      text = "18",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.5, 8)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 195, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_oppo_attr3",
      z = 0,
      parent = "icon_oppo_attr3",
      text = "18",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.5, 8)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 195, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_oppo_attr4",
      z = 0,
      parent = "icon_oppo_attr4",
      text = "18",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.5, 8)
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
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeDungeonLevelScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/level/level_bg.jpg",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
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
      parent = "bg",
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(289.5, 592)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 431.5, h = 118},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/level/level_track_2.png",
      name = "cur_level_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292, 162)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 424.5, h = 424.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/level/level_gear_3.png",
      name = "image_bg_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(263.5, 367)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 663.5, h = 526.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/level/level_info_bg_1.png",
      name = "image_detail_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(779, 357)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 0,
      fix_wh = {w = 206.5, h = 206},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/level/level_gear_4.png",
      name = "image_bg_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(549.5, 454)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 508.5, h = 173},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/level/level_deco_1.png",
      name = "image_bg_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(362.5, 165.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 146, h = 33.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "cur_level_bg",
      res = "UI/alpha/1080P/dungeon/level/level_track_1.png",
      name = "level_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210.75, 77.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 78.5, h = 78.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "cur_level_bg",
      res = "UI/alpha/1080P/dungeon/level/level_gear_5.png",
      name = "image_gear_left",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.25, 42)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 78.5, h = 78.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "cur_level_bg",
      res = "UI/alpha/1080P/dungeon/level/level_gear_5.png",
      name = "image_gear_right",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(389.75, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 299.5, h = 65.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "cur_level_bg",
      res = "UI/alpha/1080P/dungeon/level/level_track_loading_2.png",
      name = "image_exp_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(215.75, 43)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 650, h = 157},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/dungeon/level/level_info_bg_2.png",
      name = "level_info_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(337.75, 447.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(437, 170.5)
    },
    t = "Layer",
    base = {
      parent = "image_detail_bg",
      name = "panel_level_attr",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(117.25, 203.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 663.5, h = 249.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_detail_bg",
      res = "UI/alpha/1080P/dungeon/level/level_button_light_1.png",
      name = "reward_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(331.75, 124.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 227),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cur_level",
      z = 0,
      parent = "level_bg",
      text = T("\231\173\137\231\186\16722"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.5, h = 94.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "level_info_bg",
      res = "UI/alpha/1080P/dungeon/level/level_gear_8.png",
      name = "ImageView_292",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 76.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.5, h = 94.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "level_info_bg",
      res = "UI/alpha/1080P/dungeon/level/level_gear_7.png",
      name = "ImageView_293",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(626, 76.5)
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
      name = "label_exp",
      z = 1,
      parent = "image_exp_bg",
      text = "12345/50000",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151.75, 31.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(626, 123)
    },
    t = "Layer",
    base = {
      parent = "level_info_bg",
      name = "panel_level_item_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(14, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 366, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "reward_bg",
      res = "UI/alpha/1080P/dungeon/level/level_info_line.png",
      name = "image_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(332.75, 199.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 75)
    },
    t = "Layer",
    base = {
      parent = "reward_bg",
      name = "reward_item_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(135.75, 106.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 274.5, h = 81.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "reward_bg",
      res = "UI/alpha/1080P/dungeon/level/level_button_1.png",
      name = "btn_get_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(333.25, 58.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 274.5, h = 81.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "reward_bg",
      res = "UI/alpha/1080P/dungeon/level/level_button_2.png",
      name = "btn_achieve",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(333.25, 58.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(299.5, 65.5)
    },
    t = "Layer",
    base = {
      parent = "image_exp_bg",
      name = "panel_exp_clip",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.75, 0.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(206, 115, 90),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_level_not_enough",
      z = 0,
      parent = "reward_bg",
      text = T("\231\173\137\231\186\167\228\184\141\232\182\179"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(332.25, 66.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 300)
    },
    t = "Layer",
    base = {
      parent = "cur_level_bg",
      name = "panel_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(66.75, 96.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 299.5, h = 65.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_exp_clip",
      res = "UI/alpha/1080P/dungeon/level/level_track_loading_1.png",
      name = "image_level",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149, 33)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_292",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "left_red_dot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 87.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_293",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "right_red_dot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.25, 87.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 182),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_get_reward",
      z = 0,
      parent = "btn_get_reward",
      text = T("\229\143\175\233\162\134\229\143\150"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.25, 49.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 163, 119),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_achieve",
      z = 0,
      parent = "btn_achieve",
      text = T("\229\183\178\233\162\134\229\143\150"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.25, 49.25)
    }
  }
}

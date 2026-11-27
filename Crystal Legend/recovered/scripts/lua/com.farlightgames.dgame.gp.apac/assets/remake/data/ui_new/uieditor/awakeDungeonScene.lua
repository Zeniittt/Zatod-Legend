ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeDungeonScene = {
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
      res = "UI/alpha/1080P/dungeon/chapter/bg_min.jpg",
      name = "map",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 269.5)
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
      parent = "map",
      name = "panel_light",
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
      fix_wh = {w = 332.5, h = 303},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "map",
      res = "UI/alpha/1080P/dungeon/chapter/line1.png",
      name = "img_line_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(268, 569)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 383.5, h = 230.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "map",
      res = "UI/alpha/1080P/dungeon/chapter/line2.png",
      name = "img_line_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(978, 482.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 332.5, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "map",
      res = "UI/alpha/1080P/dungeon/chapter/line3.png",
      name = "img_line_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(163.5, 294.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 406.5, h = 201.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "map",
      res = "UI/alpha/1080P/dungeon/chapter/line4.png",
      name = "img_line_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(963.5, 124.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 325, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "map",
      res = "UI/alpha/1080P/dungeon/chapter/line5.png",
      name = "img_line_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(289, 120.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 275.5, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/chapter/chapter_title.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.5, 502.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 235.5, h = 110.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/dungeon_level_frame.png",
      name = "image_level_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.5, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 337, h = 273.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/dungeon_levelup_bg.png",
      name = "exp_change_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(470.5, 450.5)
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
      parent = "title_bg",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232.25, 30)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(259, 59.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(150, 25, 0.5, 0.5),
      res = "UI/alpha/1080P/dungeon/dungeon_endtime_bg.png",
      name = "image_left_time_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477, 509.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 175)
    },
    t = "Layer",
    base = {
      name = "panel_sweep",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(919.5, 160)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 300.5, h = 238},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "map",
      res = "UI/alpha/1080P/dungeon/chapter/chapter1.png",
      name = "img_chapter_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(473, 497)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 269, h = 209},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "map",
      res = "UI/alpha/1080P/dungeon/chapter/chapter2.png",
      name = "img_chapter_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(697.5, 477)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 275, h = 198},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "map",
      res = "UI/alpha/1080P/dungeon/chapter/chapter3.png",
      name = "img_chapter_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(383.5, 349)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 343, h = 179.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "map",
      res = "UI/alpha/1080P/dungeon/chapter/chapter4.png",
      name = "img_chapter_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(708.5, 260.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 261, h = 247.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "map",
      res = "UI/alpha/1080P/dungeon/chapter/chapter5.png",
      name = "img_chapter_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(507, 238)
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
      name = "label_level",
      z = 0,
      parent = "image_level_bg",
      text = T("124\231\186\167"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56.25, 60.75)
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
      name = "ImageView_116",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 215, 112),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_exp_percent",
      z = 0,
      parent = "image_level_bg",
      text = "100%",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200.75, 57.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(77, 32.5)
    },
    t = "Layer",
    base = {
      parent = "image_level_bg",
      name = "panel_clip",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(105.25, 41.25)
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
      parent = "image_level_bg",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "reward_entry_reddot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.25, 91.75)
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
      parent = "image_left_time_bg",
      res = "UI/alpha/1080P/dungeon/dungeon_countdown.png",
      name = "image_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 28.25)
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
      name = "label_change_level",
      z = 0,
      parent = "exp_change_bg",
      text = "123",
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(170, 146.75)
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
      name = "label_left_time",
      z = 0,
      parent = "image_left_time_bg",
      text = T("\229\137\169\228\189\153 12\229\164\1696\230\151\182 \230\180\187\229\138\168\231\187\147\230\157\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(51, 28.75)
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
      z = 0,
      parent = "exp_change_bg",
      text = "123/123",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168.5, 100.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 217, 67),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_get_exp",
      z = 0,
      parent = "exp_change_bg",
      text = T("\232\142\183\229\190\151\231\187\143\233\170\140"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168.5, 79.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 62, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "exp_change_bg",
      res = "UI/alpha/1080P/dungeon/dungeon_levelup_progress.png",
      name = "image_circle_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(171, 145.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 206, 143),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_exp_change_title",
      z = 0,
      parent = "exp_change_bg",
      text = T("\231\167\145\230\138\128\231\173\137\231\186\167"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(170.5, 189.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 32.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_clip",
      res = "UI/alpha/1080P/dungeon/dungeon_level_progress_bg.png",
      name = "image_progress_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 121, h = 71},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_sweep",
      res = "UI/alpha/1080P/dungeon/chapter/sweep_botton_close.png",
      name = "img_sweep_closed",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(100, 146.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 236, h = 183},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_sweep",
      res = "UI/alpha/1080P/dungeon/chapter/sweep_open_bg.png",
      name = "img_sweep_opened",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(3, 89)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175.5, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_chapter_1",
      res = "UI/alpha/1080P/dungeon/chapter/chapter_title_finished.png",
      name = "bg_chapter_info_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(158.25, 63)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175.5, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_chapter_2",
      res = "UI/alpha/1080P/dungeon/chapter/chapter_title_finished.png",
      name = "bg_chapter_info_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(167, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175.5, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_chapter_3",
      res = "UI/alpha/1080P/dungeon/chapter/chapter_title_finished.png",
      name = "bg_chapter_info_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175.5, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_chapter_4",
      res = "UI/alpha/1080P/dungeon/chapter/chapter_title_finished.png",
      name = "bg_chapter_info_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153, 41.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175.5, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_chapter_5",
      res = "UI/alpha/1080P/dungeon/chapter/chapter_title_finished.png",
      name = "bg_chapter_info_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.5, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 150)
    },
    t = "Layer",
    base = {
      parent = "img_chapter_1",
      name = "btn_chapter_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(95.25, 44)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 150)
    },
    t = "Layer",
    base = {
      parent = "img_chapter_2",
      name = "btn_chapter_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(92, -5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 150)
    },
    t = "Layer",
    base = {
      parent = "img_chapter_3",
      name = "btn_chapter_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(57, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 150)
    },
    t = "Layer",
    base = {
      parent = "img_chapter_4",
      name = "btn_chapter_4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(88.5, 24.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 131)
    },
    t = "Layer",
    base = {
      parent = "img_chapter_5",
      name = "btn_chapter_5",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(52, 13.75)
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
      name = "label_sweep_closed",
      z = 0,
      parent = "img_sweep_closed",
      text = T("\230\137\171\232\141\161"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(105, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 212.5, h = 59.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_sweep_opened",
      res = "UI/alpha/1080P/dungeon/chapter/sweep_botton_open.png",
      name = "img_sweep_opened_title",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(212, 151)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 182, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_sweep_rewrad_des",
      z = 0,
      parent = "img_sweep_opened",
      text = T("\230\137\171\232\141\161\232\142\183\229\190\151"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(24.5, 121)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 11.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_sweep_opened",
      res = "UI/alpha/1080P/icon/dungeon_energy.png",
      name = "img_sweep_cost_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 67)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 248),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_sweep_cost_1",
      z = 0,
      parent = "img_sweep_opened",
      text = "1",
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(65, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 248),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_sweep_cost_2",
      z = 0,
      parent = "img_sweep_opened",
      text = "10",
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(164, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 11.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_sweep_opened",
      res = "UI/alpha/1080P/icon/dungeon_energy.png",
      name = "img_sweep_cost_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(159, 66.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 86.275, h = 35.7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_sweep_opened",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_sweep_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 86.275, h = 35.7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_sweep_opened",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_sweep_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_chapter_info_1",
      res = "UI/alpha/1080P/dungeon/chapter/wheel_moving.png",
      name = "bg_progress_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.75, 32)
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
      name = "label_chapter_name_1",
      z = 0,
      parent = "bg_chapter_info_1",
      text = T("\231\172\172\228\184\128\231\171\160 \229\164\150\229\159\159\228\188\160\233\151\187"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.25, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 234, 101),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_progress_1",
      z = 0,
      parent = "bg_chapter_info_1",
      text = "100%",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.25, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 30)
    },
    t = "Layer",
    base = {
      parent = "img_sweep_closed",
      name = "btn_sweep_closed",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(34, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_chapter_info_2",
      res = "UI/alpha/1080P/dungeon/chapter/wheel_moving.png",
      name = "bg_progress_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.75, 32)
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
      name = "label_chapter_name_2",
      z = 0,
      parent = "bg_chapter_info_2",
      text = T("\231\172\172\228\184\128\231\171\160 \229\164\150\229\159\159\228\188\160\233\151\187"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.25, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 234, 101),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_progress_2",
      z = 0,
      parent = "bg_chapter_info_2",
      text = "100%",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.25, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_chapter_info_3",
      res = "UI/alpha/1080P/dungeon/chapter/wheel_moving.png",
      name = "bg_progress_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.75, 32)
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
      name = "label_chapter_name_3",
      z = 0,
      parent = "bg_chapter_info_3",
      text = T("\231\172\172\228\184\128\231\171\160 \229\164\150\229\159\159\228\188\160\233\151\187"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.25, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 234, 101),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_progress_3",
      z = 0,
      parent = "bg_chapter_info_3",
      text = "100%",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.25, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_chapter_info_4",
      res = "UI/alpha/1080P/dungeon/chapter/wheel_moving.png",
      name = "bg_progress_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.75, 32)
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
      name = "label_chapter_name_4",
      z = 0,
      parent = "bg_chapter_info_4",
      text = T("\231\172\172\228\184\128\231\171\160 \229\164\150\229\159\159\228\188\160\233\151\187"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.25, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 234, 101),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_progress_4",
      z = 0,
      parent = "bg_chapter_info_4",
      text = "100%",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.25, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_chapter_info_5",
      res = "UI/alpha/1080P/dungeon/chapter/wheel_moving.png",
      name = "bg_progress_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.75, 32)
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
      name = "label_chapter_name_5",
      z = 0,
      parent = "bg_chapter_info_5",
      text = T("\231\172\172\228\184\128\231\171\160 \229\164\150\229\159\159\228\188\160\233\151\187"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.25, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 234, 101),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_progress_5",
      z = 0,
      parent = "bg_chapter_info_5",
      text = "100%",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.25, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_chapter_info_1",
      res = "UI/alpha/1080P/dungeon/chapter/lock.png",
      name = "img_chapter_lock_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.75, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_chapter_info_2",
      res = "UI/alpha/1080P/dungeon/chapter/lock.png",
      name = "img_chapter_lock_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.75, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_chapter_info_3",
      res = "UI/alpha/1080P/dungeon/chapter/lock.png",
      name = "img_chapter_lock_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.75, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_chapter_info_4",
      res = "UI/alpha/1080P/dungeon/chapter/lock.png",
      name = "img_chapter_lock_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.75, 31.5)
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
      parent = "bg_chapter_info_1",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "img_red_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184.75, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_chapter_info_5",
      res = "UI/alpha/1080P/dungeon/chapter/lock.png",
      name = "img_chapter_lock_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.75, 31.5)
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
      parent = "bg_chapter_info_2",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "img_red_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184.75, 14)
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
      parent = "bg_chapter_info_3",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "img_red_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184.75, 14)
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
      parent = "bg_chapter_info_4",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "img_red_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184.75, 14)
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
      parent = "bg_chapter_info_5",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "img_red_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184.75, 14)
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
      name = "label_sweep_opened",
      z = 0,
      parent = "img_sweep_opened_title",
      text = T("\230\137\171\232\141\161"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(199, 29.75)
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
      name = "label_sweep_1",
      z = 0,
      parent = "btn_sweep_1",
      text = T("\230\137\171\232\141\1611\230\172\161"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.75, 22.5)
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
      name = "label_sweep_2",
      z = 0,
      parent = "btn_sweep_2",
      text = T("\230\137\171\232\141\16110\230\172\161"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.75, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 30)
    },
    t = "Layer",
    base = {
      parent = "img_sweep_opened_title",
      name = "btn_sweep_opened",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(20.5, 15.75)
    }
  }
}

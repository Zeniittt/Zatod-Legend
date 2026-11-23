ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeDungeonGridMapScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79.5, h = 96},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/stage/up_arrow.png",
      name = "img_end_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(575.5, 592.5)
    }
  },
  {
    config = {
      rotation = 180,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79.5, h = 96},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/stage/up_arrow.png",
      name = "img_player_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400.5, 585)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 273, h = 48.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/stage/chapter_title_bg.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.5, 502)
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
      position = ccp(495, 53.5)
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
      position = ccp(65.5, 49.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 155.5, h = 47.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/dungeon_buff_main.png",
      name = "image_buff_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.5, 502)
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
      position = ccp(908, 303)
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(164, 164, 164),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_432",
      z = 0,
      parent = "title_bg",
      text = T("\230\142\162\231\180\162\229\186\166"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(231.5, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 177, 26),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_chapter_progress",
      z = 0,
      parent = "title_bg",
      text = "80%",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(234, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 191, 18),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buff",
      z = 0,
      parent = "image_buff_bg",
      text = T("200%\229\188\186\229\140\150"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(53.75, 33.75)
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
      name = "label_buff_time",
      z = 0,
      parent = "image_buff_bg",
      text = T("\230\140\129\231\187\17329\229\164\16923\229\176\143\230\151\182"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(53.75, 19.25)
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
      rotation = -40,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60.5, h = 65.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_player_arrow",
      res = "UI/alpha/1080P/dungeon/stage/player_arrow.png",
      name = "icon_player",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.75, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60.5, h = 65.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_end_arrow",
      res = "UI/alpha/1080P/dungeon/stage/down_arrow.png",
      name = "icon_end",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.75, 39.5)
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
      fix_wh = {w = 81, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/stage/switch_close_bg.png",
      name = "image_switch_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(472, 503.5)
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(189, 189, 189),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_switch_closed",
      z = 0,
      parent = "image_switch_bg",
      text = T("\229\133\179\233\151\173\233\166\150\233\128\154"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(54, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_switch_bg",
      res = "UI/alpha/1080P/dungeon/stage/switch_icon.png",
      name = "image_switch_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15, 15)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 244, 199),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_switch_opened",
      z = 0,
      parent = "image_switch_bg",
      text = T("\230\152\190\231\164\186\233\166\150\233\128\154"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.5, 15)
    }
  }
}

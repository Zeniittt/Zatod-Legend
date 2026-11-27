ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeDungeonChapterInfo = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(643, 400)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 10, 10),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(490.5, 275.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 644, h = 203},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/chapterinfo/chapter1_bg.png",
      name = "image_chapter_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(323.5, 296.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 126, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/chapterinfo/title_left.png",
      name = "image_left_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(195.5, 375)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/chapterinfo/title_right.png",
      name = "image_right_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(425.5, 378.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 207),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "chapter_name",
      z = 0,
      parent = "image_bg",
      text = T("\232\190\137\231\131\172\229\186\173\233\153\162"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(310.5, 377.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(595, 85)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_des",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(23.5, 268.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(155, 46.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_enter",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(20, 10, 20, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(511, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.2, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(630.5, 388)
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
      name = "label_enter",
      z = 0,
      parent = "btn_enter",
      text = T("\232\191\155\229\133\165\231\171\160\232\138\130"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.5, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 640, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/chapterinfo/process_bg.png",
      name = "image_progress_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(322, 227.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 656.5, h = 120.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/chapterinfo/record_shade.png",
      name = "image_record_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(314, 136.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(155, 46.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_disable",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_mini_grey.png",
      capInsets = CCRectMake(20, 10, 20, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(511, 37.5)
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
      name = "search_title",
      z = 0,
      parent = "image_progress_bg",
      text = T("\230\142\162\231\180\162\232\191\155\229\186\166\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(447.5, 58.75)
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
      name = "collect_title",
      z = 0,
      parent = "image_progress_bg",
      text = T("\230\148\182\233\155\134\232\191\155\229\186\166\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(97.5, 59.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_2861",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.5, 27.5)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "label_first_des",
      z = 0,
      parent = "image_record_bg",
      text = T("\233\166\150\233\128\154\232\128\133\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(37.75, 101.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(40, 40)
    },
    t = "Layer",
    base = {
      parent = "image_record_bg",
      name = "panel_first_head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(67.75, 29.25)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "label_first_guild",
      z = 0,
      parent = "image_record_bg",
      text = T("\229\133\172\228\188\154\229\144\141\229\133\173\228\184\170\229\173\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(138.75, 36.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(125, 22)
    },
    t = "Layer",
    base = {
      parent = "image_record_bg",
      name = "panel_first_name",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(136.25, 47.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79.5, h = 13.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_progress_bg",
      res = "UI/alpha/1080P/dungeon/chapterinfo/process_bar_bg.png",
      name = "image_special_box_progress_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(215, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(79.5, 13.5)
    },
    t = "Layer",
    base = {
      parent = "image_special_box_progress_bg",
      name = "panel_special_box_progress_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-0.25, 0.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79.5, h = 13.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_progress_bg",
      res = "UI/alpha/1080P/dungeon/chapterinfo/process_bar_bg.png",
      name = "image_normal_box_progress_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.5, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(79.5, 13.5)
    },
    t = "Layer",
    base = {
      parent = "image_normal_box_progress_bg",
      name = "panel_normal_box_progress_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-0.25, 0.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(120, 105, 98),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "none_first_record",
      z = 0,
      parent = "image_record_bg",
      text = T("\230\154\130\230\151\160\233\166\150\233\128\154\232\174\176\229\189\149"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(328.25, 60.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41, h = 39.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_progress_bg",
      res = "UI/alpha/1080P/dungeon/stage/tilemap/treasure_big.png",
      name = "image_special_box",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(177, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.25, h = 36.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_progress_bg",
      res = "UI/alpha/1080P/dungeon/stage/tilemap/treasure_normal.png",
      name = "image_normal_box",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 436, h = 34},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_record_bg",
      res = "UI/alpha/1080P/dungeon/chapterinfo/record_bg.png",
      name = "image_first_time_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478.25, 50.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(178, 13.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_search_progress_bg",
      z = 0,
      parent = "image_progress_bg",
      res = "UI/alpha/1080P/dungeon/chapterinfo/process_bar_bg.png",
      capInsets = CCRectMake(10, 0, 55, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(462.5, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(178, 13.5)
    },
    t = "Layer",
    base = {
      parent = "image_search_progress_bg",
      name = "panel_search_progress_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 70.5, h = 71.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_progress_bg",
      res = "UI/alpha/1080P/dungeon/chapterinfo/reward_base.png",
      name = "image_chapter_reward_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(583, 39.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(217, 217, 217),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_disable",
      z = 0,
      parent = "btn_disable",
      text = T("\232\191\155\229\133\165\231\171\160\232\138\130"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.5, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 183, 51),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_special_box_current",
      z = 0,
      parent = "image_special_box_progress_bg",
      text = "1",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.75, 7.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 249, 241),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_special_box_target",
      z = 0,
      parent = "image_special_box_progress_bg",
      text = "/3",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.25, 7.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75.5, h = 10.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_special_box_progress_bar",
      res = "UI/alpha/1080P/dungeon/chapterinfo/process_bar.png",
      name = "ImageView_2883",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(2.5, 6.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 183, 51),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_normal_box_current",
      z = 0,
      parent = "image_normal_box_progress_bg",
      text = "1",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.75, 7.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 249, 241),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_normal_box_target",
      z = 0,
      parent = "image_normal_box_progress_bg",
      text = "/3",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.25, 7.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75.5, h = 10.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_normal_box_progress_bar",
      res = "UI/alpha/1080P/dungeon/chapterinfo/process_bar.png",
      name = "ImageView_2883",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(2.5, 6.5)
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
      name = "label_first_time_des",
      z = 0,
      parent = "image_first_time_bg",
      text = T("\233\128\154\229\133\179\230\151\182\233\151\180\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(204, 16.5)
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
      name = "label_first_time_val",
      z = 0,
      parent = "image_first_time_bg",
      text = "2025-4-20",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(207, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 249, 241),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_search_progress_target",
      z = 0,
      parent = "image_search_progress_bg",
      text = "100%",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 7.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(174, 10.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_2883",
      z = 0,
      parent = "panel_search_progress_bar",
      res = "UI/alpha/1080P/dungeon/chapterinfo/process_bar.png",
      capInsets = CCRectMake(10, 0, 55.5, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(2, 6.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_chapter_reward_bg",
      res = "UI/alpha/1080P/dungeon/chapterinfo/reward_doing.png",
      name = "image_chapter_reward_box",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 34.75)
    }
  }
}

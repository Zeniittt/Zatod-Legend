ed.uieditor = ed.uieditor or {}
ed.uieditor.task_playerAward = {
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
      name = "layer_container",
      z = 9
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
      fix_wh = {w = 762, h = 96},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_container",
      res = "UI/alpha/1080P/task/daily_task_title_bj.png",
      name = "title_bj",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(437.5, 468)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_container",
      res = "UI/alpha/1080P/task/player_award_list_left_hero.png",
      name = "ImageView_166",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(785.5, 461)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(625, 390)
    },
    t = "Layer",
    base = {
      parent = "layer_container",
      name = "task_playerAward_list_box",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(252.5, 55.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 250, h = 457.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_container",
      res = "UI/alpha/1080P/task/player_award_left_hero_bj.png",
      name = "left_hero_bj",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(162.5, 268.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 45)
    },
    t = "Layer",
    base = {
      parent = "layer_container",
      name = "Panel_203",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(608, 34)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 39, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_bj",
      res = "UI/alpha/1080P/task/daily_task_fa.png",
      name = "ImageView_155",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148, 86.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_bj",
      res = "UI/alpha/1080P/task/daily_task_fa.png",
      name = "ImageView_155_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(612.5, 86.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 206, h = 54.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_bj",
      res = "UI/alpha/1080P/task/daily_task_title_img.png",
      name = "img_playerAward_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(402.5, 69.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_bj",
      res = "UI/alpha/1080P/task/daily_task_title_lv_bj.png",
      name = "ImageView_158",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207, 64)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(330, 10)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_progress_bj",
      z = 0,
      parent = "title_bj",
      res = "UI/alpha/1080P/task/task_title_progress_bj.png",
      capInsets = CCRectMake(10, 0, 10, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(410, 42.5)
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
      name = "txt_award_progress",
      z = 5,
      parent = "title_bj",
      text = "",
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(410.5, 43.5)
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
      parent = "title_bj",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_award_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(638, 62)
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
      name = "task_playerAward_time",
      z = 0,
      parent = "ImageView_166",
      text = T("12\229\164\16913\229\176\143\230\151\182 \231\187\147\230\157\159"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68.5, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 202, h = 359.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "left_hero_bj",
      res = "UI/alpha/1080P/task/player_award_left_hero.png",
      name = "ImageView_201",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(125, 228.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224.5, h = 423.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "left_hero_bj",
      res = "UI/alpha/1080P/task/player_award_left_hero_top.png",
      name = "ImageView_202",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(125, 228.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_203",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_auto",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(196, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_203",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_shop",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 229, 143),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "img_playerAward_lv",
      z = 0,
      parent = "ImageView_158",
      text = "0",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.75, 25.5)
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
      name = "Label_playerAward_lv",
      z = 0,
      parent = "ImageView_158",
      text = T("\231\173\137\231\186\167"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.25, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 118.5, h = 362},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "task_playerAward_list_box",
      res = "UI/alpha/1080P/task/player_award_list_left.png",
      name = "listbox_left",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.5, 201.5)
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
      parent = "btn_award_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_165",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(458, 362)
    },
    t = "Layer",
    base = {
      parent = "task_playerAward_list_box",
      name = "task_playerAward_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(137, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 243, 167),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_205",
      z = 0,
      parent = "btn_auto",
      text = T("\228\184\128\233\148\174\233\162\134\229\143\150"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.25, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 243, 167),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_206",
      z = 0,
      parent = "btn_shop",
      text = T("\230\136\152\232\175\129\232\180\173\228\185\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.25, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 188.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "left_hero_bj",
      res = "UI/alpha/1080P/task/player_award_left_hero_title_bj.png",
      name = "ImageView_530",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(125, 49.25)
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
      name = "label_left_tit",
      z = 0,
      parent = "left_hero_bj",
      text = T("\229\165\150\229\138\177\228\184\187\233\162\152"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(125, 49.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 327.5, h = 7.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_bj",
      res = "UI/alpha/1080P/task/task_title_progress.png",
      name = "img_progress_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(246.5, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(134.5, 382)
    },
    t = "Layer",
    base = {
      parent = "task_playerAward_list_box",
      name = "listbox_right",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(482, 6)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 74, h = 75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "listbox_left",
      res = "UI/alpha/1080P/task/player_award_list_left_hero_log.png",
      name = "ImageView_397",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.25, 274.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120, h = 17},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "listbox_left",
      res = "UI/alpha/1080P/task/player_award_list_left_warrior.png",
      name = "ImageView_398",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.75, 230.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 103, h = 110.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "listbox_left",
      res = "UI/alpha/1080P/task/player_award_list_left_warrior_log.png",
      name = "ImageView_399",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.75, 115)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "listbox_left",
      res = "UI/alpha/1080P/task/player_award_list_left_hero.png",
      name = "ImageView_400",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.25, 50)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 242, 190),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_401",
      z = 0,
      parent = "listbox_left",
      text = T("\229\139\135\229\163\171\230\136\152\232\175\129"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 231.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 71, 46),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_401_Copy0",
      z = 0,
      parent = "listbox_left",
      text = T("\232\139\177\233\155\132\230\136\152\232\175\129"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.25, 50)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 382},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "listbox_right",
      res = "UI/alpha/1080P/task/player_award_list_item.png",
      name = "listbox_right_bj",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67, 191)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 248, 201),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "txt_listbox_right",
      z = 0,
      parent = "listbox_right_bj",
      text = T("10\231\186\167"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71.25, 358)
    }
  }
}

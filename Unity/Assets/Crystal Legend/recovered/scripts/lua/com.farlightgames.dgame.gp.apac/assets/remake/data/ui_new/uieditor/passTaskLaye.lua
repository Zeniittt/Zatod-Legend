ed.uieditor = ed.uieditor or {}
ed.uieditor.passTaskLaye = {
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
      name = "ui_layer_pass",
      z = 7
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
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "ui_layer_pass",
      name = "panel_top",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(43.5, 443)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(840, 50.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "title_bg_img",
      z = 0,
      parent = "panel_top",
      res = "UI/alpha/1080P/taskModel/task_title_bg.png",
      capInsets = CCRectMake(350, 0, 70, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(419.5, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 76.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_top",
      res = "UI/alpha/1080P/taskModel/day_task/day_task_lvbg_img.png",
      name = "image_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(282, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(838, 33)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_down",
      z = 0,
      parent = "ui_layer_pass",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_title_down_img.png",
      capInsets = CCRectMake(169, 16, 500, 1)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(463.5, 435)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(395, 11)
    },
    t = "Scale9Sprite",
    base = {
      name = "day_task_progress_bg",
      z = 0,
      parent = "panel_top",
      res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_6.png",
      capInsets = CCRectMake(22.5, 0, 350, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(322.5, 16)
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
      parent = "image_icon",
      text = "",
      size = 36
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 49.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(395, 11)
    },
    t = "Scale9Sprite",
    base = {
      name = "day_task_progress",
      z = 0,
      parent = "panel_top",
      res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_7.png",
      capInsets = CCRectMake(5, 0, 385, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(322.5, 16)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "ui_layer_pass",
      name = "panel_win",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(44, 48)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 231, 105),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_exp",
      z = 0,
      parent = "panel_top",
      text = T("\231\187\143\233\170\140"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(325.5, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 239),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_exp_str",
      z = 0,
      parent = "panel_top",
      text = "",
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(354, 31.5)
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
      parent = "panel_top",
      res = "UI/alpha/1080P/taskModel/task_rule_img.png",
      name = "btn_rule_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(218, 22.5)
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
      parent = "panel_top",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_Buy_lv",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(773, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 193),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "panel_top",
      text = T("\233\135\141\231\135\131\232\191\156\229\190\129"),
      size = 29
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(45.5, 26)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "panel_win",
      name = "panel_left",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-1, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.83, x = 0.83},
      flip = "",
      opacity = 255,
      fix_wh = {w = 99.6, h = 366.445},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_win",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_left_bg.jpg",
      name = "img_icon_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(246, 196.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(530, 366)
    },
    t = "Layer",
    base = {
      parent = "panel_win",
      name = "panel_list_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(293.5, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(125, 385)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_right",
      z = 1,
      parent = "panel_win",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_right_bg.png",
      capInsets = CCRectMake(14.5, 68.5, 100, 225)
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(832, 196.5)
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
      parent = "panel_win",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_shoping",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(626.5, 11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 173, h = 367.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_card_img.jpg",
      name = "card_img",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(98, 182)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.84, x = 1.05},
      flip = "",
      opacity = 255,
      fix_wh = {w = 192.675, h = 370.44},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_card_top.png",
      name = "card_img_top",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.5, 182)
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
      parent = "panel_win",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_all",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(771.5, 11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 150,
      fix_wh = {w = 193.95, h = 25.65},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_card_tit_bg.png",
      name = "award_bg_img",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 237),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_award",
      z = 9,
      parent = "panel_left",
      text = T("\229\165\150\229\138\177\228\184\187\233\162\152"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.5, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(310, 28)
    },
    t = "Scale9Sprite",
    base = {
      name = "time_bg_img",
      z = 0,
      parent = "panel_win",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_pop_str_bg.png",
      capInsets = CCRectMake(150, 15, 10, 2)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(129.5, -6)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(33, 33, 38),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_Buy_lv",
      z = 0,
      parent = "btn_Buy_lv",
      text = T("\232\180\173\228\185\176\231\173\137\231\186\167"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(182, 330)
    },
    t = "Layer",
    base = {
      parent = "panel_left",
      name = "panel_fashion",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(6, 32)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68, h = 73},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_icon_bg",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_left_hero_log.png",
      name = "img_warrior_log",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66, 365.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 241, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_Buy_lv_bg",
      z = 0,
      parent = "btn_Buy_lv",
      text = T("\232\180\173\228\185\176\231\173\137\231\186\167"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 94, h = 82.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_icon_bg",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_left_warrior_log.png",
      name = "btn_hero_log",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66.5, 140.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.30000007, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120, h = 22.10000119},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_icon_bg",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_left_hero_name_bg.png",
      name = "warrior_bg_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 310.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(114, 78, 50),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_warrior",
      z = 1,
      parent = "img_icon_bg",
      text = T("\229\139\135\229\163\171\230\136\152\232\175\129"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 310.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.30000007, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117, h = 27.950001505},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_icon_bg",
      res = "UI/alpha/1080P/taskModel/pass_task/pass_task_left_warrior_name_bg.png",
      name = "hero_bg_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66, 64.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(114, 78, 50),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_hero",
      z = 1,
      parent = "img_icon_bg",
      text = T("\232\139\177\233\155\132\230\136\152\232\175\129"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64, 65.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 247, 225),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_right_lv",
      z = 0,
      parent = "img_right",
      text = "",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 357.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(33, 33, 38),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_buy",
      z = 0,
      parent = "btn_shoping",
      text = T("\230\136\152\232\175\129\232\180\173\228\185\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 241, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_buy_Copy0",
      z = 0,
      parent = "btn_shoping",
      text = T("\230\136\152\232\175\129\232\180\173\228\185\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(33, 33, 38),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_120",
      z = 0,
      parent = "btn_all",
      text = T("\228\184\128\233\148\174\233\162\134\229\143\150"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 241, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_120_Copy0",
      z = 0,
      parent = "btn_all",
      text = T("\228\184\128\233\148\174\233\162\134\229\143\150"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(228, 197, 157),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_351",
      z = 0,
      parent = "time_bg_img",
      text = T("\230\156\172\230\156\159\231\187\147\230\157\159\229\137\169\228\189\153\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.5, 13.5)
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
      name = "label_time",
      z = 0,
      parent = "time_bg_img",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(148, 13.5)
    }
  }
}

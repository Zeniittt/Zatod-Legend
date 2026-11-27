ed.uieditor = ed.uieditor or {}
ed.uieditor.dayTaskLaye = {
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
      name = "ui_layer_day",
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
      parent = "ui_layer_day",
      name = "panel_top",
      z = 3
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
      position = ccp(268.5, 19.5)
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
      z = 2,
      parent = "ui_layer_day",
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
      position = ccp(321.5, 16)
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
      position = ccp(321.5, 16)
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
      parent = "ui_layer_day",
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
      anchor = ccp(0.5, 0.5),
      position = ccp(337.5, 31.5)
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
      position = ccp(353, 31.5)
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
      position = ccp(763.5, 25)
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
      anchor = ccp(0.5, 0.5),
      position = ccp(142, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(763, 375)
    },
    t = "Layer",
    base = {
      parent = "panel_win",
      name = "panel_list_pos",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(36.5, 28.5)
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
      name = "down_lay",
      z = 3
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
      scaleSize = CCSizeMake(779, 75)
    },
    t = "Scale9Sprite",
    base = {
      name = "down_bg_img",
      z = 0,
      parent = "down_lay",
      res = "UI/alpha/1080P/taskModel/day_task/day_task_down_box_bg.png",
      capInsets = CCRectMake(77, 0, 300, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(417, 49)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 140, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "down_lay",
      res = "UI/alpha/1080P/taskModel/day_task/day_task_line_b_img.png",
      name = "ImageView_262",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(190, 51.5)
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
      name = "task_str1",
      z = 0,
      parent = "down_lay",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(123, 67)
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
      name = "task_str2",
      z = 0,
      parent = "down_lay",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(123, 37.5)
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
      parent = "down_lay",
      name = "item_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(350, 27)
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
      name = "task_str3",
      z = 0,
      parent = "down_lay",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(695.5, 47.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 118.5, h = 105},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "down_lay",
      res = "UI/alpha/1080P/taskModel/day_task/day_task_box_img.png",
      name = "item_box_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.7999967, h = 19.7999967},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "down_lay",
      res = "UI/alpha/1080P/taskModel/task_rule_img.png",
      name = "image_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123, 65.5)
    }
  }
}

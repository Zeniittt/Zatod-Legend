ed.uieditor = ed.uieditor or {}
ed.uieditor.achTaskLaye = {
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
      name = "ui_layer_ach",
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
      parent = "ui_layer_ach",
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
      scaleSize = CCSizeMake(858, 50.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "title_bg_img",
      z = 0,
      parent = "panel_top",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_title_bg.png",
      capInsets = CCRectMake(250, 0, 358, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(412, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(58, 33, 20),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "Label_354",
      z = 0,
      parent = "panel_top",
      text = T("\230\136\144\229\176\177\230\149\176\239\188\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73.5, 25)
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
      parent = "ui_layer_ach",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_ach_num",
      z = 0,
      parent = "panel_top",
      text = "",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137, 25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(58, 33, 20),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3512",
      z = 0,
      parent = "panel_top",
      text = T("\231\130\185\230\149\176\239\188\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(497.5, 24)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(775, 342.5)
    },
    t = "Layer",
    base = {
      parent = "ui_layer_ach",
      name = "ach_list_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(75, 103)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_top",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_num_bg.png",
      name = "ImageView_357",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(559, 23)
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
      name = "label_ach_count",
      z = 0,
      parent = "panel_top",
      text = "",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(562.5, 23.5)
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
      parent = "ui_layer_ach",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 189.5, h = 77},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_top",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_btn_pop.png",
      name = "btn_ach_pop",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(703, 34.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_357",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_icon_img.png",
      name = "ImageView_358",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1.25, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_win",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      name = "img_line_L",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(239, 32)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(39, 37, 36),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_361",
      z = 0,
      parent = "btn_ach_pop",
      text = T("\230\136\144\229\176\177\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.75, 28.5)
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
      name = "Label_361_Copy0",
      z = 0,
      parent = "btn_ach_pop",
      text = T("\230\136\144\229\176\177\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.75, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_win",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      name = "img_line_R",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(575, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13, h = 13},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_ach_pop",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop_red.png",
      name = "ach_pop_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175.25, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_top",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_num_bg.png",
      name = "cup_diamond_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_top",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_num_bg.png",
      name = "cup_gold_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_top",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_num_bg.png",
      name = "cup_silver_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(320, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_top",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_num_bg.png",
      name = "cup_copper_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(430, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "cup_diamond_bg",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_cup_diamond.png",
      name = "cup_diamond",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-7.25, 10)
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
      name = "cup_diamond_amount",
      z = 0,
      parent = "cup_diamond_bg",
      text = "",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.75, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "cup_gold_bg",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_cup_gold.png",
      name = "cup_gold",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-7.25, 10)
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
      name = "cup_gold_amount",
      z = 0,
      parent = "cup_gold_bg",
      text = "",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.75, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "cup_silver_bg",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_cup_silver.png",
      name = "cup_silver",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-7.25, 10)
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
      name = "cup_silver_amount",
      z = 0,
      parent = "cup_silver_bg",
      text = "",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.75, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "cup_copper_bg",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_cup_copper.png",
      name = "cup_copper",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-7.25, 10)
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
      name = "cup_copper_amount",
      z = 0,
      parent = "cup_copper_bg",
      text = "",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.75, 10)
    }
  }
}

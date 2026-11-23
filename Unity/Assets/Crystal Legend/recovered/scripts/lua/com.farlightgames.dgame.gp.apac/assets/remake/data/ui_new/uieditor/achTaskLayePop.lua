ed.uieditor = ed.uieditor or {}
ed.uieditor.achTaskLayePop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "Panel_503", z = 0},
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
      fix_wh = {w = 587.5, h = 373},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_503",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop/ach_task_pop_bg.png",
      name = "ImageView_504",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(470.5, 257)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 95, h = 117.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_503",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop/ach_task_pop_cat_img.png",
      name = "ImageView_505",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(228.5, 436.5)
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
      name = "Label_506",
      z = 0,
      parent = "Panel_503",
      text = T("\229\189\147\229\137\141\231\130\185\230\149\176\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(593, 417.5)
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
      parent = "Panel_503",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_pop/ach_task_numbg_top.png",
      name = "ImageView_508",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(628, 417.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.4, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_503",
      res = "UI/alpha/1080P/taskModel/ach_task/ach_task_icon_img.png",
      name = "ImageView_509",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(598.5, 417.5)
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
      name = "label_num",
      z = 0,
      parent = "Panel_503",
      text = "210",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(632.5, 417.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.900000036},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48.600001944, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_503",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(754.5, 434)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(555, 301)
    },
    t = "Layer",
    base = {
      parent = "Panel_503",
      name = "ph_list_pos",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(193, 84.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36.3, h = 36.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_497",
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
      name = "label_tips",
      z = 0,
      parent = "Panel_503",
      text = T("\230\136\144\229\176\177\231\130\185\230\149\176\229\165\150\229\138\177"),
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(269.5, 419.5)
    }
  }
}

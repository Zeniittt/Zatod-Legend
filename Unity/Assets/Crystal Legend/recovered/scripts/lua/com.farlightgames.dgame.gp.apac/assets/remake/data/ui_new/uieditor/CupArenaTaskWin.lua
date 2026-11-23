ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaTaskWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(770, 440)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(40, 40, 5, 5),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(503, 251)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 629, h = 242},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_task_title2.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(378.5, 476)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(76, 70, 63),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "bg_title",
      text = T("\233\152\181\232\144\165\228\187\187\229\138\161"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(319.5, 83)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 397.5, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_task_title1.png",
      name = "bg_des",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(385, 391.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 244, 211),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_des",
      z = 0,
      parent = "bg_des",
      text = T("\230\181\183\233\128\137\230\156\159\233\151\180\230\175\143\229\164\1695\231\130\185\229\136\183\230\150\176\239\188\140\229\174\140\230\136\144\228\187\187\229\138\161\233\162\157\229\164\150\232\142\183\229\190\151\229\139\139\231\171\160"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 13)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.8, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(756, 431.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(691, 345)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_task",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(39.5, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.13, x = 1.13},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.29, h = 37.29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_12939",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.5, 28)
    }
  }
}

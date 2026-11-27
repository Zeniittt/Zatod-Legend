ed.uieditor = ed.uieditor or {}
ed.uieditor.taskScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 863, h = 531},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/bg/task_big_bj_1.png",
      name = "ImageView_126",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(451, 265)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 812.5, h = 455},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/bg/task_big_bj_2.png",
      name = "ImageView_126_Copy0",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(451, 265)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 300)
    },
    t = "Layer",
    base = {name = "button_top", z = 4},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(831, 153)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 300)
    },
    t = "Layer",
    base = {name = "button_up", z = 2},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(828.5, 153.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 91.5, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "button_top",
      res = "UI/alpha/1080P/task/task_rig_but_up.png",
      name = "dailyTask_press",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 266.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 91.5, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "button_top",
      res = "UI/alpha/1080P/task/task_rig_but_up.png",
      name = "playerAward_press",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 196.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 91.5, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "button_top",
      res = "UI/alpha/1080P/task/task_rig_but_up.png",
      name = "playerTask_press",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 126)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 91.5, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "button_top",
      res = "UI/alpha/1080P/task/task_rig_but_up.png",
      name = "achievement_press",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 55.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 93.5, h = 67},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "button_up",
      res = "UI/alpha/1080P/task/task_rig_but.png",
      name = "dailyTask_cancel",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 264)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 93.5, h = 67},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "button_up",
      res = "UI/alpha/1080P/task/task_rig_but.png",
      name = "playerAward_cancel",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 194)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 93.5, h = 67},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "button_up",
      res = "UI/alpha/1080P/task/task_rig_but.png",
      name = "playerTask_cancel",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 123.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 93.5, h = 67},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "button_up",
      res = "UI/alpha/1080P/task/task_rig_but.png",
      name = "achievement_cancel",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 53)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(113, 68, 38),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "dailyTask_press_txt",
      z = 0,
      parent = "dailyTask_press",
      text = T("\230\151\165\229\184\184"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 35.5)
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
      name = "dailyTask_cancel_txt",
      z = 0,
      parent = "dailyTask_cancel",
      text = T("\230\151\165\229\184\184"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.25, 40)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(113, 68, 38),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "playerAward_press_txt",
      z = 0,
      parent = "playerAward_press",
      text = T("\229\165\150\229\138\177"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 35)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(113, 68, 38),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "playerTask_press_txt",
      z = 0,
      parent = "playerTask_press",
      text = T("\228\187\187\229\138\161"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 34.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(113, 68, 38),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "achievement_press_txt",
      z = 0,
      parent = "achievement_press",
      text = T("\230\136\144\229\176\177"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 33.5)
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
      name = "playerAward_cancel_txt",
      z = 0,
      parent = "playerAward_cancel",
      text = T("\229\165\150\229\138\177"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.25, 39.5)
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
      name = "playerTask_cancel_txt",
      z = 0,
      parent = "playerTask_cancel",
      text = T("\228\187\187\229\138\161"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.25, 39.5)
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
      name = "achievement_cancel_txt",
      z = 0,
      parent = "achievement_cancel",
      text = T("\230\136\144\229\176\177"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.25, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 54, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_brak",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63, 508)
    }
  },
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
      position = ccp(-28.5, -4.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_brak",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "ImageView_393",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.5, 28.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.mainScene = {
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
      name = "left_top_panel",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "right_top_panel",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "left_bottom_panel",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "right_bottom_panel",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(265, 100)
    },
    t = "Layer",
    base = {
      parent = "left_top_panel",
      name = "head_root",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7.5, 432.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 157),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "playLv",
      z = 2,
      parent = "head_root",
      text = "Lv80",
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111.5, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(43, 28, 11),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "playLv_blak",
      z = 1,
      parent = "head_root",
      text = "Lv80",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 45.5)
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
      name = "playerName",
      z = 1,
      parent = "head_root",
      text = T(""),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175, 79)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(105, 9.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "expBJ",
      z = 1,
      parent = "head_root",
      res = "UI/alpha/1080P/main/main_head_exp_1.png",
      capInsets = CCRectMake(5, 1.5, 2.5, 1.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(195, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 93.5, h = 94},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "head_root",
      res = "UI/alpha/1080P/main/main_head_playtop.png",
      name = "playHeadTop",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 62)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 238, h = 74},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "head_root",
      res = "UI/alpha/1080P/main/main_head_bg.png",
      name = "playNameBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150.5, 60.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 73, h = 73},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "head_root",
      res = "UI/alpha/1080P/main/main_head_play.png",
      name = "playHead",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.25, 62)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "head_root",
      res = "UI/alpha/1080P/main/main_head_exp_2.png",
      name = "exp_progress_bar",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(142.5, 44.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.mianUiLay = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 100)
    },
    t = "Layer",
    base = {name = "Panel_head", z = 0},
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
      fix_wh = {w = 204, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_head",
      res = "UI/alpha/1080P/main/main_head_namebg.png",
      name = "playNameBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(129, 81.5)
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
      parent = "Panel_head",
      res = "UI/alpha/1080P/main/main_head_play.png",
      name = "playHead",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 63.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_head",
      res = "UI/alpha/1080P/main/main_head_vipimg.png",
      name = "vipImg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.5, 51)
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
      parent = "Panel_head",
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
      fix_wh = {w = 156, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_head",
      res = "UI/alpha/1080P/main/main_head_vipbg.png",
      name = "vipBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(129, 51.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 6.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "expBJ",
      z = 1,
      parent = "Panel_head",
      res = "UI/alpha/1080P/main/main_head_expbj.png",
      capInsets = CCRectMake(5, 1.5, 2.5, 1.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(173, 71)
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
      parent = "Panel_head",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.5, 89)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 2,
      flip = "",
      color = ccc3(255, 233, 157),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "playLv",
      z = 2,
      parent = "Panel_head",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.5, 71.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 248, 164),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "vipNum",
      z = 2,
      parent = "Panel_head",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.5, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.97},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97, h = 4.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_head",
      res = "UI/alpha/1080P/main/main_head_expimg.png",
      name = "exp_progress_bar",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(124.5, 71)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(0, 0, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "vipNum_bank",
      z = 1,
      parent = "Panel_head",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120, 50)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 2,
      flip = "",
      color = ccc3(43, 28, 11),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "playLv_blak",
      z = 1,
      parent = "Panel_head",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.5, 71)
    }
  }
}

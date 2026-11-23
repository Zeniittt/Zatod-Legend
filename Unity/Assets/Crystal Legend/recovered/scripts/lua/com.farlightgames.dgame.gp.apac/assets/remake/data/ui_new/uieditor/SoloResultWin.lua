ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloResultWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 960, h = 227},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/newlog/bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(480, 129.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 417.5, h = 186.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/newlog/win.png",
      name = "ImageView_13082",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 267.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_13082",
      res = "UI/alpha/1080P/chesscard/newlog/win_1.png",
      name = "ImageView_13084",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(208.75, 56.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 250, 105),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_13085",
      z = 0,
      parent = "bg",
      text = T("\231\172\1722\229\144\141"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 194)
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
      name = "Label_13089",
      z = 0,
      parent = "bg",
      text = T("\231\167\175\229\136\134:0"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(480, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_13090",
      z = 0,
      parent = "bg",
      text = "+10",
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(502.5, 32)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 176, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/newlog/playername_bg.png",
      name = "ImageView_13094",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 458, h = 155.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/newlog/lose_2.png",
      name = "ImageView_547",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 250.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_549",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 122)
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
      name = "Label_13088",
      z = 0,
      parent = "ImageView_13094",
      text = T("\229\144\141\229\173\151\229\176\177\230\152\175\228\184\131\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_547",
      res = "UI/alpha/1080P/chesscard/newlog/lose_1.png",
      name = "ImageView_548",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(229, 58.75)
    }
  }
}

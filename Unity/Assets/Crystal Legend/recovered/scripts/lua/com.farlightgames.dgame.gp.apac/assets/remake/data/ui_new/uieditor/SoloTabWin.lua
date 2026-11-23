ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloTabWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(694.5, 445)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(250, 40, 194.5, 7.5),
      res = "UI/alpha/1080P/chesscard/log/result_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(480, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/result_title.png",
      name = "bg_title1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131.75, 423.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/result_title.png",
      name = "bg_title2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292.25, 423.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/result_title.png",
      name = "bg_title3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(451.25, 423.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/result_title.png",
      name = "bg_title4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(612.75, 423.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 198, 138),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title1",
      z = 0,
      parent = "bg_title1",
      text = T("\231\142\169\229\174\182"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 198, 138),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title2",
      z = 0,
      parent = "bg_title2",
      text = T("\230\138\128\232\131\189"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 198, 138),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title3",
      z = 0,
      parent = "bg_title3",
      text = T("\228\184\187\230\181\129\230\180\190"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 198, 138),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title4",
      z = 0,
      parent = "bg_title4",
      text = T("\231\167\152\229\174\157"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 11)
    }
  }
}

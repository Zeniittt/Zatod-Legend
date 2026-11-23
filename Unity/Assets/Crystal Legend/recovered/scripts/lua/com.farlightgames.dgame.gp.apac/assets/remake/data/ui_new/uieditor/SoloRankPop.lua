ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloRankPop = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 960, h = 94},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/newrank/lose_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 401)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 253, h = 254},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/newrank/lose_3.png",
      name = "ImageView_521",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 171, h = 162.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/newrank/win_6.png",
      name = "ImageView_522",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 47)
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
      name = "Label_523",
      z = 2,
      parent = "bg",
      text = T("\231\172\172\228\184\128\229\144\141"),
      size = 42
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 47)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_524",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 306, h = 98.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_524",
      res = "UI/alpha/1080P/chesscard/newrank/win_2.png",
      name = "ImageView_515",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 96.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 214, h = 63},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_524",
      res = "UI/alpha/1080P/chesscard/newrank/win_3.png",
      name = "ImageView_516",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -77.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 337, h = 8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_524",
      res = "UI/alpha/1080P/chesscard/newrank/win_4.png",
      name = "ImageView_517",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-310, 53)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 380.5, h = 6.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_524",
      res = "UI/alpha/1080P/chesscard/newrank/win_5.png",
      name = "ImageView_518",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-290, -53)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -337, h = 8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_524",
      res = "UI/alpha/1080P/chesscard/newrank/win_4.png",
      name = "ImageView_517_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(309.5, 53)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -380.5, h = 6.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_524",
      res = "UI/alpha/1080P/chesscard/newrank/win_5.png",
      name = "ImageView_518_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(289.5, -53)
    }
  }
}

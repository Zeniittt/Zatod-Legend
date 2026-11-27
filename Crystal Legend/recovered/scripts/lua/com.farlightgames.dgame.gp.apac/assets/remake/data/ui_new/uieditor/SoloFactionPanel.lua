ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloFactionPanel = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 776.5, h = 444},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/faction_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(471.5, 263)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.4, h = 35.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/faction_8.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(322.25, 410.5)
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
      name = "Label_1554",
      z = 0,
      parent = "bg",
      text = T("\230\148\187\229\135\187\230\181\129"),
      size = 28
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(396.25, 410.5)
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
      name = "Label_1555",
      z = 0,
      parent = "bg",
      text = T("\230\148\187\229\135\187\233\128\159\229\186\166"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(529.25, 410.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(678.5, 357.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(51.25, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/faction_12.png",
      name = "bg_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.25, 400.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/big_star1.png",
      name = "bg_star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.75, 421)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/big_star1.png",
      name = "bg_star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(126.75, 421)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/big_star1.png",
      name = "bg_star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(146.25, 421)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/big_star1.png",
      name = "bg_star4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.75, 421)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 78, h = 17.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/chesscard/faction_11.png",
      name = "bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.5, 10.25)
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
      name = "label_exp",
      z = 3,
      parent = "bg_bar",
      text = "1/20",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.5, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star1",
      res = "UI/alpha/1080P/chesscard/big_star2.png",
      name = "star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.75, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star2",
      res = "UI/alpha/1080P/chesscard/big_star2.png",
      name = "star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.75, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star3",
      res = "UI/alpha/1080P/chesscard/big_star2.png",
      name = "star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.75, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star4",
      res = "UI/alpha/1080P/chesscard/big_star2.png",
      name = "star4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.75, 10)
    }
  }
}

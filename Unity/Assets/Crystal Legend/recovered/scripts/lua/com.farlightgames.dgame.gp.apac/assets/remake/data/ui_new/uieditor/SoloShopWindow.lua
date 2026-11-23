ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloShopWindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(535, 301)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 96.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/skill/random.png",
      name = "btn_random",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(356.5, -109.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_random",
      res = "UI/alpha/1080P/chesscard/skill/gold_1.png",
      name = "img_cost_random",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.25, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cost_random",
      z = 10,
      parent = "btn_random",
      text = "100",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.75, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 96.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/skill/refresh.png",
      name = "btn_refresh",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(356.5, -21.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_random",
      z = 10,
      parent = "btn_random",
      text = T("\233\154\143\230\156\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.25, 39.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_random",
      res = "UI/alpha/1080P/chesscard/skill/random_1.png",
      name = "ImageView_10990",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.75, 30.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_refresh",
      res = "UI/alpha/1080P/chesscard/skill/gold_1.png",
      name = "img_cost_refresh",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.25, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cost_refresh",
      z = 10,
      parent = "btn_refresh",
      text = "20",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.75, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_refresh",
      z = 10,
      parent = "btn_refresh",
      text = T("\229\136\183\230\150\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.25, 39.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29.5, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_refresh",
      res = "UI/alpha/1080P/chesscard/skill/refresh_1.png",
      name = "ImageView_10989",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.75, 30.75)
    }
  }
}

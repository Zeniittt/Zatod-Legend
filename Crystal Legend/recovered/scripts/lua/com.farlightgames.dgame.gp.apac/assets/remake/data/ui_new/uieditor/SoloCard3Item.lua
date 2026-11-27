ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloCard3Item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 197.5, h = 281.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/skill/to_jpg_x_alpha/bg_3.png",
      name = "bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
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
      name = "name",
      z = 0,
      parent = "bg",
      text = T("\230\151\160\230\149\140\230\148\187\229\135\187"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(98.75, 155.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22, h = 26},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/skill/star.png",
      name = "star1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.25, 35.75)
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
      name = "label_desc",
      z = 0,
      parent = "bg",
      text = T("\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143\232\191\176\230\143\143"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(41.25, 118.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 123.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/skill/card_gold_bg.png",
      name = "bg_gold",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(98.75, -18.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43, h = 42.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/skill/icon_bg_3.png",
      name = "bg_faction1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31.75, 225.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(98.75, 215.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_gold",
      res = "UI/alpha/1080P/chesscard/gold_2.png",
      name = "icon_gold",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.75, 15.75)
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
      name = "label_gold",
      z = 0,
      parent = "bg_gold",
      text = "300",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.75, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_faction1",
      res = "UI/alpha/1080P/chesscard/faction.png",
      name = "faction1",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, 21.25)
    }
  }
}

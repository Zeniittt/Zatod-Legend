ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloCard1Item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 198.5, h = 282.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/skill/to_jpg_x_alpha/bg_1.png",
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
      position = ccp(99.25, 156.25)
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
      res = "UI/alpha/1080P/chesscard/skill/icon_bg_1.png",
      name = "bg_faction1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.75, 245.75)
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
      res = "UI/alpha/1080P/chesscard/skill/star_2.png",
      name = "star1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 36.25)
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
      position = ccp(41.75, 119.25)
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
      position = ccp(99.25, -17.75)
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
      position = ccp(99.25, 216.25)
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
      res = "UI/alpha/1080P/chesscard/skill/star_2.png",
      name = "star2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.75, 36.25)
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
      res = "UI/alpha/1080P/chesscard/skill/star_2.png",
      name = "star3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.75, 36.25)
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
      res = "UI/alpha/1080P/chesscard/skill/icon_bg_1.png",
      name = "bg_faction2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.25, 206.75)
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
      text = "100",
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
      fix_wh = {w = 22, h = 26},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/skill/star_2.png",
      name = "star4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122.25, 36.25)
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
      res = "UI/alpha/1080P/chesscard/skill/star_2.png",
      name = "star5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142.25, 36.25)
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
      parent = "bg_faction2",
      res = "UI/alpha/1080P/chesscard/faction.png",
      name = "faction2",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, 21.25)
    }
  }
}

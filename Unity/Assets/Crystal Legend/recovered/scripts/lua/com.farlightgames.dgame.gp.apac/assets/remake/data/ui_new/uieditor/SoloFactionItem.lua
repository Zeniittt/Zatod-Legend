ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloFactionItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 11.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/faction_10.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9.45, h = 9.45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/star_2.png",
      name = "bg_star1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(7, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 10.5, h = 10.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_star1",
      res = "UI/alpha/1080P/chesscard/star_1.png",
      name = "star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(5.25, 5.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9.45, h = 9.45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/star_2.png",
      name = "bg_star2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9.45, h = 9.45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/star_2.png",
      name = "bg_star3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 10.5, h = 10.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_star2",
      res = "UI/alpha/1080P/chesscard/star_1.png",
      name = "star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(5.25, 5.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9.45, h = 9.45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/star_2.png",
      name = "bg_star4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/tagicon4.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 10.5, h = 10.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_star3",
      res = "UI/alpha/1080P/chesscard/star_1.png",
      name = "star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(5.25, 5.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/faction_9.png",
      name = "bar",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 5.75)
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
      name = "label_score",
      z = 2,
      parent = "bg",
      text = "1/8",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 5.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 10.5, h = 10.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_star4",
      res = "UI/alpha/1080P/chesscard/star_1.png",
      name = "star4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(5.25, 5.25)
    }
  }
}

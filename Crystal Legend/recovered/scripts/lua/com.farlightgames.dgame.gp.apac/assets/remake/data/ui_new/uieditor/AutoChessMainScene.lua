ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessMainScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/battle_bg/bbg_chess.jpg",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 149.5, h = 80.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/5.png",
      name = "5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(203, 362.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 71.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/1.png",
      name = "1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(243, 417.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 126.5, h = 71},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/2.png",
      name = "2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(325.5, 417.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 122, h = 71.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/3.png",
      name = "3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(408, 417.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 141, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/6.png",
      name = "6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292, 362)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110.5, h = 71},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/4.png",
      name = "4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(490, 417.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/7.png",
      name = "7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(385.5, 362)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178.5, h = 102},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/9.png",
      name = "9",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148, 292)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 122.5, h = 82},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/8.png",
      name = "8",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478, 362)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 165.5, h = 103},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/10.png",
      name = "10",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250, 292)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156, h = 102},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/11.png",
      name = "11",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355, 291.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 137.5, h = 102.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/12.png",
      name = "12",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(462, 290)
    }
  }
}

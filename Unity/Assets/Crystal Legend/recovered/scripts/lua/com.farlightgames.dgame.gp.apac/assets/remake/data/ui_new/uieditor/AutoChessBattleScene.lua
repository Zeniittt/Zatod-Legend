ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessBattleScene = {
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
      name = "background_layer",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
      name = "content_layer",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
    base = {name = "ui_layer", z = 3},
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
      fix_wh = {w = 1170, h = 852},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/battle_bg/bbg_chess.jpg",
      name = "background",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "content_layer",
      name = "main_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
      parent = "content_layer",
      name = "top_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
      parent = "ui_layer",
      name = "damageBath_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
      parent = "ui_layer",
      name = "menu_touch_layer",
      z = 0
    },
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
      fix_wh = {w = 54, h = 55},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "ui_layer",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "pause_btn",
      z = 100
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 490)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68.5, h = 53},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "ui_layer",
      res = "UI/alpha/1080P/battle/battle_auto_bg_1.png",
      name = "speedButtonBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(885, 85)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 149.5, h = 80.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "background",
      res = "UI/alpha/1080P/chess/battle/5.png",
      name = "1_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(202.5, 442.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 71.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "background",
      res = "UI/alpha/1080P/chess/battle/1.png",
      name = "1_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(243, 497)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 126.5, h = 71},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "background",
      res = "UI/alpha/1080P/chess/battle/2.png",
      name = "2_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(325.5, 497)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 122, h = 71.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "background",
      res = "UI/alpha/1080P/chess/battle/3.png",
      name = "3_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(407.5, 497)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 141, h = 81},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "background",
      res = "UI/alpha/1080P/chess/battle/6.png",
      name = "2_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292, 442.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110.5, h = 71},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "background",
      res = "UI/alpha/1080P/chess/battle/4.png",
      name = "4_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(490, 497)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178.5, h = 102},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "background",
      res = "UI/alpha/1080P/chess/battle/9.png",
      name = "1_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(147.5, 372.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 122.5, h = 82},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "background",
      res = "UI/alpha/1080P/chess/battle/8.png",
      name = "4_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477.5, 442.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 165.5, h = 103},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "background",
      res = "UI/alpha/1080P/chess/battle/10.png",
      name = "2_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250, 372.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pause_btn",
      res = "UI/alpha/1080P/battle/battle_pause.png",
      name = "ImageView_7202",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156, h = 102},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "background",
      res = "UI/alpha/1080P/chess/battle/11.png",
      name = "3_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(353, 372.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 137.5, h = 102.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "background",
      res = "UI/alpha/1080P/chess/battle/12.png",
      name = "4_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(460, 372.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29.5, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "speedButtonBg",
      res = "UI/alpha/1080P/battle/battle_fastforward_unchoose.png",
      name = "speedButton1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.25, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29.5, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "speedButtonBg",
      res = "UI/alpha/1080P/battle/battle_fastforward_2.png",
      name = "speedButton2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.25, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 491, h = 218},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "background",
      res = "UI/alpha/1080P/chess/battle/battleground.png",
      name = "chessHitArea",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(301.5, 426.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "speedButtonBg",
      res = "UI/alpha/1080P/battle/battle_fastforward_3.png",
      name = "speedButton3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.25, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138, h = 81},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "background",
      res = "UI/alpha/1080P/chess/battle/7.png",
      name = "3_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(384, 442.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.heroHaggleHeroSelectWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 586.5, h = 399.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_hero_select_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(499.5, 263.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(475, 250)
    },
    t = "Layer",
    base = {
      name = "panel_record",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(265, 139.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_close.png",
      name = "btn_close",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(774, 445)
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
      size = 20,
      text = T("\233\128\137\230\139\169\232\139\177\233\155\132"),
      name = "label_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(499.5, 433)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_window_title_line.png",
      name = "ImageView_36473",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(419, 430.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -60, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_window_title_line.png",
      name = "ImageView_36473_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(579, 431.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 147.5, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_button_red.png",
      name = "btn_select_hero",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(498.5, 108.5)
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
      size = 16,
      text = "",
      name = "label_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(497.5, 402.5)
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
      name = "Label_36476",
      z = 0,
      parent = "btn_select_hero",
      text = T("\231\161\174\229\174\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73.75, 27)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloMatchWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 266, h = 102.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/match/matching_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 489.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_need_time",
      z = 0,
      parent = "bg",
      text = "60s",
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(178, 66.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36.3999948, h = 36.3999948},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/closed.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133, -8.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_require_time",
      z = 0,
      parent = "bg",
      text = T("\233\162\132\232\174\161\229\140\185\233\133\141\230\151\182\233\151\180\239\188\154"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 66.25)
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
      name = "label_time",
      z = 0,
      parent = "bg",
      text = "00:03",
      size = 35
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133, 33.25)
    }
  }
}

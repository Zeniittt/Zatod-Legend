ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessMatchWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 268, h = 100.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chess/mode/matching.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 488)
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
      text = T("\233\162\132\232\174\161\229\140\185\233\133\141\230\151\182\233\151\180:"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 83.75)
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
      size = 22
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(179, 83.75)
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
      text = "00:00",
      size = 40
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134, 43.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.7999946, h = 38.4999945},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134, 4.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_1645",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  }
}

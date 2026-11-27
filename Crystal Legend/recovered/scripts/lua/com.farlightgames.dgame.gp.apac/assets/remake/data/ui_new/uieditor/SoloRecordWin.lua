ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloRecordWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(456, 495.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(150, 100, 156, 8),
      res = "UI/alpha/1080P/chesscard/log/log_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(481, 30)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(385, 383)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(35, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "arrow_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(455.5, 265)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -57.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "arrow_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0.5, 265)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(70, 51, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3048",
      z = 0,
      parent = "bg",
      text = T("\231\172\1721/1\233\161\181"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(228, 42)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 91.5, h = 2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/newlog/line.png",
      name = "ImageView_3049",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150, 42)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -91.5, h = 2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/newlog/line.png",
      name = "ImageView_3049_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(306, 42)
    }
  }
}

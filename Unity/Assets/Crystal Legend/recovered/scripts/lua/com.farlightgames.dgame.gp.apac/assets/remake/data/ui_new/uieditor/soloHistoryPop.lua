ed.uieditor = ed.uieditor or {}
ed.uieditor.soloHistoryPop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(725.5, 412)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 25, 21.5, 21.5),
      res = "UI/alpha/1080P/chesscard/match/match_bg1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 275.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 235, 194),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_title_slr",
      z = 1,
      parent = "bg",
      text = T("\229\176\143\229\134\176\229\134\176\229\133\168\230\152\142\230\152\159\229\142\134\229\143\178\232\174\176\229\189\149"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(362.75, 386.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 52, h = 52},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/closed.png",
      name = "btn_close_slr",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(711.75, 405)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 480, h = 43.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/invitefriend_bg.png",
      name = "ImageView_8964",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(364.75, 387)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/line.png",
      name = "ImageView_8965",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(193.75, 386)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -80.5, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/line.png",
      name = "ImageView_8965_Copy0",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(531.75, 386)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(703, 348.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_525",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(10.75, 11)
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
      parent = "btn_close_slr",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_2357",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 26)
    }
  }
}

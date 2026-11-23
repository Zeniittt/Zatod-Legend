ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessTagNode = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(45, 65)
    },
    t = "Layer",
    base = {name = "Panel_6006", z = 0},
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
      scaleSize = CCSizeMake(15.5, 15.5)
    },
    t = "Layer",
    base = {
      parent = "Panel_6006",
      name = "Panel_tag_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(60, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(272.5, 135)
    },
    t = "Layer",
    base = {
      parent = "Panel_6006",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-2, -67.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(227, 125.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_item",
      z = 5,
      parent = "bg",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(9.5, 11, 20, 200)
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(48.5, 131.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(213.5, 111)
    },
    t = "Layer",
    base = {
      parent = "bg_item",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38, h = 51.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_6006",
      res = "UI/alpha/1080P/chess/battle/chess_tag_open.png",
      name = "icon_open",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5.5, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_6006",
      res = "UI/alpha/1080P/chess/battle/chess_tag_close.png",
      name = "icon_close",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5.5, 4)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(47, 63.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "btn_op",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1, 68)
    }
  }
}

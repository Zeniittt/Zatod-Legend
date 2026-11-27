ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessDamageItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(148, 38)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 234, 197),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage",
      z = 11,
      parent = "bg",
      text = "1000",
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(38.5, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.3, x = 0.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 8.55, h = 9},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "img_star_1",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11, 8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.3, x = 0.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 8.55, h = 9},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "img_star_2",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 7.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.3, x = 0.3},
      flip = "",
      opacity = 255,
      fix_wh = {w = 8.55, h = 9},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "img_star_3",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 8)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(106.5, 10)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_bar",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/chess_data_bg_1.png",
      capInsets = CCRectMake(2.5, 2.5, 5, 5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(38, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4, x = 0.4},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_bg.png",
      name = "node_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/chess/battle/chess_data_bg_2.png",
      name = "img_bar_red",
      z = 10
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0.5, 5)
    }
  }
}

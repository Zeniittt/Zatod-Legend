ed.uieditor = ed.uieditor or {}
ed.uieditor.herodetailSkin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "layer_skin", z = 0},
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
      fix_wh = {w = 268, h = 464},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_skin",
      res = "UI/art/card_bg_big_2.jpg",
      name = "skin_card",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-300, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 270, h = 466},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skin_card",
      res = "UI/alpha/1080P/summon/card_quality_white.png",
      name = "frame_card",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.5, 235)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(581, 457)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_mid",
      z = 0,
      parent = "layer_skin",
      res = "UI/alpha/1080P/hero/hero_bg_mid_1.png",
      capInsets = CCRectMake(12, 150, 12, 150)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-163.5, -225)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 159.5, h = 456},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_mid",
      res = "UI/alpha/1080P/skin/skin_bg_1.png",
      name = "deco_right",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(507.5, 229.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 159.5, h = 456},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_mid",
      res = "UI/alpha/1080P/skin/skin_bg_1.png",
      name = "deco_left",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.5, 229)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_mid",
      res = "UI/alpha/1080P/skin/skin_arrow.png",
      name = "arrow1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100, 88)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 40.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_mid",
      res = "UI/alpha/1080P/skin/skin_arrow.png",
      name = "arrow2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(491.5, 88.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 535.05, h = 460},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_mid",
      res = "UI/alpha/1080P/skin/skin_bg.png",
      name = "bg_skin",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290, 229.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(318, 135)
    },
    t = "Layer",
    base = {
      parent = "bg_mid",
      name = "layer_skinlist",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(120.5, 17)
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
      parent = "bg_mid",
      name = "skin_name_g",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(296, 426.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 94},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_skinlist",
      res = "UI/alpha/1080P/skin/skin_comsoon.png",
      name = "next_skin",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(220, -12)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 234, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skin_name_g",
      res = "UI/alpha/1080P/skin/skin_name_frame.png",
      name = "bg_skin_name",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
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
      name = "skin_name",
      z = 5,
      parent = "skin_name_g",
      text = T("\232\136\185\233\149\191+2"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 124.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_skinlist",
      res = "UI/alpha/1080P/skin/skin_small_frame.png",
      name = "cur_skin",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(117, -12)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 124.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_skinlist",
      res = "UI/alpha/1080P/skin/skin_small_frame.png",
      name = "pre_skin",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12, -12)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueEventBusiness = {
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
      res = "UI/alpha/1080P/rogue/instance/event/shop_bg.jpg",
      name = "image_bg",
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
      fix_wh = {w = 752.5, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/event/shop_info_bg.png",
      name = "event_info_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(688.5, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 12.5, 25, 12.5),
      res = "UI/alpha/1080P/lottery/lottery_meat_bg.png",
      name = "image_retry_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(838.5, 515)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 12.5, 25, 12.5),
      res = "UI/alpha/1080P/lottery/lottery_meat_bg.png",
      name = "image_pearl_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(949.5, 515)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 186.5, h = 171},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/event/shop_dec2.png",
      name = "dec2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.5, 550.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 449.5, h = 537.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/event/shop_dec3.png",
      name = "dec3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(349, 268.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 141, h = 264.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/event/shop_dec1.png",
      name = "dec1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(390, 587.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 170.5, h = 364},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/event/shop_dec4.png",
      name = "dec4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(448, 183)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(471, 382.5)
    },
    t = "Layer",
    base = {
      parent = "event_info_bg",
      name = "panel_option",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(172.25, 98)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 202, 143),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "event_info_bg",
      text = T("\233\154\144\229\177\133\229\149\134\228\186\186"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(407.25, 554.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "event_info_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_event_title.png",
      name = "image_title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(307.75, 554.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 46, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "event_info_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_event_title.png",
      name = "image_title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(507.75, 554.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(205, 190, 139),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc",
      z = 0,
      parent = "event_info_bg",
      text = T("\232\191\189\229\175\187\231\175\157\231\129\171\231\154\132\228\186\174\229\133\137\239\188\140\228\189\160\229\143\145\231\142\176\228\186\134\228\184\128\229\144\141\233\154\144\229\177\133\229\149\134\228\186\186"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(407.25, 510.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 365, h = 439.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/event/shop_icon.png",
      name = "shop_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.52, 0.05),
      position = ccp(225, 100)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 115.5, h = 247},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/event/shop_dec5.png",
      name = "dec5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(391, 596)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_retry_bg",
      res = "UI/alpha/1080P/rogue/instance/rogue_retry.png",
      name = "retry_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 18.25)
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
      name = "retry_amount",
      z = 0,
      parent = "image_retry_bg",
      text = "88888",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_pearl_bg",
      res = "UI/alpha/1080P/icon/pearl.png",
      name = "pearl_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 18.25)
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
      name = "pearl_amount",
      z = 0,
      parent = "image_pearl_bg",
      text = "88888",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 17.75)
    }
  }
}

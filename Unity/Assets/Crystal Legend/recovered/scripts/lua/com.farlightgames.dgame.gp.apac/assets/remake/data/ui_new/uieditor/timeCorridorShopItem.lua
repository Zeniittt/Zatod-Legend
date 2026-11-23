ed.uieditor = ed.uieditor or {}
ed.uieditor.timeCorridorShopItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 163, h = 203},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_skin_bg_green.png",
      name = "bg",
      z = 0
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
      name = "label_name",
      z = 0,
      parent = "bg",
      text = T("\229\185\189\233\172\188"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.5, 48)
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
      parent = "bg",
      name = "icon_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(81.5, 126.5)
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
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/1/timecorridor_token_1.png",
      name = "icon_price",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.5, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 117, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_price",
      z = 0,
      parent = "bg",
      text = "1998",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90.5, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_own",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(81.5, 101.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 91.5, h = 20.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_shop_text_bg_2.png",
      name = "buy_limit_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.5, 73.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 119, h = 21},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_shop_text_bg_3.png",
      name = "progress",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56, 198.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(163, 203)
    },
    t = "Scale9Sprite",
    base = {
      name = "mask",
      z = 0,
      parent = "layer_own",
      res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_mask.png",
      capInsets = CCRectMake(5, 5, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = -12,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.5, h = 47.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_own",
      res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_own.png",
      name = "img_own",
      z = 0
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
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buy_limit",
      z = 0,
      parent = "buy_limit_bg",
      text = T("\233\153\144\232\180\173\239\188\1545/10"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.75, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(92, 58, 14),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_progress",
      z = 0,
      parent = "progress",
      text = T("\232\191\152\233\156\128999\229\143\175\229\133\145\230\141\162"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8, 12)
    }
  }
}

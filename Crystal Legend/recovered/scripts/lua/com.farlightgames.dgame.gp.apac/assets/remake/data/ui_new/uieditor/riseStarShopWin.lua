ed.uieditor = ed.uieditor or {}
ed.uieditor.riseStarShopWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 943, h = 500.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/risestar/shop_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(505, 242.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(572, 254)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_record",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(229.5, 130.75)
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
      name = "label_title",
      z = 1,
      parent = "bg",
      text = "",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(519.5, 424.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/risestar/shop_costBg.png",
      name = "image_costItem",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(711.5, 419.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 220, h = 89},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/risestar/shop_title.png",
      name = "ImageView_39338",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(525, 423.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.5, h = 53.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/risestar/shop_close.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(821, 458.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_costItem",
      res = "UI/alpha/1080P/risestar/itemicon.png",
      name = "ImageView_39187",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.25, 16)
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
      name = "label_num",
      z = 0,
      parent = "image_costItem",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 14.5)
    }
  }
}

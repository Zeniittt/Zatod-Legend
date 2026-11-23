ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_exchange_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 135, h = 179},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/exchange/exchange_goods_bg.png",
      name = "item_bg",
      z = 0
    },
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
      scaleSize = CCSizeMake(85, 85)
    },
    t = "Layer",
    base = {
      parent = "item_bg",
      name = "item_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(24, 79)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(73, 60, 47),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_name",
      z = 0,
      parent = "item_bg",
      text = T("\233\129\147\229\133\183\229\144\141\231\167\176\228\184\131\228\184\170\229\173\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 65.5)
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
      name = "exchange_limit",
      z = 0,
      parent = "item_bg",
      text = T("\233\153\144\232\180\17399\230\172\161"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 44)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(73, 60, 47),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "need_token",
      z = 0,
      parent = "item_bg",
      text = "12345",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 18)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(139, 184)
    },
    t = "Scale9Sprite",
    base = {
      name = "sold_out_mask",
      z = 0,
      parent = "item_bg",
      res = "UI/alpha/1080P/shop/shop_goods_soldout_shade.png",
      capInsets = CCRectMake(54.5, 58.5, 54.5, 58.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 87)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 69.5, h = 48.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "sold_out_mask",
      res = "UI/alpha/1080P/shop/shop_goods_soldout_icon.png",
      name = "ImageView_767",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.5, 125)
    }
  }
}

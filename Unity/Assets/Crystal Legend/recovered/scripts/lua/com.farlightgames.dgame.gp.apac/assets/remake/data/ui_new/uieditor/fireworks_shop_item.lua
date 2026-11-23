ed.uieditor = ed.uieditor or {}
ed.uieditor.fireworks_shop_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 71.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/nianmonster/nian_goods_shop_cloth.png",
      name = "image_bg",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131.5, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_goods_shop_goodsname.png",
      name = "image_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 160.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 147, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_goods_shop_buytime.png",
      name = "image_buy_limit_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 66.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 80)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_item",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(38.25, 60.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 71.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_goods_shop_shadow.png",
      name = "image_mask",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 35.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 118, h = 33.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_goods_shop_button.png",
      name = "btn_buy",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_unlock_time",
      z = 1,
      parent = "image_bg",
      text = T("1\230\156\1368\230\151\1650\230\151\182\232\167\163\233\148\129"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76.25, 35.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(249, 211, 137),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name",
      z = 0,
      parent = "image_name_bg",
      text = T("\231\169\191\229\164\169\231\140\180"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.75, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 224),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cost",
      z = 0,
      parent = "btn_buy",
      text = "25000",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_buy",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "image_cost_type",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36, h = 43},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_item",
      res = "UI/alpha/1080P/nianmonster/nian_goods_shop_lock.png",
      name = "image_lock",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(77, 77)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_firework_shadow",
      z = 1,
      parent = "panel_item",
      res = "UI/alpha/1080P/nianmonster/nian_pre_firework_shadow.png",
      capInsets = CCRectMake(13, 13, 13, 13)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 40)
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
      parent = "panel_item",
      res = "UI/alpha/1080P/shop/shop_goods_soldout_icon.png",
      name = "image_saleout",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 40)
    }
  }
}

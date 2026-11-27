ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueBlessShopItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138.5, h = 174.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/bless/bless_shop_rank1.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(2.5, 2.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 145.5, h = 181.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/bless_shop_choose.png",
      name = "image_select",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69, 86.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(126, 91.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(6.5, 71.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 236),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name",
      z = 0,
      parent = "image_bg",
      text = T("\231\165\157\231\166\143\229\144\141\231\167\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68.5, 49.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 216),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_price",
      z = 0,
      parent = "image_bg",
      text = "220",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(69, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138.5, h = 174.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/bless_shop_shade.png",
      name = "image_sold_out",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69, 87)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/icon/pearl.png",
      name = "image_token",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 204,
      fix_wh = {w = 138.5, h = 174.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/bless_shop_shade.png",
      name = "image_reinforced",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69, 87)
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
      name = "label_bless_type",
      z = 2,
      parent = "image_bg",
      text = T("\229\161\148"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68.5, 72.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(44, 28)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_bless_type_bg",
      z = 1,
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/bless_name_bg_1.png",
      capInsets = CCRectMake(14.5, 9, 14.5, 9)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, 73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 65, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_reinforced",
      res = "UI/alpha/1080P/rogue/bless/bless_shop_reinforce_tab.png",
      name = "image_reinforced_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.75, 164.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 218, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reinforced",
      z = 0,
      parent = "image_reinforced_tag",
      text = T("\229\183\178\229\188\186\229\140\150"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29, 10)
    }
  },
  {
    config = {
      rotation = -14,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_sold_out",
      res = "UI/alpha/1080P/newshop/over_tf.png",
      name = "img_nil",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.25, 97.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 94, 94),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "soldout_label",
      z = 0,
      parent = "img_nil",
      text = T("\229\148\174\231\189\132"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 20.5)
    }
  }
}

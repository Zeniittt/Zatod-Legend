ed.uieditor = ed.uieditor or {}
ed.uieditor.shopitem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 0,
      visible = true,
      scaleSize = CCSizeMake(164, 188.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(0, 129.5, 0.5, 0.5),
      res = "UI/alpha/1080P/shop/shop_goods_bg_1.png",
      name = "img_bj",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.5, 88.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 111.5, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bj",
      res = "UI/alpha/1080P/shop/shop_count_down_bg.png",
      name = "pan_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82, 186.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_time",
      res = "UI/alpha/1080P/shop/shop_count_down.png",
      name = "ImageView_1092",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(6.75, 9.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "pan_time",
      text = T("20\229\176\143\230\151\182\229\144\142\228\184\139\230\158\182"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bj",
      res = "UI/alpha/1080P/shop/shop_discount.png",
      name = "pan_zhe",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.5, 160.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name",
      z = 0,
      parent = "img_bj",
      text = T("\233\129\147\229\133\183\229\144\141\231\167\176\228\184\131\228\184\170\229\173\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.5, 71.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_zhe",
      z = 0,
      parent = "pan_zhe",
      text = T("4\230\138\152"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 11.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 215, 144),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_num",
      z = 0,
      parent = "img_bj",
      text = T("\229\137\169\228\189\153\230\149\176\233\135\143:17"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.5, 53.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(113, 105, 94),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_long_price",
      z = 0,
      parent = "img_bj",
      text = "50000",
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137, 33.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bj",
      res = "UI/alpha/1080P/shop/shop_line_2.png",
      name = "line_long_price",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.5, 33.25)
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
      parent = "img_bj",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "img_price",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55, 23.25)
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
      parent = "img_bj",
      text = "999",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(73, 22.75)
    }
  },
  {
    config = {
      rotation = -14,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 36},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bj",
      res = "UI/alpha/1080P/newshop/over_tf.png",
      name = "img_nil",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82, 106.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(164, 188.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "soldout_shade",
      z = 50,
      parent = "img_bj",
      res = "UI/alpha/1080P/shop/shop_goods_soldout_shade.png",
      capInsets = CCRectMake(0, 129.5, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82, 94.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 91.5, h = 23.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bj",
      res = "UI/alpha/1080P/newshop/foreverlimit_bg.png",
      name = "pan_chaozhi",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 180.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(164, 188.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_bg",
      z = 0,
      parent = "img_bj",
      res = "UI/alpha/1080P/shop/shop_goods_bg_1.png",
      capInsets = CCRectMake(0, 129.5, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82, 94.25)
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
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.5, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_chaozhi",
      res = "UI/alpha/1080P/toparena/toparena_shop_sale.png",
      name = "ImageView_126",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.25, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 91.5, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_chaozhi",
      res = "UI/alpha/1080P/newshop/foreverlimit_shade.png",
      name = "img_chaozhi_shade",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.75, 11.75)
    }
  }
}

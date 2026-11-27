ed.uieditor = ed.uieditor or {}
ed.uieditor.buyFashionShopBox = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(860.5, 479.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg",
      z = 0,
      res = "UI/alpha/1080P/common/com_new_2.png",
      capInsets = CCRectMake(15, 32.5, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 2)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(860.5, 479.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg",
      z = 999,
      res = "UI/alpha/1080P/common/com_img_9bg2.png",
      capInsets = CCRectMake(20, 35, 15, 55)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 2)
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
    base = {name = "layer_skin", z = 0},
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
      position = ccp(503.5, 231)
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
      position = ccp(74.5, 231)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 594.5, h = 460},
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 234, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_mid",
      res = "UI/alpha/1080P/skin/skin_name_frame.png",
      name = "bg_skin_name",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(296, 426.5)
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
      z = 0,
      parent = "bg_skin_name",
      text = T(""),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      fix_wh = {w = 40.5, h = 41.25},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      parent = "bg",
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0,
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(850, 469)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_288",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(240, 26)
    },
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/1080P/summon/item_num_bg.png",
      name = "shop_cosmetic_text_bg",
      parent = "bg",
      z = 0,
      capInsets = CCRectMake(2, 4, 89, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(560, 120)
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
      name = "shop_cosmetic_text_1",
      z = 0,
      parent = "shop_cosmetic_text_bg",
      text = T("\230\138\152\230\137\163\229\137\169\228\189\153"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75, 13)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(226, 96, 96),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "shop_cosmetic_text",
      z = 0,
      parent = "shop_cosmetic_text_bg",
      text = T("1\229\164\16910\229\176\143\230\151\182"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(110, 13)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 153.599990784, h = 45.199997288},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_buy_orange",
      z = 0,
      parent = "bg"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(460, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 153.599990784, h = 45.199997288},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_buy_blue",
      z = 0,
      parent = "bg"
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(660, 67.5)
    }
  }
}

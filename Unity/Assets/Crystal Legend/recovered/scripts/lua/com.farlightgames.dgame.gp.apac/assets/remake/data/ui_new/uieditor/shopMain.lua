ed.uieditor = ed.uieditor or {}
ed.uieditor.shopMain = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(209, 540)
    },
    t = "Layer",
    base = {name = "pan_butt", z = 2},
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
      fix_wh = {w = 2, h = 469},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_butt",
      res = "UI/alpha/1080P/shop/shop_line_1.png",
      name = "ImageView_1011",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210, 237)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 58.5)
    },
    t = "Layer",
    base = {
      parent = "pan_butt",
      name = "pan_shop_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45, 403)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(268.5, 38.5)
    },
    t = "Layer",
    base = {name = "pan_title", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(71, 482.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 58.5)
    },
    t = "Layer",
    base = {
      parent = "pan_butt",
      name = "pan_shop_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45, 340)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_1",
      res = "UI/alpha/1080P/shop/shop_tab_unchoose.png",
      name = "btn_shop_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_1",
      res = "UI/alpha/1080P/shop/shop_tab_choose.png",
      name = "btn_shop_1_pass",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 29)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 58.5)
    },
    t = "Layer",
    base = {
      parent = "pan_butt",
      name = "pan_shop_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45, 277)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_1",
      res = "UI/alpha/1080P/shop/shop_gold_icon_unchoose.png",
      name = "ImageView_1016",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 167, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_1",
      z = 0,
      parent = "btn_shop_1",
      text = T("\231\153\190\232\180\167\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(58.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_1",
      res = "UI/alpha/1080P/shop/shop_point_unchoose.png",
      name = "ImageView_1018",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(278, 30)
    },
    t = "Layer",
    base = {name = "pan_updata", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(446.5, 480)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 58.5)
    },
    t = "Layer",
    base = {
      parent = "pan_butt",
      name = "pan_shop_4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45, 214.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 268.5, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_title",
      res = "UI/alpha/1080P/campaign/worldmap/worldmap_title_bg.png",
      name = "ImageView_1077",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_2",
      res = "UI/alpha/1080P/shop/shop_tab_unchoose.png",
      name = "btn_shop_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_1_pass",
      res = "UI/alpha/1080P/shop/shop_point_choose.png",
      name = "ImageView_1019",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_1_pass",
      res = "UI/alpha/1080P/shop/shop_gold_icon_choose.png",
      name = "ImageView_1020",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_2",
      res = "UI/alpha/1080P/shop/shop_tab_choose.png",
      name = "btn_shop_2_pass",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 29)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(82, 42, 18),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_1_pass_shadow",
      z = 0,
      parent = "btn_shop_1_pass",
      text = T("\231\153\190\232\180\167\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(59, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 217),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_1_pass",
      z = 0,
      parent = "btn_shop_1_pass",
      text = T("\231\153\190\232\180\167\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(58.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 58.5)
    },
    t = "Layer",
    base = {
      parent = "pan_butt",
      name = "pan_shop_5",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45, 151.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_title",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141.5, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(740, 483)
    },
    t = "Layer",
    base = {name = "pan_item", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(213, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(175, 58.5)
    },
    t = "Layer",
    base = {
      parent = "pan_butt",
      name = "pan_shop_6",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45, 89)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_3",
      res = "UI/alpha/1080P/shop/shop_tab_unchoose.png",
      name = "btn_shop_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_2",
      res = "UI/alpha/1080P/shop/shop_arena_icon_unchoose .png",
      name = "ImageView_1016",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 167, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_2",
      z = 0,
      parent = "btn_shop_2",
      text = T("\231\171\158\230\138\128\229\156\186\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(58.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_3",
      res = "UI/alpha/1080P/shop/shop_tab_choose.png",
      name = "btn_shop_3_pass",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_2",
      res = "UI/alpha/1080P/shop/shop_point_unchoose.png",
      name = "ImageView_1018",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(175, 58.5)
    },
    t = "Layer",
    base = {
      parent = "pan_butt",
      name = "pan_shop_7",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_2_pass",
      res = "UI/alpha/1080P/shop/shop_point_choose.png",
      name = "ImageView_1019",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_2_pass",
      res = "UI/alpha/1080P/shop/shop_arena_icon_choose.png",
      name = "ImageView_1020",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(82, 42, 18),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_2_pass_shadow",
      z = 0,
      parent = "btn_shop_2_pass",
      text = T("\231\171\158\230\138\128\229\156\186\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(59, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 217),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_2_pass",
      z = 0,
      parent = "btn_shop_2_pass",
      text = T("\231\171\158\230\138\128\229\156\186\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(58.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 278, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_updata",
      res = "UI/alpha/1080P/pvp/battlenum_bg.png",
      name = "ImageView_1082",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_4",
      res = "UI/alpha/1080P/shop/shop_tab_unchoose.png",
      name = "btn_shop_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_1080",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_4",
      res = "UI/alpha/1080P/shop/shop_tab_choose.png",
      name = "btn_shop_4_pass",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_updata",
      res = "UI/alpha/1080P/shop/shop_gold_exchange_button.png",
      name = "btn_updata",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(261.5, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_3",
      res = "UI/alpha/1080P/shop/shop_crusade_icon_unchoose.png",
      name = "ImageView_1016",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 167, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_3",
      z = 0,
      parent = "btn_shop_3",
      text = T("\232\191\156\229\190\129\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(58.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_3",
      res = "UI/alpha/1080P/shop/shop_point_unchoose.png",
      name = "ImageView_1018",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1084",
      z = 0,
      parent = "pan_updata",
      text = T("\228\184\139\230\172\161\229\136\183\230\150\176\230\151\182\233\151\180:  00:00:00"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141.5, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_5",
      res = "UI/alpha/1080P/shop/shop_tab_unchoose.png",
      name = "btn_shop_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_3_pass",
      res = "UI/alpha/1080P/shop/shop_point_choose.png",
      name = "ImageView_1019",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_3_pass",
      res = "UI/alpha/1080P/shop/shop_crusade_icon_choose.png",
      name = "ImageView_1020",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_5",
      res = "UI/alpha/1080P/shop/shop_tab_choose.png",
      name = "btn_shop_5_pass",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 29)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(82, 42, 18),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_3_pass_shadow",
      z = 0,
      parent = "btn_shop_3_pass",
      text = T("\232\191\156\229\190\129\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(59, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 217),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_3_pass",
      z = 0,
      parent = "btn_shop_3_pass",
      text = T("\232\191\156\229\190\129\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(58.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_6",
      res = "UI/alpha/1080P/shop/shop_tab_unchoose.png",
      name = "btn_shop_6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_4",
      res = "UI/alpha/1080P/shop/shop_dream_icon_unchoose.png",
      name = "ImageView_1016",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 167, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_4",
      z = 0,
      parent = "btn_shop_4",
      text = T("\230\162\166\229\162\131\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(58.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_6",
      res = "UI/alpha/1080P/shop/shop_tab_choose.png",
      name = "btn_shop_6_pass",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_4",
      res = "UI/alpha/1080P/shop/shop_point_unchoose.png",
      name = "ImageView_1018",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_6",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "pan_shop_6_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150, 50)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_4_pass",
      res = "UI/alpha/1080P/shop/shop_point_choose.png",
      name = "ImageView_1019",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_4_pass",
      res = "UI/alpha/1080P/shop/shop_dream_icon_choose.png",
      name = "ImageView_1020",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(82, 42, 18),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_4_pass_shadow",
      z = 0,
      parent = "btn_shop_4_pass",
      text = T("\230\162\166\229\162\131\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(59, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 217),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_4_pass",
      z = 0,
      parent = "btn_shop_4_pass",
      text = T("\230\162\166\229\162\131\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(58.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_7",
      res = "UI/alpha/1080P/shop/shop_tab_unchoose.png",
      name = "btn_shop_7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "pan_shop_7",
      res = "UI/alpha/1080P/shop/shop_tab_choose.png",
      name = "btn_shop_7_pass",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_5",
      res = "UI/alpha/1080P/shop/shop_guild_icon_unchoose .png",
      name = "ImageView_1016",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 167, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_5",
      z = 0,
      parent = "btn_shop_5",
      text = T("\229\133\172\228\188\154\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(58.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_5",
      res = "UI/alpha/1080P/shop/shop_point_unchoose.png",
      name = "ImageView_1018",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_5_pass",
      res = "UI/alpha/1080P/shop/shop_point_choose.png",
      name = "ImageView_1019",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_5_pass",
      res = "UI/alpha/1080P/shop/shop_guild_icon_choose .png",
      name = "ImageView_1020",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(82, 42, 18),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_5_pass_shadow",
      z = 0,
      parent = "btn_shop_5_pass",
      text = T("\229\133\172\228\188\154\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(59, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 217),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_5_pass",
      z = 0,
      parent = "btn_shop_5_pass",
      text = T("\229\133\172\228\188\154\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(58.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 167, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_6",
      z = 0,
      parent = "btn_shop_6",
      text = T("\229\164\150\232\167\130\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(58.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_6",
      res = "UI/alpha/1080P/shop/shop_point_unchoose.png",
      name = "ImageView_1018",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_6",
      res = "UI/alpha/1080P/shop/shop_cosmetic_icon_unchoose.png",
      name = "ImageView_1016",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(82, 42, 18),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_6_pass",
      z = 0,
      parent = "btn_shop_6_pass",
      text = T("\229\164\150\232\167\130\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(58.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 217),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_6_pass_shadow",
      z = 0,
      parent = "btn_shop_6_pass",
      text = T("\229\164\150\232\167\130\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(59, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_6_pass",
      res = "UI/alpha/1080P/shop/shop_point_choose.png",
      name = "ImageView_1019",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_6_pass",
      res = "UI/alpha/1080P/shop/shop_cosmetic_icon_choose.png",
      name = "ImageView_1020",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_7",
      res = "UI/alpha/1080P/shop/shop_tavern_icon_unchoose .png",
      name = "ImageView_10161",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 167, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_7",
      z = 0,
      parent = "btn_shop_7",
      text = T("\233\133\146\233\166\134\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_7",
      res = "UI/alpha/1080P/shop/shop_point_unchoose.png",
      name = "ImageView_10181",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_7_pass",
      res = "UI/alpha/1080P/shop/shop_point_choose.png",
      name = "ImageView_10191",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_7_pass",
      res = "UI/alpha/1080P/shop/shop_tavern_icon_choose .png",
      name = "ImageView_10201",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(82, 42, 18),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_7_pass_shadow",
      z = 0,
      parent = "btn_shop_7_pass",
      text = T("\233\133\146\233\166\134\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(59, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 217),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_shop_7_pass",
      z = 0,
      parent = "btn_shop_7_pass",
      text = T("\233\133\146\233\166\134\229\149\134\229\186\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(58.5, 29.25)
    }
  }
}

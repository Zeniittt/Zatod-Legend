ed.uieditor = ed.uieditor or {}
ed.uieditor.buyExteriorShopBox = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(494, 281.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 25, 51, 341),
      res = "UI/alpha/1080P/common/com_new_1.png",
      name = "ImageView_286",
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
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0,
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(714, 395)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(314, 30.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(65, 7.5, 65, 7.5),
      res = "UI/alpha/1080P/package/bg_compose.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(483, 388)
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
      scaleSize = CCSizeMake(467.5, 87)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 29.5, 15, 29.5),
      res = "UI/alpha/1080P/scale9/box_bg.png",
      name = "conent_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 322.5)
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
      name = "title_text",
      z = 0,
      parent = "title_bg",
      text = T("\232\180\173\228\185\176\229\164\150\232\167\130"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(155.5, 16.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(459, 12.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(17, 0.5, 17, 0.5),
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "ImageView_305",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(477.5, 244.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(64, 63)
    },
    t = "Layer",
    base = {
      parent = "conent_bg",
      name = "icon_parent",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(27.25, 13)
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
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_name",
      z = 0,
      parent = "conent_bg",
      text = T("\233\173\130\229\140\163\229\165\150\229\136\184"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(111.75, 68)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 59, 56),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "item_desc",
      z = 0,
      parent = "conent_bg",
      text = T("\231\137\169\229\147\129\230\143\143\232\191\176\231\137\169\229\147\129\230\143\143\232\191\176\231\137\169\229\147\129\230\143\143\232\191\176\231\137\169\229\147\129\230\143\143\232\191\176\231\137\169\229\147\129\230\143\143\232\191\176\231\137\169\229\147\129\230\143\143\232\191\176\231\137\169\229\147\129\230\143\143\232\191\176"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(111.75, 33.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(459, 12.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "line",
      z = 0,
      parent = "ImageView_305",
      res = "UI/alpha/1080P/common/line_2b.png",
      capInsets = CCRectMake(17, 0.5, 17, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(696.5, 6.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 14.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_305",
      res = "UI/alpha/1080P/common/line_star_2b.png",
      name = "ImageView_307",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(463.5, 13.25)
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
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379, 177.5)
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
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(579, 177.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 153.599990784, h = 45.199997288},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/shop/cosmetic/shop_cosmetic_text_bg.png",
      name = "shop_cosmetic_text_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 220)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(95, 79, 68),
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
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120, 16.75)
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
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(155.5, 16.75)
    }
  }
}

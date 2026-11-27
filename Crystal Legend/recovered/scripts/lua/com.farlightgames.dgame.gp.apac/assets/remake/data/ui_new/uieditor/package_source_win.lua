ed.uieditor = ed.uieditor or {}
ed.uieditor.package_source_win = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(298, 396)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15, 15, 100, 100),
      res = "UI/alpha/1080P/package/bg_normal.png",
      name = "bg_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 277.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 236.5, h = 168},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_detail",
      res = "UI/alpha/1080P/package/bg_deso.png",
      name = "deco_top",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150.5, 305.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 273.6, h = 64.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_detail",
      res = "UI/alpha/1080P/package/bg_bottom_deco.png",
      name = "deco_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149.5, 33.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 400)
    },
    t = "Scale9Sprite",
    base = {
      name = "detail_frame",
      z = 2,
      parent = "bg_detail",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_big.png",
      capInsets = CCRectMake(200, 107, 71, 103.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148.5, 196.5)
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
      parent = "bg_detail",
      name = "top_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(149, 155)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(284, 204.5)
    },
    t = "Layer",
    base = {
      parent = "bg_detail",
      name = "mid_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(6.5, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 197.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_detail",
      res = "UI/alpha/1080P/package/seg_normal.png",
      name = "deco_mid",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149, 240.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(44, 82, 167),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name",
      z = 2,
      parent = "top_layer",
      text = T("\233\129\147\229\133\183\229\144\141\231\167\176\229\177\133\228\184\173\229\142\159\229\136\153"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 126.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(107, 97, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_amount_str",
      z = 0,
      parent = "top_layer",
      text = T("\230\140\129\230\156\137\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(2.5, 98)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(44, 82, 167),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_amount",
      z = 0,
      parent = "top_layer",
      text = "1234",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(3.5, 98)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.78, x = 0.78},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72.93, h = 72.93},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "top_layer",
      res = "UI/alpha/1080P/package/1st.jpg",
      name = "icon_item",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 185.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = -1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205.5, h = -32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "top_layer",
      res = "UI/alpha/1080P/package/bg_compose.png",
      name = "ImageView_1810",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 126.5)
    }
  }
}

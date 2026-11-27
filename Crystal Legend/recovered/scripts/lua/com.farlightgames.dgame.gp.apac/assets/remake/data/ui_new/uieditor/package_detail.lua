ed.uieditor = ed.uieditor or {}
ed.uieditor.package_detail = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(244, 377.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(99.5, 230, 0.5, 0.5),
      res = "UI/alpha/1080P/package/bg_normal.png",
      name = "bg_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477.5, 267.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 385)
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
      position = ccp(122.5, 188.75)
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
      position = ccp(123.5, 288.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 229.05, h = 63},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_detail",
      res = "UI/alpha/1080P/package/new/equip_tattoos.png",
      name = "deco_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122.5, 36.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 217.25, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_detail",
      res = "UI/alpha/1080P/package/seg_normal.png",
      name = "deco_mid1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122, 218.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(227.5, 210.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_main_attr",
      z = 0,
      parent = "bg_detail",
      res = "UI/alpha/1080P/package/bg_attr.png",
      capInsets = CCRectMake(10, 15, 2, 1.5)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(122, 216.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(61, 48, 36),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name",
      z = 1,
      parent = "bg_detail",
      text = T("\233\129\147\229\133\183\229\144\141\231\167\176\229\177\133\228\184\173\229\142\159\229\136\153"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122, 258.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(226, 203)
    },
    t = "Layer",
    base = {
      parent = "bg_main_attr",
      name = "layer_attr",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.75, 6.5)
    }
  },
  {
    config = {
      rotation = 180,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(233, 29)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_item_name",
      z = 0,
      parent = "bg_main_attr",
      res = "UI/alpha/1080P/package/new/equip_name_bg.png",
      capInsets = CCRectMake(92.5, 0, 70, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.75, 251.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(75, 75)
    },
    t = "Layer",
    base = {
      parent = "bg_main_attr",
      name = "icon_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(76.25, 274.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(225, 25)
    },
    t = "Layer",
    base = {
      parent = "bg_main_attr",
      name = "amount",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1.25, 213.5)
    }
  }
}

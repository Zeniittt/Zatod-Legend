ed.uieditor = ed.uieditor or {}
ed.uieditor.StoreDiamondItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 206, h = 187.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newshop/diamond_bg.png",
      name = "bg",
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
      name = "price",
      z = 0,
      parent = "bg",
      text = T("\194\1656.00"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(192, 255, 253),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 0,
      parent = "bg",
      text = T("300\233\146\187\231\159\179"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103, 65.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125, h = 125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/newshop_recharge_diamond_01.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103, 111.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57, h = 60},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/diamonddouble_bg.png",
      name = "bg_double",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 158.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 94.5, h = 20.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/diamondgift_bg.png",
      name = "bg_addition",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55, 160.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.2, h = 25.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_double",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "ImageView_372",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(199, 52, 4),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "double_num",
      z = 0,
      parent = "bg_double",
      text = "+3280",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(22.5, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(227, 97, 31),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_double_tips",
      z = 0,
      parent = "bg_double",
      text = T("\233\166\150\230\172\161\229\143\140\229\128\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.5, 40.5)
    }
  }
}

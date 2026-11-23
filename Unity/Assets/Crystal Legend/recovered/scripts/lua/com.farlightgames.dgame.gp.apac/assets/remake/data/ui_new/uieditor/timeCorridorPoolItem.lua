ed.uieditor = ed.uieditor or {}
ed.uieditor.timeCorridorPoolItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(592, 32)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(7.5, 7.5, 0.5, 0.5),
      res = "UI/alpha/1080P/timecorridor/timecorridor_pool_bg_3.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_pool_star.png",
      name = "ImageView_466",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.5, 16)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 237),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_467",
      z = 0,
      parent = "bg",
      text = T("\229\135\186\231\142\176\230\166\130\231\142\135\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(31, 16)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 209, 24),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_prob",
      z = 0,
      parent = "bg",
      text = "5%",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(111, 16)
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
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/1/timecorridor_token_1.png",
      name = "exchange_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(546, 16)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 237),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_exchange_tip",
      z = 0,
      parent = "bg",
      text = T("\233\135\141\229\164\141\232\142\183\229\190\151\230\151\182\232\189\172\229\140\150\228\184\186\230\162\166\229\141\142\229\135\157\231\143\160"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(531, 16)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 250, 229),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "exchange_num",
      z = 0,
      parent = "exchange_icon",
      text = "x100",
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.5, 7)
    }
  }
}

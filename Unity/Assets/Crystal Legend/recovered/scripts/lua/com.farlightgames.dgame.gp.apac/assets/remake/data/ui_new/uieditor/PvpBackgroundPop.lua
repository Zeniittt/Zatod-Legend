ed.uieditor = ed.uieditor or {}
ed.uieditor.PvpBackgroundPop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(625, 414.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(24, 20, 16, 10),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "ImageView_24577",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478.5, 243.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(317.5, 32)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_24579",
      z = 0,
      parent = "ImageView_24577",
      res = "UI/alpha/1080P/package/bg_compose.png",
      capInsets = CCRectMake(100, 0, 5.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(312.5, 391.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_24577",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "ImageView_24581",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(121.5, 388.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_24577",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_24582",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(504, 388.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45.9, h = 46.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_24577",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(605.5, 396.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_24584",
      z = 0,
      parent = "ImageView_24577",
      text = T("\228\188\152\229\133\136\229\177\149\231\164\186\233\157\158\231\187\143\229\133\184\232\131\140\230\153\175\239\188\140\229\143\140\230\150\185\233\131\189\228\184\186\233\157\158\231\187\143\229\133\184\232\131\140\230\153\175\230\151\182\229\177\149\231\164\186\233\152\178\229\174\136\230\150\185\232\131\140\230\153\175\227\128\130"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313, 359.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(594.5, 264.5)
    },
    t = "Layer",
    base = {
      parent = "ImageView_24577",
      name = "Panel_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(15.5, 81.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_24577",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "button",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(312, 48.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 121.5, h = 47},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "ImageView_24577",
      res = "UI/alpha/1080P/pvp/button_using.png",
      name = "ImageView_24588",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(312.5, 48.75)
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
      name = "Label_24580",
      z = 0,
      parent = "ImageView_24579",
      text = T("\232\131\140\230\153\175\232\174\190\229\174\154"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(158.75, 17)
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
      name = "ImageView_24590",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 29.5)
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
      name = "Label_24587",
      z = 0,
      parent = "button",
      text = T("\228\189\191\231\148\168"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.75, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(209, 192, 173),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_24589",
      z = 0,
      parent = "ImageView_24588",
      text = T("\228\189\191\231\148\168\228\184\173"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.25, 23.5)
    }
  }
}

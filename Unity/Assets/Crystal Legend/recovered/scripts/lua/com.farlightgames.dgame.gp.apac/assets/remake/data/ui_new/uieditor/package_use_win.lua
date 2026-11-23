ed.uieditor = ed.uieditor or {}
ed.uieditor.package_use_win = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(276, 352.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(99.5, 44.5, 0.5, 51),
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
      position = ccp(138, 278.75)
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
      position = ccp(138.5, 35.75)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(175, 45.5),
      flip = "",
      labelConfig = {
        color = ccc3(254, 241, 169)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/package/btn_package2.png",
      capInsets = CCRectMake(35, 16.5, 47.5, 17.5),
      name = "use_button",
      z = 0,
      parent = "bg_detail",
      text = T("\231\161\174\232\174\164\228\189\191\231\148\168"),
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(138, 37.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(289.5, 375)
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
      position = ccp(138, 179.75)
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
      position = ccp(138, 126.75)
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
      name = "mid_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-342, -94.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 157.99999052, h = 7.599999544},
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
      position = ccp(138, 206.75)
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
      name = "name",
      z = 1,
      parent = "top_layer",
      text = T("\233\129\147\229\133\183\229\144\141\231\167\176\229\177\133\228\184\173\229\142\159\229\136\153"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 120.5)
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
      text = T("\230\140\129\230\156\137:"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(2.5, 94.5)
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
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(3.5, 94)
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
      name = "icon",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 177.5)
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
      name = "label_desc",
      z = 0,
      parent = "mid_layer",
      text = T("\233\128\137\230\139\169\230\149\176\233\135\143\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(352.5, 262)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(258, 40)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_number",
      z = 0,
      parent = "mid_layer",
      res = "UI/alpha/1080P/package/bg_soldout.png",
      capInsets = CCRectMake(5, 5, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 229.5)
    }
  },
  {
    config = {
      rotation = 180,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205.5, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "top_layer",
      res = "UI/alpha/1080P/package/bg_compose.png",
      name = "bg_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 120)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(42, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "minus_button",
      z = 0,
      parent = "bg_number",
      res = "UI/alpha/1080P/package/btn_package1.png",
      capInsets = CCRectMake(10, 10, 38.5, 16.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(42, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "add_ten_button",
      z = 0,
      parent = "bg_number",
      res = "UI/alpha/1080P/package/btn_package1.png",
      capInsets = CCRectMake(10, 10, 38.5, 16.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(239, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(42, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "add_button",
      z = 0,
      parent = "bg_number",
      res = "UI/alpha/1080P/package/btn_package1.png",
      capInsets = CCRectMake(10, 10, 38.5, 16.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(185, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "use_amount_limit",
      z = 0,
      parent = "bg_number",
      text = "/123",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(100.5, 20)
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
      name = "use_amount",
      z = 0,
      parent = "bg_number",
      text = "123",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(100, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1014",
      z = 0,
      parent = "minus_button",
      text = "-",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1016",
      z = 0,
      parent = "add_ten_button",
      text = T("\230\156\128\229\164\167"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1015",
      z = 0,
      parent = "add_button",
      text = "+",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_detail",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "close_button",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(266, 348.75)
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
      parent = "close_button",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "icon_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  }
}

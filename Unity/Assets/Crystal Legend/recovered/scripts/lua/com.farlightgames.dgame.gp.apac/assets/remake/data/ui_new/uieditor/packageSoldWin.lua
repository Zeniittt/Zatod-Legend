ed.uieditor = ed.uieditor or {}
ed.uieditor.packageSoldWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(276, 459.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(40, 150, 40, 150),
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(289.5, 474)
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
      position = ccp(138, 228.75)
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
      position = ccp(139.5, 377.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 228, h = 54},
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
      position = ccp(138.5, 34.75)
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
      name = "btn_soldout",
      z = 0,
      parent = "bg_detail",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(138, 46.25)
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
      position = ccp(138, 229.75)
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
      position = ccp(-342, -44.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(264.5, 46)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_sold_price",
      z = 0,
      parent = "mid_layer",
      res = "UI/alpha/1080P/package/bg_popup.png",
      capInsets = CCRectMake(7, 0.5, 0.5, 0.5)
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
      name = "label_name",
      z = 2,
      parent = "top_layer",
      text = T("\233\129\147\229\133\183\229\144\141\231\167\176\229\177\133\228\184\173\229\142\159\229\136\153"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 127.5)
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
      text = T("\233\128\137\230\139\169\229\135\186\229\148\174\231\154\132\230\149\176\233\135\143\239\188\154"),
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
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(0.5, 102.5)
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
      name = "label_chiyou",
      z = 0,
      parent = "top_layer",
      text = "1234",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(1.5, 102.5)
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
      position = ccp(1.5, 180)
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
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(264.5, 46)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_preview",
      z = 0,
      parent = "mid_layer",
      res = "UI/alpha/1080P/package/bg_popup.png",
      capInsets = CCRectMake(7, 0.5, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 165)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1530",
      z = 0,
      parent = "btn_soldout",
      text = T("\231\161\174\232\174\164\229\135\186\229\148\174"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.5, 22.75)
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
      name = "ImageView_1809",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 127.5)
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
      parent = "bg_sold_price",
      res = "UI/alpha/1080P/package/seg_normal.png",
      name = "deco_mid",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.25, 47)
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
      name = "Label_1011",
      z = 0,
      parent = "bg_sold_price",
      text = T("\229\135\186\229\148\174\229\141\149\228\187\183\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(54.25, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 184, 3),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_sold_money",
      z = 0,
      parent = "bg_sold_price",
      text = "12345",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(227.25, 23)
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
      parent = "bg_sold_price",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "icon_money1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.25, 24)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(47.5, 47.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_sub",
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
      scaleSize = CCSizeMake(47.5, 47.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_max",
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
      scaleSize = CCSizeMake(47.5, 47.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_add",
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
      name = "label_amount",
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
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_number",
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
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1017",
      z = 0,
      parent = "bg_preview",
      text = T("\232\142\183\229\190\151\233\135\145\233\146\177\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(54.75, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 184, 3),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_preview_money",
      z = 0,
      parent = "bg_preview",
      text = "12345789",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(227.25, 23)
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
      parent = "bg_preview",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "icon_money2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.25, 24)
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
      parent = "bg_preview",
      res = "UI/alpha/1080P/package/seg_normal.png",
      name = "deco_mid",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.25, 47)
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
      parent = "btn_sub",
      text = "-",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.75, 25.25)
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
      parent = "btn_max",
      text = T("\230\156\128\229\164\167"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.25, 24.75)
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
      parent = "btn_add",
      text = "+",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.75, 25.25)
    }
  }
}

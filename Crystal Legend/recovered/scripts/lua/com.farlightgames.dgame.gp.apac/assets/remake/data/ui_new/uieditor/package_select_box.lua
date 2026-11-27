ed.uieditor = ed.uieditor or {}
ed.uieditor.package_select_box = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(0.5, 0.5)
    },
    t = "Layer",
    base = {
      name = "layer_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(236, 450)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_detail",
      z = 0,
      parent = "layer_detail",
      res = "UI/alpha/1080P/package/bg_normal.png",
      capInsets = CCRectMake(99.5, 0, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-191.5, -6.5)
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
      position = ccp(119.5, 372.5)
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
      position = ccp(118.5, 30)
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
      parent = "layer_detail",
      name = "layer_main",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-479.5, -238.5)
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
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118, 307)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(227, 163.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_main_attr",
      z = 0,
      parent = "bg_detail",
      res = "UI/alpha/1080P/package/bg_attr.png",
      capInsets = CCRectMake(3.5, 0.5, 1.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(119, 307)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.2, h = 29.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_detail",
      res = "UI/alpha/1080P/common/GuildHero_property.png",
      name = "bg_source",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(213, 436)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(380, 470.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "main_frame",
      z = 2,
      parent = "layer_main",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_big.png",
      capInsets = CCRectMake(250, 103.5, 0.5, 107)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(602.5, 238)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(245, 470.5)
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
      position = ccp(119.5, 229.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(378.5, 465.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_main",
      z = 0,
      parent = "layer_main",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_1.png",
      capInsets = CCRectMake(40, 40, 0.5, 200)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(602.5, 238)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(217.5, 126.5)
    },
    t = "Layer",
    base = {
      parent = "bg_main_attr",
      name = "layer_attr",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5, 29.5)
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
      parent = "main_frame",
      name = "layer_top",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(134, 445.25)
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
      name = "label_desc",
      z = 0,
      parent = "bg_main_attr",
      text = T("\231\153\189\233\170\168\228\185\139\228\184\173\231\154\132\229\136\155\233\128\129\233\152\181\229\156\168\229\143\172\229\148\164"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(9.5, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(368, 59)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_btn",
      z = 0,
      parent = "main_frame",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_3.png",
      capInsets = CCRectMake(8.5, 0, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(190, 36.75)
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
      z = 1,
      parent = "bg_main_attr",
      text = T("\233\129\147\229\133\183\229\144\141\231\167\176\229\177\133\228\184\173\229\142\159\229\136\153"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 206.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(353, 358)
    },
    t = "Layer",
    base = {
      parent = "main_frame",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13.5, 75.25)
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
      parent = "bg_main_attr",
      text = T("\230\140\129\230\156\137:"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(116, 178.5)
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
      parent = "bg_main_attr",
      text = "1234",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(117.5, 178.5)
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
      parent = "layer_top",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_778",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_top",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_779",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-29, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.78, x = 0.78},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72.93, h = 72.93},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_main_attr",
      res = "UI/alpha/1080P/package/1st.jpg",
      name = "icon_item",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 263.5)
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
      name = "label_title",
      z = 0,
      parent = "layer_top",
      text = T("\232\175\183\233\128\137\230\139\169\233\129\147\229\133\183"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.5, 2)
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
      parent = "bg_main_attr",
      res = "UI/alpha/1080P/package/bg_compose.png",
      name = "bg_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 206)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 92.5, h = 39},
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
      name = "btn_cancle",
      z = 0,
      parent = "bg_btn",
      text = T("\229\143\150 \230\182\136"),
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 92.5, h = 39},
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
      name = "btn_get",
      z = 0,
      parent = "bg_btn",
      text = T("\232\142\183 \229\190\151"),
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(249, 29.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.package_quick_compose = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(868.5, 478.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(40, 40, 0.5, 200),
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478.5, 247.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(871, 484)
    },
    t = "Scale9Sprite",
    base = {
      name = "main_frame",
      z = 2,
      parent = "bg",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_big.png",
      capInsets = CCRectMake(250, 103.5, 0.5, 107)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(434.25, 239.25)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/comm_line_b_star.png",
      name = "deco",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(434.25, 85.25)
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
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(897, 470.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(150, 45),
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
      normal = "UI/alpha/1080P/package/btn_package2.png",
      capInsets = CCRectMake(20, 7.5, 0.5, 0.5),
      name = "btn_compose",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(735.25, 48.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 12.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "left_deco",
      z = 0,
      parent = "deco",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      capInsets = CCRectMake(20, 0, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-173.25, 1.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 12.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "right_deco",
      z = 0,
      parent = "deco",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      capInsets = CCRectMake(20, 0, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(186.75, 1.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(770.5, 300)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(47.25, 93.25)
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
      parent = "bg",
      name = "layer_info",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45.75, 46.25)
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
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "icon_back",
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
      name = "Label_1531",
      z = 0,
      parent = "btn_compose",
      text = T("\231\161\174\232\174\164\229\144\136\230\136\144"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75, 22.5)
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
      parent = "bg",
      name = "layer_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(434.25, 239.25)
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
      name = "label_number1",
      z = 0,
      parent = "layer_info",
      text = T("\229\183\178\233\128\137\230\139\169\239\188\1542"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(70.5, 369)
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
      name = "label_all_selected",
      z = 0,
      parent = "layer_info",
      text = T("\229\133\168\233\128\137/\229\143\150\230\182\136"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(705, 368.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_info",
      res = "UI/alpha/1080P/package/bg_all_select.png",
      name = "bg_all_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(725, 368.5)
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
      name = "label_price",
      z = 0,
      parent = "layer_info",
      text = T("\229\144\136\230\136\144\232\138\177\232\180\185\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39, 10)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 117, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_money",
      z = 0,
      parent = "layer_info",
      text = "1234567",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(72, 10)
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
      parent = "layer_info",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "icon_money",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150.5, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.30000007, x = 1.30000007},
      flip = "",
      opacity = 255,
      fix_wh = {w = 267.150014385, h = 41.60000224},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_title",
      res = "UI/alpha/1080P/package/bg_compose.png",
      name = "bg_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(0, 235)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(191, 190, 184),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_number2",
      z = 0,
      parent = "layer_info",
      text = "/50",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(71.5, 369)
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
      name = "label_title",
      z = 0,
      parent = "layer_title",
      text = T("\232\175\183\233\128\137\230\139\169\229\143\175\229\144\136\230\136\144\232\163\133\229\164\135"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 216)
    }
  },
  {
    config = {
      rotation = 180,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_886",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-267, 214.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_887",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(267, 214.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42.799997432, h = 37.599997744},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_all_selected",
      res = "UI/alpha/1080P/package/selected.png",
      name = "ImageView_892",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 20.75)
    }
  }
}

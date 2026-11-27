ed.uieditor = ed.uieditor or {}
ed.uieditor.playerFunctionOpen = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(530, 250)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 10),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(480.5, 389)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(552, 220.5)
    },
    t = "Layer",
    base = {name = "panel_info", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(217.5, 153)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 263.25002106, h = 78.00000624},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/main/unlock/lvup.png",
      name = "img_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 398.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(475, 35)
    },
    t = "Scale9Sprite",
    base = {
      name = "item_1",
      z = 0,
      parent = "panel_info",
      res = "UI/alpha/1080P/main/unlock/menuitem_2.png",
      capInsets = CCRectMake(50, 3, 0.5, 4)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(262, 158.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(475, 35)
    },
    t = "Scale9Sprite",
    base = {
      name = "item_2",
      z = 0,
      parent = "panel_info",
      res = "UI/alpha/1080P/main/unlock/menuitem_1.png",
      capInsets = CCRectMake(50, 3, 0.5, 4)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(262, 124)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(552, 117.5)
    },
    t = "Layer",
    base = {
      name = "panel_function",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(219, 206.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(475, 35)
    },
    t = "Scale9Sprite",
    base = {
      name = "item_3",
      z = 0,
      parent = "panel_info",
      res = "UI/alpha/1080P/main/unlock/menuitem_2.png",
      capInsets = CCRectMake(50, 3, 0.5, 4)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(262, 89)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "pro_name_1",
      z = 0,
      parent = "item_1",
      text = T("\230\136\152\233\152\159\231\173\137\231\186\167"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 2,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "pro_value_1",
      z = 0,
      parent = "item_1",
      text = "12",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(475, 35)
    },
    t = "Scale9Sprite",
    base = {
      name = "item_4",
      z = 0,
      parent = "panel_info",
      res = "UI/alpha/1080P/main/unlock/menuitem_1.png",
      capInsets = CCRectMake(50, 3, 0.5, 4)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(262, 54.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.49999625, h = 19.1999968},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_1",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "img_arrow_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 2,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "pro_value_new_1",
      z = 0,
      parent = "item_1",
      text = "123",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(397.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "pro_name_2",
      z = 0,
      parent = "item_2",
      text = T("\229\189\147\229\137\141\228\189\147\229\138\155"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 2,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "pro_value_2",
      z = 0,
      parent = "item_2",
      text = "12",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.49999625, h = 19.1999968},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_2",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "img_arrow_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 2,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "pro_value_new_2",
      z = 0,
      parent = "item_2",
      text = "123",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(397.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "pro_name_3",
      z = 0,
      parent = "item_3",
      text = T("\228\189\147\229\138\155\228\184\138\233\153\144"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 2,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "pro_value_3",
      z = 0,
      parent = "item_3",
      text = "12",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.49999625, h = 19.1999968},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_3",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "img_arrow_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 2,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "pro_value_new_3",
      z = 0,
      parent = "item_3",
      text = "123",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(397.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 591, h = 151.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_function",
      res = "UI/alpha/1080P/main/unlock/lvup_title_bg.png",
      name = "bg_function",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(276, 80.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "pro_name_4",
      z = 0,
      parent = "item_4",
      text = T("\232\139\177\233\155\132\231\173\137\231\186\167\228\184\138\233\153\144"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 2,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "pro_value_4",
      z = 0,
      parent = "item_4",
      text = "12",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.799996952, h = 51.199996928},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_function",
      res = "UI/alpha/1080P/main/unlock/close.png",
      name = "btn_closelabel",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(517.5, 102.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.49999625, h = 19.1999968},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item_4",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "img_arrow_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 2,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "pro_value_new_4",
      z = 0,
      parent = "item_4",
      text = "123",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(397.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      name = "bg_buildling",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 575.5, h = 274},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_buildling",
      res = "UI/alpha/1080P/main/unlock/unlockbuilding_bg.png",
      name = "fca_build",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(493, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.4000001, x = 1.4000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 280.00002, h = 280.00002},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_buildling",
      res = "UI/alpha/1080P/main/unlock/chapter.png",
      name = "icon",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(493, 265)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63.5, h = 64},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_buildling",
      res = "UI/alpha/1080P/main/unlock/close.png",
      name = "btn_closemap",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(680.5, 352.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 535.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_buildling",
      res = "UI/alpha/1080P/main/unlock/lvup_bg.png",
      name = "icon_tips_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(493, 189)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueExitBattleTipsWindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 215)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(17.5, 17.5, 17.5, 17.5),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 292.5)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "image_title_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124, 191)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "image_title_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(276, 191)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 187),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\230\143\144\231\164\186"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200, 193)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(335, 50)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(32, 111)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/com_line_center.png",
      name = "image_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(201, 64.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 99.599994024, h = 40.399997576},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_cancel",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85, 31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 99.599994024, h = 40.399997576},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_confirm",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(315.5, 31)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(335, 24.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_ext_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(32, 80.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(179.5, 1.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_line_left",
      z = 0,
      parent = "image_line",
      res = "UI/alpha/1080P/common/com_line_left.png",
      capInsets = CCRectMake(50, 0.5, 50, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-89.25, 3.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(179.5, 1.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_line_right",
      z = 0,
      parent = "image_line",
      res = "UI/alpha/1080P/common/com_line_left.png",
      capInsets = CCRectMake(50, 0.5, 50, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.75, 3.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cancel",
      z = 0,
      parent = "btn_cancel",
      text = T("\229\143\150\230\182\136"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_confirm",
      z = 0,
      parent = "btn_confirm",
      text = T("\231\161\174\232\174\164"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 25.75)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloDataPop = {
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
      name = "layer_player",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(146, 315)
    },
    t = "Scale9Sprite",
    base = {
      name = "player_type",
      z = 0,
      parent = "layer_player",
      res = "UI/alpha/1080P/chesscard/data/data_bg.png",
      capInsets = CCRectMake(10, 10, 4.5, 4.5)
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(4, 441)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(139, 146)
    },
    t = "Layer",
    base = {
      parent = "player_type",
      name = "layer_player_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(3, 6)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(222, 192, 170),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "player_label_type_title",
      z = 0,
      parent = "player_type",
      text = T("\231\187\159 \232\174\161"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 301.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_type",
      res = "UI/alpha/1080P/chesscard/data/data_2.png",
      name = "player_damage",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74, 270.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105.5, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_type",
      res = "UI/alpha/1080P/chesscard/tips/line.png",
      name = "ImageView_1836",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 289)
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
    base = {name = "layer_oppo", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(222, 192, 170),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "player_label_detail_title",
      z = 0,
      parent = "player_type",
      text = T("\228\188\164 \229\174\179"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 170)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.5, h = 17.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_damage",
      res = "UI/alpha/1080P/chesscard/8.png",
      name = "player_icon_damage",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.25, 14)
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
      name = "player_label_damage",
      z = 0,
      parent = "player_damage",
      text = "1488",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(32.25, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105.5, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_type",
      res = "UI/alpha/1080P/chesscard/tips/line.png",
      name = "ImageView_1836_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 157)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.5, h = 88},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_type",
      res = "UI/alpha/1080P/chesscard/tips/bg_2.png",
      name = "ImageView_1841",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(157.5, 161.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(146.5, 315)
    },
    t = "Scale9Sprite",
    base = {
      name = "oppo_type",
      z = 0,
      parent = "layer_oppo",
      res = "UI/alpha/1080P/chesscard/data/data_bg.png",
      capInsets = CCRectMake(10, 10, 4.5, 4.5)
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(809.5, 441)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(222, 192, 170),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "oppo_label_detail_title",
      z = 0,
      parent = "oppo_type",
      text = T("\228\188\164 \229\174\179"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73.5, 170)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -8, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_1841",
      res = "UI/alpha/1080P/chesscard/tips/arrow_1.png",
      name = "ImageView_1854",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.25, 44)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(139, 146)
    },
    t = "Layer",
    base = {
      parent = "oppo_type",
      name = "layer_oppo_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4, 6)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(222, 192, 170),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "oppo_label_type_title",
      z = 0,
      parent = "oppo_type",
      text = T("\231\187\159 \232\174\161"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73.5, 301.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "oppo_type",
      res = "UI/alpha/1080P/chesscard/data/data_2.png",
      name = "oppo_damage",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74, 270.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105.5, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "oppo_type",
      res = "UI/alpha/1080P/chesscard/tips/line.png",
      name = "ImageView_1836_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 289)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105.5, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "oppo_type",
      res = "UI/alpha/1080P/chesscard/tips/line.png",
      name = "ImageView_1836_Copy2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 157)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -24.5, h = 88},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "oppo_type",
      res = "UI/alpha/1080P/chesscard/tips/bg_2.png",
      name = "ImageView_1841_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-11, 161.5)
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
      name = "oppo_label_damage",
      z = 0,
      parent = "oppo_damage",
      text = "1488",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(32.25, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.5, h = 17.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "oppo_damage",
      res = "UI/alpha/1080P/chesscard/8.png",
      name = "oppo_icon_damage",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.25, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -8, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_1841_Copy0",
      res = "UI/alpha/1080P/chesscard/tips/arrow_1.png",
      name = "ImageView_18541",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.25, 44)
    }
  }
}

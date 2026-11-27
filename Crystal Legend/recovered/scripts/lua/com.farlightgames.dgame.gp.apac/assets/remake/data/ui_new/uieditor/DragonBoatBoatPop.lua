ed.uieditor = ed.uieditor or {}
ed.uieditor.DragonBoatBoatPop = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 824, h = 660.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_boat/db_boat_first.png",
      name = "boat_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(465, 295)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 59, h = 59},
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
      normal = "UI/alpha/1080P/dragonboat/db_pass/db_button_back.png",
      name = "btn_back",
      z = 0,
      text = "",
      press = "UI/alpha/1080P/dragonboat/db_pass/db_button_back.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(752.5, 425.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 79},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_boat/db_direction_arrow.png",
      name = "arrow_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(158.5, 273.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -81, h = 79},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_boat/db_direction_arrow.png",
      name = "arrow_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(809.5, 273.5)
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
      parent = "boat_bg",
      name = "boat_name_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(429, 213.25)
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
      name = "label_speed",
      z = 0,
      parent = "boat_bg",
      text = T("\232\136\170\233\128\159:6\229\176\186/\230\151\182"),
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(429, 163.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 189, h = 68.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "boat_bg",
      res = "UI/alpha/1080P/dragonboat/db_boat/db_boat_button_base.png",
      name = "btn_update_boat",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(429, 100.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 79},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "boat_bg",
      res = "UI/alpha/1080P/dragonboat/db_boat/db_direction_arrow.png",
      name = "update_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(456.5, 161.25)
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
      parent = "boat_bg",
      name = "zongzi_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(254.5, 266.75)
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
      parent = "boat_bg",
      name = "levelup_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(429, 330.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(94.5, 68)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_dialog",
      z = 0,
      parent = "boat_bg",
      res = "UI/alpha/1080P/dragonboat/db_boat/db_boat_dialogue.png",
      capInsets = CCRectMake(55, 35, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(245.5, 372.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 207, 120),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_owned",
      z = 0,
      parent = "boat_bg",
      text = T("\229\183\178\232\167\163\233\148\129"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(429, 80.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 69, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "boat_bg",
      res = "UI/alpha/1080P/dragonboat/db_boat/db_dividing_line.png",
      name = "line_left",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(371.5, 78.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 69, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "boat_bg",
      res = "UI/alpha/1080P/dragonboat/db_boat/db_dividing_line.png",
      name = "line_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(486.5, 78.75)
    }
  }
}

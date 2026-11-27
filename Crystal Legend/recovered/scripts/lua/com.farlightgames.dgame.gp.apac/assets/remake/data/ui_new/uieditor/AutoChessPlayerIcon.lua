ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessPlayerIcon = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chess/battle/chess_playername.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89, 28)
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
      z = 6,
      parent = "bg",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\229\144\141\229\173\151"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(112.5, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.8, h = 24.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/loading/signal.png",
      name = "img_error",
      z = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149.5, 26.5)
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
      name = "label_level",
      z = 20,
      parent = "bg",
      text = "80",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100, 11.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/player_hp_bg.png",
      name = "blood_bar_bg",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(144, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 70.125, h = 70.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/mainhead/main_head_frame_cm.png",
      name = "head",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150, 28)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(144, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_bar_red",
      z = 10,
      parent = "blood_bar_bg",
      res = "UI/alpha/1080P/chess/battle/player_hp_2.png",
      capInsets = CCRectMake(6, 5, 132, 2)
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(143.5, 6)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(144, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_bar_green",
      z = 10,
      parent = "blood_bar_bg",
      res = "UI/alpha/1080P/chess/battle/player_hp_1.png",
      capInsets = CCRectMake(6, 5, 132, 2)
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(143.5, 6)
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
      name = "label_blood",
      z = 11,
      parent = "blood_bar_bg",
      text = "1000",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.5, 6)
    }
  }
}

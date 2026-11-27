ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloPlayerItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(48, 46)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "name",
      z = 3,
      parent = "bg",
      text = T("\231\142\169\229\174\182\229\144\141"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31, -6)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/player_bg1.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.5, h = 24.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/battle/win.png",
      name = "ImageView_883",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, -14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 10.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "icon",
      res = "UI/alpha/1080P/chesscard/new_hp_1.png",
      name = "bg_bar",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 4.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.5, h = 29},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/battle/hp.png",
      name = "ImageView_884",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 11.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "icon",
      res = "UI/alpha/1080P/chesscard/bg_head_self.png",
      name = "ImageView_12505",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/chesscard/new_hp_2.png",
      name = "bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(1, 5.25)
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
      name = "label_hp",
      z = 8,
      parent = "bg_bar",
      text = "30",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 5.25)
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
      name = "Label_12506",
      z = 0,
      parent = "ImageView_12505",
      text = T("\232\135\170\229\183\177"),
      size = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22.5, 5.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 233),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_885",
      z = 0,
      parent = "ImageView_884",
      text = "-10",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.25, 13)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "Label_3323",
      z = 0,
      parent = "bg",
      text = "Text Label",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, -7.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(28, 14)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_3284",
      z = 9,
      parent = "icon",
      res = "UI/alpha/1080P/chesscard/atk_bg.png",
      capInsets = CCRectMake(12.5, 5, 1.5, 4)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(8.5, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 10.45, h = 12.1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_3284",
      res = "UI/alpha/1080P/chesscard/atk_icon.png",
      name = "sward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(5.5, 7)
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
      name = "damage",
      z = 0,
      parent = "ImageView_3284",
      text = "18",
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16, 7)
    }
  }
}

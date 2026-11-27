ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaSummaryWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(700, 391)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 50, 351),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg_history",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(128, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 629, h = 302},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_history",
      res = "UI/alpha/1080P/toparena/toparena_summary_title_bg.png",
      name = "ImageView_2687",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 448)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(675, 312)
    },
    t = "Layer",
    base = {
      parent = "bg_history",
      name = "Panel_2809",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_history",
      res = "UI/alpha/1080P/toparena/toparena_summary_bg.png",
      name = "ImageView_2810",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 352.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 153.6, h = 45.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_history",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "ImageView_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 50)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 244, 211),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2811",
      z = 0,
      parent = "ImageView_2810",
      text = T("S1\232\181\155\229\173\163\229\183\178\231\187\147\230\157\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(112, 13)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 230, 154),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_close",
      z = 0,
      parent = "ImageView_close",
      text = T("\231\161\174\229\174\154(6s)"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 28.25)
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
      parent = "ImageView_2687",
      text = T("\232\181\155\229\173\163\230\177\135\230\128\187"),
      size = 34
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(314.5, 90.5)
    }
  }
}

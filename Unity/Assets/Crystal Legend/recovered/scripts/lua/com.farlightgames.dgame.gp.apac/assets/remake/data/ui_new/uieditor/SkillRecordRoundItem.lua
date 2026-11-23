ed.uieditor = ed.uieditor or {}
ed.uieditor.SkillRecordRoundItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/line.png",
      name = "ImageView_10917",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-90, 0)
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
      name = "label_round",
      z = 0,
      parent = "bg",
      text = T("\231\172\172\227\128\1441\227\128\145\229\155\158\229\144\136"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
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
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/line.png",
      name = "ImageView_10917_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(375, 26.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "stage_prepare",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/log_title_bg.png",
      capInsets = CCRectMake(7.5, 7.5, 11, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -27)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(375, 26.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "stage_battle",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/log/log_title_bg.png",
      capInsets = CCRectMake(7.5, 7.5, 11, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -137.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(70, 51, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_10925",
      z = 0,
      parent = "stage_prepare",
      text = T("\229\135\134\229\164\135\233\152\182\230\174\181"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(70, 51, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_109251",
      z = 0,
      parent = "stage_battle",
      text = T("\230\136\152\230\150\151\233\152\182\230\174\181"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 13.25)
    }
  }
}

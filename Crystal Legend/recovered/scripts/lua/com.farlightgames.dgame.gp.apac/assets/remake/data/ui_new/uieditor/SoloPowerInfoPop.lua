ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloPowerInfoPop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(209, 174.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(90, 80, 8, 5),
      res = "UI/alpha/1080P/chesscard/tips/fream.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(0, 0)
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
      name = "label_power_name",
      z = 0,
      parent = "bg",
      text = T("\229\174\157\231\137\169\229\144\141\229\173\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(83, 130)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(48, 48, 47),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_power_desc",
      z = 0,
      parent = "bg",
      text = T("\229\174\157\231\137\169\230\143\143\232\191\176"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(23, 84)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 155, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/line.png",
      name = "line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109, 54.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76.7999872, h = 34.7999942},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/match_button_1.png",
      name = "btn_use_power",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 31)
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
      name = "label_use",
      z = 0,
      parent = "btn_use_power",
      text = T("\228\189\191\231\148\168"),
      size = 28
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42.799997432, h = 42.799997432},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/treasure_1.png",
      name = "ImageView_601",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 130)
    }
  }
}

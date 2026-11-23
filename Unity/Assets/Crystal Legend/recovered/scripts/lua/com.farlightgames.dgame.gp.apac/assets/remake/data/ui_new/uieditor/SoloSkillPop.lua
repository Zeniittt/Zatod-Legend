ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloSkillPop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(187.5, 188.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(90, 80, 8, 5),
      res = "UI/alpha/1080P/chesscard/tips/fream.png",
      name = "bg",
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
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.1, h = 44.1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/hero/bg_icon_ult.png",
      name = "ImageView_584",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 144.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.599997504, h = 41.599997504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_584",
      res = "UI/alpha/1080P/chesscard/hero/bg_6_mask.png",
      name = "ImageView_585",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60.5, h = 17},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_584",
      res = "UI/alpha/1080P/chesscard/hero/tip_skill_ult.png",
      name = "ImageView_586",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 2)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_588",
      z = 0,
      parent = "bg",
      text = "Text Label",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(80, 145)
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
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_587",
      z = 0,
      parent = "ImageView_586",
      text = T("\229\164\167\230\139\155"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.25, 8.5)
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
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_589",
      z = 0,
      parent = "bg",
      text = "Text Label",
      size = 10
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18.5, 99.5)
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
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/tips/line.png",
      name = "ImageView_2803",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94, 34.5)
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
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2804",
      z = 0,
      parent = "bg",
      text = "123",
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18.5, 23)
    }
  }
}

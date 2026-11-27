ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloFactionPop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(236, 140.5)
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
      position = ccp(76.5, 96)
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
      name = "Label_589",
      z = 0,
      parent = "bg",
      text = T("\230\181\129\230\180\190\230\152\159\231\186\167\229\138\160\230\136\144:"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.2, h = 37.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/tagicon2.png",
      name = "ImageView_1807",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 96)
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
      name = "Label_589_Copy0",
      z = 0,
      parent = "bg",
      text = T("\230\143\144\229\141\13510/20/30/60\231\130\185\230\148\187\233\128\159"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20, 28)
    }
  }
}

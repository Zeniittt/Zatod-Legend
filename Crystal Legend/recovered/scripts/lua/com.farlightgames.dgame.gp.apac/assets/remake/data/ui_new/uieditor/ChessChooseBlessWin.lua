ed.uieditor = ed.uieditor or {}
ed.uieditor.ChessChooseBlessWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 119, h = 119},
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
      normal = "UI/alpha/1080P/chess/battle/chess_shop_refresh.png",
      name = "btn_refresh",
      z = 5,
      text = "",
      press = "UI/alpha/1080P/chess/battle/chess_shop_refresh.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(890, 288.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(579.5, 311)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(370, 138)
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
    base = {name = "bless2", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(613, 292)
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
    base = {name = "bless1", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(463, 292)
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
    base = {name = "bless3", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(763, 291.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.399998656, h = 22.399998656},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_refresh",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "img_cost_gold",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 73.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 15),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cost_num",
      z = 10,
      parent = "btn_refresh",
      text = "20",
      size = 25
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(64.5, 73)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 234, 197),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_refresh_title",
      z = 10,
      parent = "btn_refresh",
      text = T("\229\136\183\230\150\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60, 49.5)
    }
  }
}

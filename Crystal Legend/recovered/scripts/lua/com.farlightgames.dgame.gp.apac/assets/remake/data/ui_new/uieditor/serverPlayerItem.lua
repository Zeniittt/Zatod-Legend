ed.uieditor = ed.uieditor or {}
ed.uieditor.serverPlayerItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(171.5, 138.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(14, 14, 14, 14),
      res = "installer/login/serverlist_bg1.png",
      name = "bg",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(180.27, 32.19)
    },
    t = "Scale9Sprite",
    base = {
      name = "serverNameBg",
      z = 2,
      parent = "bg",
      res = "installer/login/Select_bg.png",
      capInsets = CCRectMake(26.5, 14.5, 26.5, 14.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84, 121.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 128),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "serverID",
      z = 2,
      parent = "bg",
      text = T("2621\229\140\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.5, 122.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 128),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "serverName",
      z = 2,
      parent = "bg",
      text = T("\230\179\162\229\138\168\232\131\189\233\135\143"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119, 122)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(187.5, 99.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "headFramePanel",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-8, 7.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "headFramePanel",
      res = "installer/login/lv.png",
      name = "levelBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99, 48)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "headFramePanel",
      res = "installer/login/server_name.png",
      name = "playerNameBg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93.5, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(40, 40)
    },
    t = "Layer",
    base = {
      parent = "headFramePanel",
      name = "headFrameBg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(42.5, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "playerName",
      z = 0,
      parent = "playerNameBg",
      text = T("\230\174\139\229\191\141\231\154\132\229\176\143\229\164\156\230\129\182\233\173\148"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 15)
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
      name = "playerLevel",
      z = 0,
      parent = "levelBg",
      text = "100",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(26, 9.25)
    }
  }
}

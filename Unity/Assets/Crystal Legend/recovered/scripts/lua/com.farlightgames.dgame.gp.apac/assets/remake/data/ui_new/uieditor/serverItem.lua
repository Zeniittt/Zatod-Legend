ed.uieditor = ed.uieditor or {}
ed.uieditor.serverItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(286, 64)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(13, 13, 13, 13),
      res = "installer/login/serverlist_bg1.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "installer/login/free.png",
      name = "serverState",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16, 32)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(219.5, 25.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "serverInfo",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(27.5, 30.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 201.5, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "installer/login/server_bg_2.png",
      name = "openTimeBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 215, 32),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "serverID",
      z = 0,
      parent = "serverInfo",
      text = T("2641\229\140\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(1.5, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 215, 32),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "serverName",
      z = 0,
      parent = "serverInfo",
      text = T("\229\136\155\228\184\150\228\185\139\229\188\147"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(75, 13)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 215, 32),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "serverStateLabel",
      z = 0,
      parent = "serverInfo",
      text = T("\230\150\176\229\140\186"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(238.5, 12.5)
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
      name = "date",
      z = 0,
      parent = "openTimeBg",
      text = T("3\230\156\1369\230\151\165"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20.75, 11.25)
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
      name = "time",
      z = 0,
      parent = "openTimeBg",
      text = T("08:30\229\188\128\229\144\175"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(87.25, 11.25)
    }
  }
}

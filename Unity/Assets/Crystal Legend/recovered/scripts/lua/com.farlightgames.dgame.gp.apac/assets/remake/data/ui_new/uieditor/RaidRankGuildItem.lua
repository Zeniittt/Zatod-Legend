ed.uieditor = ed.uieditor or {}
ed.uieditor.RaidRankGuildItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 130)
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
      fix_scale = {y = 1, x = 1.4000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 571.2000408, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/raid/bottomstripe.png",
      name = "bg_type",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290, 78.5)
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
      name = "type",
      z = 0,
      parent = "bg",
      text = T("\230\156\128\229\191\171\233\128\154\229\133\179\229\133\172\228\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(289.5, 78.5)
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
    base = {
      parent = "bg",
      name = "layer_main",
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
      color = ccc3(207, 170, 95),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_none",
      z = 0,
      parent = "bg",
      text = T("\230\154\130\230\151\182\230\178\161\230\156\137\229\133\172\228\188\154\233\128\154\232\191\135\230\173\164\229\133\179\229\141\161"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290, 40)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 30)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_title",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/raid/time_limited .png",
      capInsets = CCRectMake(5, 5, 28, 6)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290, 110)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_main",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "avatar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 31.5)
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
      name = "name",
      z = 0,
      parent = "layer_main",
      text = T("\229\136\176\232\190\190"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(90.5, 45)
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
      name = "id",
      z = 0,
      parent = "layer_main",
      text = "ID:",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(90.5, 17.5)
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
      name = "time",
      z = 0,
      parent = "layer_main",
      text = T("\233\128\154\229\133\179\232\128\151\230\151\182"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(378.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 1,
      parent = "bg_title",
      text = "title",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(125, 15)
    }
  }
}

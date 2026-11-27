ed.uieditor = ed.uieditor or {}
ed.uieditor.login = {
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(191, 57),
      flip = "",
      labelConfig = {
        color = ccc3(251, 206, 16)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "installer/login/button_com_mini.png",
      name = "entergame",
      z = 0,
      capInsets = CCRectMake(33.5, 13, 33.5, 13),
      text = T("\232\191\155\229\133\165\230\184\184\230\136\143"),
      press = "installer/login/button_com_mini.png",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 91)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(364, 56.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(17.5, 17.5, 17.5, 17.5),
      res = "installer/login/input_bg.png",
      name = "serverNameBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 176.5)
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
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 10,
      text = T("\228\191\174\229\164\141\230\184\184\230\136\143"),
      name = "fixLabel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(60, 29)
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
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 10,
      text = T("net status"),
      name = "netStatus",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(120, 29)
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
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 10,
      text = T("\231\137\136\230\156\172\229\143\183\239\188\1545. 1. 349. 193256"),
      name = "version",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(804.5, 14.5)
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
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 10,
      text = T("-dev-"),
      name = "buildType",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(804.5, 29)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 5,
      text = "",
      name = "bdversion",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(718, 8.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2079351, x = 2.14387465},
      flip = "",
      opacity = 255,
      fix_wh = {w = 575.32906095, h = 68.329517685},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "serverNameBg",
      res = "installer/login/Select_bg.png",
      name = "selectserverbg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 1)
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
      name = "selectserver",
      z = 0,
      parent = "serverNameBg",
      text = T("\231\130\185\229\135\187\230\141\162\229\140\186"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(302.25, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(251, 206, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "servername",
      z = 0,
      parent = "serverNameBg",
      text = "",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(182, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.5, h = 18.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "serverNameBg",
      res = "installer/login/free.png",
      name = "serverState",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.75, 34.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "serverID",
      z = 0,
      parent = "serverNameBg",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(34.25, 28.25)
    }
  }
}

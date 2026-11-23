ed.uieditor = ed.uieditor or {}
ed.uieditor.serverList = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(188.5, 446)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(13, 13, 13, 13),
      res = "installer/login/serverlist_bg.png",
      name = "allServerBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(167.5, 269)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 381)
    },
    t = "Layer",
    base = {
      parent = "allServerBg",
      name = "allServerList",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(19.25, 14)
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
      name = "allServerLabel",
      z = 0,
      parent = "allServerBg",
      text = T("\230\137\128\230\156\137\230\156\141\229\138\161\229\153\168"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.25, 415)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(618.5, 60)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(13, 13, 13, 13),
      res = "installer/login/serverlist_bg.png",
      name = "lastServerBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(577.5, 461.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(618.5, 385)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(13, 13, 13, 13),
      res = "installer/login/serverlist_bg.png",
      name = "serverListBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(577.5, 238.5)
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
      name = "lastLoginLabel",
      z = 0,
      parent = "lastServerBg",
      text = T("\228\184\138\230\172\161\231\153\187\229\189\149\230\156\141\229\138\161\229\153\168"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.75, 31)
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
      parent = "lastServerBg",
      text = T("1\229\140\186"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(259.25, 30)
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
      parent = "lastServerBg",
      res = "installer/login/free.png",
      name = "serverStateImage",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(243.75, 30)
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
      parent = "lastServerBg",
      text = T("\228\188\151\231\165\158\228\185\139\231\142\139"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(393.75, 30.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 63, 63),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "serverStateLabel",
      z = 0,
      parent = "lastServerBg",
      text = T("\231\136\134\230\187\161"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(556.75, 30.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(589, 320)
    },
    t = "Layer",
    base = {
      parent = "serverListBg",
      name = "serverList",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(15.75, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      parent = "serverListBg",
      name = "maskPanel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-267.75, -45.5)
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
      name = "serverNum",
      z = 0,
      parent = "serverListBg",
      text = T("\230\156\172\232\180\166\229\143\183\230\137\128\230\156\137\230\136\152\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(34.25, 360)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 200)
    },
    t = "Layer",
    base = {
      parent = "serverListBg",
      name = "filterPanel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(394.75, 179)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(182, 30)
    },
    t = "Scale9Sprite",
    base = {
      name = "filterNormalBg",
      z = 0,
      parent = "filterPanel",
      res = "installer/login/unselected.png",
      capInsets = CCRectMake(15, 0, 14, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100, 180.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(182, 30)
    },
    t = "Scale9Sprite",
    base = {
      name = "filterSelectBg",
      z = 0,
      parent = "filterPanel",
      res = "installer/login/selected.png",
      capInsets = CCRectMake(15, 0, 14, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100, 180.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "filterPanel",
      res = "installer/login/down.png",
      name = "downArrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172.5, 180)
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
      name = "filterDesTxt",
      z = 0,
      parent = "filterPanel",
      text = T("\229\176\154\230\156\170\233\154\144\232\151\143\232\180\166\229\143\183"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.5, 181)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(180, 156)
    },
    t = "Scale9Sprite",
    base = {
      name = "filterContentBg",
      z = 0,
      parent = "filterPanel",
      res = "installer/login/com_new_3.png",
      capInsets = CCRectMake(15, 15, 23, 22)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.5, 85.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(176, 150)
    },
    t = "Layer",
    base = {
      parent = "filterContentBg",
      name = "filterListPanel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(2, 3)
    }
  }
}

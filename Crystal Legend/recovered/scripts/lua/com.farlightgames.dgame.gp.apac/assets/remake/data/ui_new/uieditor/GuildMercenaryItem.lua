ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMercenaryItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(560, 80)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(5, 5, 543, 77),
      res = "UI/alpha/1080P/crusade/bg_replay_item.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-2.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(280, 40)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 55, 50),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc2",
      z = 0,
      parent = "layer1",
      text = T("\229\133\172\228\188\154\229\134\133\229\133\182\228\187\150\231\142\169\229\174\182\229\143\175\228\187\165\230\148\175\228\187\152\233\135\145\229\184\129\233\155\135\228\189\163\228\189\160\231\154\132\228\189\163\229\133\181"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-196, -12)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 55, 50),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc1",
      z = 0,
      parent = "layer1",
      text = T("\228\189\163\229\133\181\229\143\175\228\187\165\230\140\137\230\151\182\229\143\150\229\190\151\233\135\145\229\184\129\230\148\182\229\133\165"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-196, 14)
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
      name = "layer2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(280, 40)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-236, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 92.5, h = 39},
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
      normal = "UI/alpha/1080P/package/btn_package2.png",
      name = "btn_return",
      z = 0,
      parent = "layer2",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(223.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "icon1",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "ImageView_12741",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "icon1",
      res = "UI/alpha/1080P/guild/mercenary_increase.png",
      name = "ImageView_12742",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer2",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-236, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(177, 255, 35),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_12743",
      z = 0,
      parent = "icon1",
      text = T("\230\180\190\229\135\186\228\189\163\229\133\181"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 55, 50),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "total",
      z = 0,
      parent = "layer2",
      text = T("\231\180\175\232\174\161\230\148\182\229\133\165\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-197, 14)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_return",
      z = 0,
      parent = "btn_return",
      text = T("\231\171\139\229\136\187\229\189\146\233\152\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 55, 50),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "time",
      z = 0,
      parent = "layer2",
      text = T("\229\174\136\232\144\165\230\151\182\233\151\180\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-197, -12)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 117, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "goldnum",
      z = 0,
      parent = "layer2",
      text = "12345678",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-90, 14)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "layer2",
      text = T("0\229\176\143\230\151\18220\229\136\134"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-116.5, -12)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer2",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "ImageView_12749",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-104.5, 14.5)
    }
  }
}

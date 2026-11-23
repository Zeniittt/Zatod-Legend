ed.uieditor = ed.uieditor or {}
ed.uieditor.authenticationConfirmPop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(290, 190)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(143, 90.5, 1, 1),
      res = "UI/alpha/1080P/common/global/bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_18820",
      z = 0,
      parent = "bg",
      text = T("\232\175\183\229\134\141\230\172\161\231\161\174\232\174\164\230\130\168\231\154\132\232\180\166\229\143\183\228\191\161\230\129\175"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145, 156.5)
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
      name = "server1",
      z = 0,
      parent = "bg",
      text = T("\230\156\141\229\138\161\229\153\168:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.5, 120)
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
      name = "server2",
      z = 0,
      parent = "bg",
      text = T("141\229\140\186 \230\181\183\229\134\155\228\184\138\229\176\134"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(262.5, 120)
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
      name = "userid2",
      z = 0,
      parent = "bg",
      text = "136549",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(262.5, 92)
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
      name = "userid1",
      z = 0,
      parent = "bg",
      text = "Userid:",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.5, 92)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(144, 42.38)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_confirm",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_big_common.png",
      capInsets = CCRectMake(95, 27.5, 2, 1.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(146.5, 43.5)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "name1",
      z = 0,
      parent = "bg",
      text = "Name:",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.5, 64)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "name2",
      z = 0,
      parent = "bg",
      text = "Soulhunter",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(262.5, 64)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 41.25},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(282.5, 185)
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
      name = "label_confirm",
      z = 0,
      parent = "btn_confirm",
      text = T("\231\161\174\232\174\164\230\151\160\232\175\175\239\188\1365\239\188\137"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 29.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_110",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueCharmShowWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 847, h = 355},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_charm_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(488.5, 267)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(121, 107, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_close_tips",
      z = 0,
      parent = "bg",
      text = T("\231\130\185\229\135\187\231\169\186\231\153\189\229\164\132\229\133\179\233\151\173"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(417.5, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 404, h = 175.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/rogue/charm/charm_empty.png",
      name = "img_empty",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(421.5, 189)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(0.5, 0.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_charm",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(423.5, 177.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "panel_charm",
      text = T("\230\138\164\231\172\166\231\154\174\232\162\139"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-275.5, 153)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(412, 290)
    },
    t = "Layer",
    base = {
      parent = "panel_charm",
      name = "panel_charm_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-317, -151.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 20)
    },
    t = "Layer",
    base = {
      parent = "panel_charm",
      name = "panel_weight",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-224.5, 139.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 106, h = 141.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_charm",
      res = "UI/alpha/1080P/rogue/charm/icon/charm_ap_1.png",
      name = "img_charm_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(222, 48)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(168, 105)
    },
    t = "Layer",
    base = {
      parent = "panel_charm",
      name = "panel_charm_des",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(137.5, -167)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 205, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_charm_weight",
      z = 0,
      parent = "panel_charm",
      text = T("\233\135\141\233\135\143\239\188\1543"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(220.5, -39)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.15, x = 1.15},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.25, h = 16.1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_charm",
      res = "UI/alpha/1080P/rogue/charm/charm_heart.png",
      name = "img_charm_heart_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(220.5, -10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.15, x = 1.15},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.25, h = 16.1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_charm",
      res = "UI/alpha/1080P/rogue/charm/charm_heart.png",
      name = "img_charm_heart_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(220.5, -10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.15, x = 1.15},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.25, h = 16.1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_charm",
      res = "UI/alpha/1080P/rogue/charm/charm_heart.png",
      name = "img_charm_heart_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(221, -10)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 236, 246),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_charm_name",
      z = 0,
      parent = "panel_charm",
      text = T("\231\186\160\233\148\153\231\173\155\229\173\144"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(222, 134)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(133, 119, 166),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_empty",
      z = 0,
      parent = "img_empty",
      text = T("\230\130\168\231\154\132\230\138\164\231\172\166\231\154\174\232\162\139\231\169\186\231\169\186\229\166\130\228\185\159"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(201, 84.75)
    }
  }
}

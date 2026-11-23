ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueBattlePrepareCharmItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(588, 103)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(350, 25, 250, 25.5),
      res = "UI/alpha/1080P/rogue/charm/charm_battle_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(294, 51.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63.6, h = 84.9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/rogue/charm/icon/charm_ap_1.png",
      name = "img_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 52)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 12.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/rogue/charm/charm_heart.png",
      name = "img_charm_heart_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 12.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/rogue/charm/charm_heart.png",
      name = "img_charm_heart_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 12.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/rogue/charm/charm_heart.png",
      name = "img_charm_heart_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 15.5)
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
      name = "label_name",
      z = 0,
      parent = "bg",
      text = T("\231\186\160\233\148\153\231\173\155\229\173\144"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(173, 79)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 231, 170),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_weight",
      z = 0,
      parent = "bg",
      text = T("\233\135\141\233\135\1433"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(248.5, 79.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(420, 45)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_des",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(127, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(607, 121)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_selected",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/rogue/charm/charm_battle_choose.png",
      capInsets = CCRectMake(350, 25, 250, 25.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(294, 52.5)
    }
  }
}

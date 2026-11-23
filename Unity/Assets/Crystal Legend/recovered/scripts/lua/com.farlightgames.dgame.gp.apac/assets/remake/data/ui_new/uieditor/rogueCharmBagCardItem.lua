ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueCharmBagCardItem = {
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
      res = "UI/alpha/1080P/rogue/charm/charm_lock_bg.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 106, h = 141.5},
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
      position = ccp(53, 76.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15, h = 14},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/rogue/charm/charm_heart.png",
      name = "img_heart_1",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32, 23.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 205, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_weight",
      z = 0,
      parent = "bg",
      text = "5",
      size = 24
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(99.5, 128.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15, h = 14},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/rogue/charm/charm_heart.png",
      name = "img_heart_3",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 23.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15, h = 14},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/rogue/charm/charm_heart.png",
      name = "img_heart_2",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.5, 23.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 106, h = 139.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/rogue/charm/charm_lock_mask.png",
      name = "img_mask",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, 70.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(210, 198, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_lock",
      z = 0,
      parent = "img_mask",
      text = T("\229\176\154\230\156\170\229\143\145\231\142\176"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, 23.25)
    }
  }
}

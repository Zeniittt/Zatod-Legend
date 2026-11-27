ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueTechTreeIcon = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 116, h = 116},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/techtree/techtree_icon_bg1.png",
      name = "image_bg",
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
      fix_wh = {w = 129.5, h = 130},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/techtree/techtree_light_frame.png",
      name = "image_activated_light",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58, 58)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158, h = 158},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/techtree/techtree_light_choose.png",
      name = "image_select",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58, 58)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/techtree/techtree_lock.png",
      name = "image_lock",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93, 91)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100.5, h = 101},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/techtree/icon/AGI.png",
      name = "image_icon",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58, 58)
    }
  }
}

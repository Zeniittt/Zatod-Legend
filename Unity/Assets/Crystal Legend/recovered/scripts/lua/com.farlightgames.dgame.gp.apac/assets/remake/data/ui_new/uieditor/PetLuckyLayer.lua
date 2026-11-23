ed.uieditor = ed.uieditor or {}
ed.uieditor.PetLuckyLayer = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(225, 250)
    },
    t = "Layer",
    base = {
      name = "panel_side_lucky",
      z = 10
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
      fix_wh = {w = 204, h = 108.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_side_lucky",
      res = "UI/alpha/1080P/pet/incubate/pet_house_incubate_point_bg.png",
      name = "lucky_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120.5, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 40.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "lucky_bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_incubate_point.png",
      name = "image_lucky",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133.5, 46.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100, h = 100},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "lucky_bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_activating_bg.png",
      name = "image_normal_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 48.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100, h = 100},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "lucky_bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_activated_bg.png",
      name = "image_activated_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 48.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 78.5, h = 76.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "lucky_bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_hammer.png",
      name = "image_hammer",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.5, 48.75)
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
      name = "label_luck_val",
      z = 5,
      parent = "lucky_bg",
      text = "/600",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150, 46.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 230, 64),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_luck_name",
      z = 5,
      parent = "lucky_bg",
      text = T("\229\159\185\232\130\178\229\128\188"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133, 75.75)
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
      name = "label_cur_luck_val",
      z = 5,
      parent = "lucky_bg",
      text = "700",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114, 45.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100, h = 100},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_activated_bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_light.png",
      name = "image_activated_eff",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 50)
    }
  }
}

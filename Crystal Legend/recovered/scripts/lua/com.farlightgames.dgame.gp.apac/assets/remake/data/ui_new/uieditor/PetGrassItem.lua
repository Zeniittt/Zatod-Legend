ed.uieditor = ed.uieditor or {}
ed.uieditor.PetGrassItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 128.5, h = 153.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_hatch_egg_empty.png",
      name = "hatching",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 98)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(249, 227, 161),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_hatch",
      z = 0,
      parent = "hatching",
      text = T("\229\173\181\232\155\139"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.25, 53.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 183, h = 83.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_hatch_grass_2.png",
      name = "grass",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 145.5, h = 38},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_hatch_grass_1.png",
      name = "frontgrass",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 162),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_open",
      z = 6,
      parent = "bg",
      text = T("\229\143\175\233\162\134\229\143\150"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 136, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_hatch_timer.png",
      name = "bg_timer",
      z = 6
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.5, 13)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 150)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "egg",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-1, 2.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 250, 197),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_timer",
      z = 0,
      parent = "bg_timer",
      text = "20:59",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 52, h = 52},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "hatching",
      res = "UI/alpha/1080P/pet/incubate/pet_house_hatch_add_egg.png",
      name = "image_add",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.75, 89.75)
    }
  }
}

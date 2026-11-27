ed.uieditor = ed.uieditor or {}
ed.uieditor.pirateshopScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pirateshop/background.jpg",
      name = "ImageView_327",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(514, 70)
    },
    t = "Layer",
    base = {name = "Panel_333", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(395, 470)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(627, 366.5)
    },
    t = "Layer",
    base = {
      parent = "ImageView_327",
      name = "Panel_332",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(342, 154)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 341.5, h = 138.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_333",
      res = "UI/alpha/1080P/pirateshop/canget_bg.png",
      name = "ImageView_334",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137, 36)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144.5, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_333",
      res = "UI/alpha/1080P/pirateshop/refresh.png",
      name = "ImageView_343",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(385, -17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 468, h = 259.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pirateshop/background_top.png",
      name = "ImageView_2426",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(128.5, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_343",
      res = "UI/alpha/1080P/pvp/refresh.png",
      name = "ImageView_345",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.25, 16.5)
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
      name = "Label_347",
      z = 0,
      parent = "ImageView_343",
      text = T("\229\136\183\230\150\176     1"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(105.25, 18)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 341.5, h = 138.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_333",
      res = "UI/alpha/1080P/pirateshop/full_bg.png",
      name = "ImageView_2395",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "Panel_333",
      name = "Panel_2399",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-18.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 341.5, h = 138.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_333",
      res = "UI/alpha/1080P/pirateshop/got_bg.png",
      name = "ImageView_2400",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 250)
    },
    t = "Layer",
    base = {
      parent = "ImageView_327",
      name = "Panel_spine",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(124.5, 157.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(194, 78.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bubble_bg_img",
      z = 0,
      parent = "ImageView_327",
      res = "UI/alpha/1080P/pirateshop/bubble.png",
      capInsets = CCRectMake(75, 0, 44, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(84.5, 481)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(119, 60, 36),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_bubble",
      z = 0,
      parent = "ImageView_327",
      text = "11",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(121, 501)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 28)
    },
    t = "Scale9Sprite",
    base = {
      name = "map_count_bg",
      z = 0,
      parent = "ImageView_327",
      res = "UI/alpha/1080P/main/main_status_number_bg.png",
      capInsets = CCRectMake(5, 0, 2.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(900, 602)
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
      name = "Label_336",
      z = 0,
      parent = "Panel_2399",
      text = "/120",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(197, 49)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_343",
      res = "UI/alpha/1080P/pirateshop/map.png",
      name = "ImageView_2394",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.25, 18.5)
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
      name = "Label_341",
      z = 0,
      parent = "Panel_2399",
      text = T("\228\187\138\230\151\165\230\182\136\232\128\151\228\189\147\229\138\155"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.5, 49.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 124),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2398",
      z = 0,
      parent = "Panel_2399",
      text = "60",
      size = 17
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(195, 49)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(109, 213, 48),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2401",
      z = 0,
      parent = "ImageView_2400",
      text = T("\228\187\138\230\151\165\229\183\178\233\162\134\229\143\150"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(152.25, 69.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 189, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_2399",
      res = "UI/alpha/1080P/pirateshop/process.png",
      name = "ImageView_2404",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(130, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.3, h = 25.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "map_count_bg",
      res = "UI/alpha/1080P/pirateshop/map.png",
      name = "ImageView_2506",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64, 15)
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
      name = "Label_map_count",
      z = 0,
      parent = "map_count_bg",
      text = "5/5",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(48.5, 14)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.tavernKingsPvpEntry = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 272.625, h = 106.125},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/tavern/tavern_pedestal_1.png",
      name = "node",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(225, 275)
    },
    t = "Layer",
    base = {name = "touch_area", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-112, -47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.25, x = 1.25},
      flip = "",
      opacity = 255,
      fix_wh = {w = 269.375, h = 57.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node",
      res = "UI/alpha/1080P/tavern/tavern_pedestal_3.png",
      name = "ImageView_79948",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(181.75, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "node",
      name = "eff_pos",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(181.75, 85.75)
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
      name = "label_name",
      z = 0,
      parent = "ImageView_79948",
      text = T("\232\175\184\231\142\139\228\186\137\233\156\184"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(107.75, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_79948",
      res = "UI/alpha/1080P/newkingspvp/main/test_bg.png",
      name = "kings_pvp_test_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(199.75, 42)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_79948",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "kings_pvp_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.25, 42)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 363.5, h = 141.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node",
      res = "UI/alpha/1080P/tavern/tavern_pedestal_2.png",
      name = "ImageView_17785",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(181.75, 70.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 250, 126),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "kings_pvp_label_test",
      z = 0,
      parent = "kings_pvp_test_bg",
      text = T("\230\181\139\232\175\149\231\137\136"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.25, 10)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.HeroItemUnGet = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(380.5, 122)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(300, 0, 5, 0.5),
      res = "UI/alpha/1080P/herolist/bg_hero_none.png",
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
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(383.5, 119)
    },
    t = "Scale9Sprite",
    base = {
      name = "light",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/herolist/light_summon.png",
      capInsets = CCRectMake(300, 0, 5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(190.25, 61)
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
      name = "layer_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(113.75, 17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 108, h = 108},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_18.png",
      name = "icon",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.25, 64)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(193.5, 38.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_name",
      z = 0,
      parent = "layer_mid",
      res = "UI/alpha/1080P/herolist/bg_name.png",
      capInsets = CCRectMake(100, 0.5, 5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(112, 71.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(196.5, 27.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_bar",
      z = 3,
      parent = "layer_mid",
      res = "UI/alpha/1080P/herolist/bg_bar.png",
      capInsets = CCRectMake(25, 0, 25, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_name",
      res = "UI/alpha/1080P/herolist/icon_str.png",
      name = "icon_type",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(5.25, 19.25)
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
      name = "name",
      z = 0,
      parent = "bg_name",
      text = T("\231\151\155\232\139\166\229\165\179\231\142\139"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.75, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.5, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/herolist/icon_stone.png",
      name = "icon_stone",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(2, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(58.95, 27.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bar",
      z = 1,
      parent = "bg_bar",
      res = "UI/alpha/1080P/herolist/bar.png",
      capInsets = CCRectMake(25, 0, 25, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 226, 93),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "num",
      z = 2,
      parent = "bg_bar",
      text = "180/180",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.5, 13.75)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.HeroItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(373, 122)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(250, 0, 10, 0.5),
      res = "UI/alpha/1080P/herolist/bg_hero_normal.png",
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
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 64)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 383.5, h = 119},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/herolist/light_summon.png",
      name = "light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(187, 61)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/herolist/icon_uncollect.png",
      name = "bg_collect",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(346, 89.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 32.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/herolist/icon_skill_up.png",
      name = "icon_skillup",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(346.5, 37.5)
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
      position = ccp(108.5, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_collect",
      res = "UI/alpha/1080P/herolist/icon_collect.png",
      name = "icon_collect",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(169, 154, 144),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_32232",
      z = 0,
      parent = "bg_collect",
      text = T("\229\133\179\230\179\168"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22, 23.5)
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
      position = ccp(117.5, 76)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.84, x = 0.84},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.46, h = 26.46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_mid",
      res = "UI/alpha/1080P/herolist/icon_unequip.png",
      name = "equip1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.84, x = 0.84},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.46, h = 26.46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_mid",
      res = "UI/alpha/1080P/herolist/icon_unequip.png",
      name = "equip2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.84, x = 0.84},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.46, h = 26.46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_mid",
      res = "UI/alpha/1080P/herolist/icon_unequip.png",
      name = "equip3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75.5, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.84, x = 0.84},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.46, h = 26.46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_mid",
      res = "UI/alpha/1080P/herolist/icon_unequip.png",
      name = "equip4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.84, x = 0.84},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.46, h = 26.46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_mid",
      res = "UI/alpha/1080P/herolist/icon_unequip.png",
      name = "equip5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.5, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.84, x = 0.84},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.46, h = 26.46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_mid",
      res = "UI/alpha/1080P/herolist/icon_unequip.png",
      name = "equip6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(161, 16)
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
      position = ccp(0.25, 19.25)
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
  }
}

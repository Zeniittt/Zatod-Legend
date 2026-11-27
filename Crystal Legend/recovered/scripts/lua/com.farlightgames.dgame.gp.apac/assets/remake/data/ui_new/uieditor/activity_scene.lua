ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_scene = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 400)
    },
    t = "Layer",
    base = {name = "btn_lay", z = 9},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(41, 50)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(159, 395)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_29",
      z = 0,
      parent = "btn_lay",
      res = "UI/alpha/1080P/activity/activity_btn_lay_bg.png",
      capInsets = CCRectMake(7, 4, 10, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83, 199)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(165, 385)
    },
    t = "Layer",
    base = {
      parent = "btn_lay",
      name = "Panel_30",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5.5, 7.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 75)
    },
    t = "Layer",
    base = {name = "back_lay", z = 9},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 465)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 75)
    },
    t = "Layer",
    base = {name = "rule_lay", z = 9},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(760, 465)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 268.5, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "back_lay",
      res = "UI/alpha/1080P/campaign/worldmap/worldmap_title_bg.png",
      name = "ImageView_32",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(40, 40)
    },
    t = "Layer",
    base = {
      parent = "back_lay",
      name = "calendar_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(254, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "page_lay", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(137, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "rule_btn",
      z = 0,
      parent = "rule_lay",
      res = "UI/alpha/1080P/activity/activity_str_bg.png",
      capInsets = CCRectMake(22.5, 0, 3, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86.5, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "rule_btn",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "ImageView_38",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 16.25)
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
      name = "Label_39",
      z = 0,
      parent = "rule_btn",
      text = T("\230\180\187\229\138\168\232\175\180\230\152\142"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_38",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_176",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.75, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "fca_lay", z = 10},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 270)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.package_dialogue = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(489, 287.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 200, 25, 250),
      res = "UI/alpha/1080P/package/bg_normal.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 259.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 300)
    },
    t = "Scale9Sprite",
    base = {
      name = "frame",
      z = 2,
      parent = "bg",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_big.png",
      capInsets = CCRectMake(20, 20, 445.5, 273)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(244.5, 143.75)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(100, 39),
      flip = "",
      labelConfig = {
        color = ccc3(255, 252, 231)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/package/btn_package2.png",
      capInsets = CCRectMake(11, 0, 0.5, 0.5),
      name = "left_button",
      z = 0,
      parent = "frame",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118, 44)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(100, 39),
      flip = "",
      labelConfig = {
        color = ccc3(255, 252, 231)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/package/btn_package2.png",
      capInsets = CCRectMake(11, 0, 0.5, 0.5),
      name = "right_button",
      z = 0,
      parent = "frame",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(382, 44)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 485.5, h = 54},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/1080P/package/bg_tip_title.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250, 264)
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
      name = "label_title",
      z = 0,
      parent = "bg_title",
      text = T("\230\143\144 \231\164\186"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.75, 41)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 14.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/1080P/common/comm_line_b_star.png",
      name = "deco_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250, 84.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_button_label",
      z = 0,
      parent = "left_button",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "right_button_label",
      z = 0,
      parent = "right_button",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 12.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "left_deco",
      z = 0,
      parent = "deco_mid",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      capInsets = CCRectMake(20, 0, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-97.75, 1.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 12.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "right_deco",
      z = 0,
      parent = "deco_mid",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      capInsets = CCRectMake(20, 0, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111.25, 1.75)
    }
  }
}

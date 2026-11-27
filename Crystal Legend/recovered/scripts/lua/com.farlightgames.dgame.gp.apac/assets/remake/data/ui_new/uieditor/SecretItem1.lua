ed.uieditor = ed.uieditor or {}
ed.uieditor.SecretItem1 = {
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
      fix_wh = {w = 19, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/secretbox/secretbox_line_bg2.png",
      name = "point",
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
      fix_wh = {w = 180, h = 197.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/secretbox/secretbox_unlock_bg.png",
      name = "icon_unlock",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 91)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138, h = 138},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/secretbox/secretbox_fin_bg.png",
      name = "icon_fin",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 99)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/equip_frame_blue.png",
      name = "icon_reward",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 99.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/equip_frame_mask.png",
      name = "mask",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 99.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138, h = 138},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/secretbox/secretbox_lock_bg.png",
      name = "icon_lock",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 99.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "mask",
      res = "UI/alpha/1080P/common/tick.png",
      name = "ImageView_1058",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/box_red.png",
      name = "redlight",
      z = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30, 131)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 187.5, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/secretbox/secretbox_text_bg.png",
      name = "ImageView_129",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 190, h = 190},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "icon_unlock",
      res = "UI/alpha/1080P/newshop/secretbox/secretbox_unlock_bg1.png",
      name = "ImageView_126",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 107.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 242, 148),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1073",
      z = 0,
      parent = "ImageView_129",
      text = "1",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.75, 34.5)
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
      name = "Label_128",
      z = 0,
      parent = "redlight",
      text = "1",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11, 11)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.champion_2025_tb = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(575, 168)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(142.5, 49, 395, 49),
      res = "UI/alpha/1080P/activity/champion2025tb/description-bg.png",
      name = "image_desc_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(207.5, 140)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 198.5, h = 68},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/cndota2025/button.png",
      name = "btn_go",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(863, 133)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97, h = 51},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/champion2025tb/logo.png",
      name = "image_logo",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(907.5, 408)
    }
  },
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
      res = "UI/alpha/1080P/activity/champion2025tb/bg1.jpg",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 678, h = 626},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/champion2025xg/avatar.png",
      name = "image_avatar",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292.5, 267.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 410.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/champion2025xg/bg.png",
      name = "image_bg_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 252)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134, h = 87.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_desc_bg",
      res = "UI/alpha/1080P/activity/cndota2025/bg2.png",
      name = "image_tatoo_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.5, 83.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 134, h = 87.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_desc_bg",
      res = "UI/alpha/1080P/activity/cndota2025/bg2.png",
      name = "image_tatoo_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(424.5, 83.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 251, 251),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc",
      z = 1,
      parent = "image_desc_bg",
      text = "",
      size = 14
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(42.5, 128.5)
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
      name = "label_go",
      z = 0,
      parent = "btn_go",
      text = T("\229\137\141\229\190\128\230\148\175\230\140\129"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.25, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 660, h = 306.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_logo",
      res = "UI/alpha/1080P/activity/champion2025tb/title2.png",
      name = "image_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-123, -43.5)
    }
  }
}

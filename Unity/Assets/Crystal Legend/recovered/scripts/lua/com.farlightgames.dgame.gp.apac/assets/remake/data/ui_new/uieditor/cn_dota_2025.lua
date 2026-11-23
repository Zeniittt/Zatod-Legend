ed.uieditor = ed.uieditor or {}
ed.uieditor.cn_dota_2025 = {
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
      res = "UI/alpha/1080P/activity/cndota2025/bg1.jpg",
      name = "image_bg",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 410.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/cndota2025/bg.png",
      name = "image_bg_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 252)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 610.2, h = 543.6},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/cndota2025/avatar.png",
      name = "image_avatar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(288, 272.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(520.5, 147.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(173.5, 49, 173.5, 49),
      res = "UI/alpha/1080P/activity/cndota2025/description_bg.png",
      name = "image_desc_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(201, 127)
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
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(811.5, 125.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 244, h = 65},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/cndota2025/logo.png",
      name = "image_logo",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(725.5, 325.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134, h = 87.5},
      visible = true
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
      position = ccp(94.5, 73.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 134, h = 87.5},
      visible = true
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
      position = ccp(424.5, 73.25)
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
      position = ccp(38.5, 103.75)
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
      text = T("\229\137\141\229\190\128\232\180\173\228\185\176"),
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
      fix_wh = {w = 475, h = 126},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_logo",
      res = "UI/alpha/1080P/activity/cndota2025/title.png",
      name = "image_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.5, -52.5)
    }
  }
}

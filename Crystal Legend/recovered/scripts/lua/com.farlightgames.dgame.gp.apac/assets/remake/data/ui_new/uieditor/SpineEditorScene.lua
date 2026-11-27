ed.uieditor = ed.uieditor or {}
ed.uieditor.SpineEditorScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 540},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/bg/dreamland_bj_2340.jpg",
      name = "bg",
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
      scaleSize = CCSizeMake(131, 500)
    },
    t = "Scale9Sprite",
    base = {
      name = "layer_item",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(9.5, 10, 20, 201.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "export",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1058.5, 501)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60.89998985, h = 29.3999958},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "default",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1072.5, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60.89998985, h = 29.3999958},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "jx",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(942, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60.89998985, h = 29.3999958},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "pt",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1006, 41)
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
      name = "Label_536",
      z = 0,
      parent = "export",
      text = T("\229\175\188 \229\135\186"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
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
      name = "Label_539",
      z = 0,
      parent = "default",
      text = "default",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
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
      name = "Label_5391",
      z = 0,
      parent = "jx",
      text = "jx",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
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
      name = "Label_539",
      z = 0,
      parent = "pt",
      text = "pt",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  }
}

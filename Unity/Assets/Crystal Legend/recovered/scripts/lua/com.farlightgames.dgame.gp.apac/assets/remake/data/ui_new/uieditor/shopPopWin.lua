ed.uieditor = ed.uieditor or {}
ed.uieditor.shopPopWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(410, 221.5)
    },
    t = "Layer",
    base = {name = "Panel_1109", z = 0},
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
      scaleSize = CCSizeMake(410, 221.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_1106",
      z = 0,
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(12, 0, 15, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205, 110)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_1110",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(128.5, 197.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_1110_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(282.5, 197.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 227, 186),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "Panel_1109",
      text = T("\230\143\144\231\164\186"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205, 198.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 6.75, h = 7.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/battle_star_lins.png",
      name = "ImageView_1113",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205.5, 72.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(375, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line_l",
      z = 0,
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      capInsets = CCRectMake(20, 0, 40, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(202.5, 69.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(375, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line_r",
      z = 0,
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      capInsets = CCRectMake(20, 0, 40, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(208.5, 69.5)
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
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_no",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 36)
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
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_yes",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(320.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 100)
    },
    t = "Layer",
    base = {
      parent = "Panel_1109",
      name = "txt_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(30.5, 81)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 48, 29),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1117",
      z = 0,
      parent = "btn_no",
      text = T("\229\143\150\230\182\136"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 242, 166),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1117_Copy0",
      z = 0,
      parent = "btn_no",
      text = T("\229\143\150\230\182\136"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 48, 29),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1117",
      z = 0,
      parent = "btn_yes",
      text = T("\231\161\174\232\174\164"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 242, 166),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1117_Copy0",
      z = 0,
      parent = "btn_yes",
      text = T("\231\161\174\232\174\164"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 22)
    }
  }
}

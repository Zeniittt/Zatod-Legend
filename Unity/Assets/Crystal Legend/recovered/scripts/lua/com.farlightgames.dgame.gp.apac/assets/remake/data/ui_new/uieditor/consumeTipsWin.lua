ed.uieditor = ed.uieditor or {}
ed.uieditor.consumeTipsWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(489, 287)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(41.5, 70, 41.5, 390.5),
      res = "UI/alpha/1080P/package/bg_normal.png",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 300)
    },
    t = "Scale9Sprite",
    base = {
      name = "frame",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_big.png",
      capInsets = CCRectMake(10, 222.5, 10, 136.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(244.5, 143.5)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/package/bg_tip_title.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(244.5, 256)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 125)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(44.5, 118.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/com_line_center.png",
      name = "ImageView_32277",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(244.5, 95.5)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_mini_sys.png",
      name = "btn_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.5, 39)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_mini_sys.png",
      name = "btn_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(394.5, 39)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/sharefight/checkbox.png",
      name = "btn_check_box",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(359.5, 78)
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
      text = T("\230\143\144\231\164\186"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.75, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 228, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_32277",
      res = "UI/alpha/1080P/common/com_line_left.png",
      name = "ImageView_32278",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-114.25, 3.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 228, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_32277",
      res = "UI/alpha/1080P/common/com_line_left.png",
      name = "ImageView_32279",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.75, 3.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 252, 230),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left",
      z = 0,
      parent = "btn_left",
      text = T("\229\143\150\230\182\136"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 252, 230),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_right",
      z = 0,
      parent = "btn_right",
      text = T("\231\161\174\229\174\154"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.30000007, x = 1.30000007},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.150001085, h = 19.50000105},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_check_box",
      res = "UI/alpha/1080P/common/account_sifting_mark.png",
      name = "image_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.5, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(46, 44, 46),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_check_box",
      z = 0,
      parent = "btn_check_box",
      text = T("\228\187\138\230\151\165\228\184\141\229\134\141\230\143\144\233\134\146"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27, 14.5)
    }
  }
}

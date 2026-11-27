ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueRoomDetailWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 661.5, h = 329.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_room_detail_window.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482.5, 299.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_room_type_bg.png",
      name = "image_room",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(328.25, 193.25)
    }
  },
  {
    config = {
      rotation = -0.03678788,
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
      name = "label_tips",
      z = 0,
      parent = "image_bg",
      text = T("\229\141\179\229\176\134\233\129\135\229\136\176\231\165\158\231\167\152\228\186\139\228\187\182..."),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(331.75, 126.25)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_go",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(328.75, 45.75)
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
      name = "image_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(330.75, 89.75)
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
      name = "label_go",
      z = 0,
      parent = "btn_go",
      text = T("\229\137\141\232\191\155"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
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
      parent = "image_line",
      res = "UI/alpha/1080P/common/com_line_left.png",
      name = "ImageView_61008",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-113.75, 4.25)
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
      parent = "image_line",
      res = "UI/alpha/1080P/common/com_line_left.png",
      name = "ImageView_61008_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.25, 4.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 60)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_change",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(149.75, 25.25)
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
      parent = "panel_change",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_change",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17, h = 18},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_change",
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_bet_icon.png",
      name = "ImageView_17499",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 51)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 128),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_change_times",
      z = 0,
      parent = "panel_change",
      text = "10",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(51.5, 51)
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
      name = "label_change",
      z = 0,
      parent = "btn_change",
      text = T("\233\135\141\230\138\149"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
    }
  }
}

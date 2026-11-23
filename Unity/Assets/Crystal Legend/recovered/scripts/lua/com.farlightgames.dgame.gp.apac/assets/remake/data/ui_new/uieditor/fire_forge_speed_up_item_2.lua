ed.uieditor = ed.uieditor or {}
ed.uieditor.fire_forge_speed_up_item_2 = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 542, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/skip/choose_board.png",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 125),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc",
      z = 0,
      parent = "bg",
      text = T("\229\143\175\229\138\160\233\128\1595\229\136\134\233\146\159"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(101, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1, h = 46.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/incubate/pet_house_hatch_timer_border_line.png",
      name = "ImageView_4609",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 29)
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
      parent = "bg",
      text = T("\229\138\160\233\128\159\229\136\184"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(101, 40)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102.5, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/fireforge/skip/button_board.png",
      name = "btn_ok",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/fireforge/skip/plus_board.png",
      name = "btn_minus",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(257.5, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/fireforge/skip/plus_board.png",
      name = "btn_max",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(403.5, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/fireforge/skip/plus_board.png",
      name = "btn_add",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(357.5, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/fireforge/skip/plus_numboard.png",
      name = "bg_number",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(307.5, 29)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(41.5, 29)
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
      name = "use_amount",
      z = 0,
      parent = "bg_number",
      text = "123",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 221),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_minus",
      z = 0,
      parent = "btn_minus",
      text = "-",
      size = 36
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_max",
      res = "UI/alpha/1080P/fireforge/skip/plus_max.png",
      name = "ImageView_2008",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 221),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_add",
      z = 0,
      parent = "btn_add",
      text = "+",
      size = 36
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22, 21.25)
    }
  }
}

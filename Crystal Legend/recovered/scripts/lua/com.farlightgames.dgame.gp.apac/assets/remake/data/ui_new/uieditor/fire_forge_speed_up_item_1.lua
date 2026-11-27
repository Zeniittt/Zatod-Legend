ed.uieditor = ed.uieditor or {}
ed.uieditor.fire_forge_speed_up_item_1 = {
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
      text = T("\231\155\180\230\142\165\233\148\187\233\128\160\229\174\140\230\136\144"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(101, 18)
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
      text = T("\233\146\187\231\159\179"),
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
      position = ccp(41, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_ok",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "icon_diamond",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.25, 20.25)
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
      name = "label_amount",
      z = 0,
      parent = "btn_ok",
      text = "9999",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 20.25)
    }
  }
}

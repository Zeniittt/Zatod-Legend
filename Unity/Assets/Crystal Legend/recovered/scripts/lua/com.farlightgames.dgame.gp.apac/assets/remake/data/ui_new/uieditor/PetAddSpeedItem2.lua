ed.uieditor = ed.uieditor or {}
ed.uieditor.PetAddSpeedItem2 = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 557, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pet/incubate/pet_house_hatch_timer_item_bg.png",
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
      fix_scale = {y = 0.59, x = 0.59},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.3, h = 41.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/icon/highsoul_big.jpg",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 29)
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
      text = T("\233\146\187\231\159\179"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(109, 19)
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
      position = ccp(94.5, 29)
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
      position = ccp(109, 40.5)
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
      name = "btn_ok",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(489.5, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45.9, h = 46.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_minus",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45.9, h = 46.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_max",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(411, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45.9, h = 46.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_add",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(365, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(47.5, 37.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_number",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/package/bg_soldout.png",
      capInsets = CCRectMake(11, 5, 28, 35)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(315, 29)
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
      name = "Label_4615",
      z = 0,
      parent = "btn_ok",
      text = T("\229\138\160\233\128\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19, h = 7.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_minus",
      res = "UI/alpha/1080P/common/buy_down.png",
      name = "ImageView_95485",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_max",
      res = "UI/alpha/1080P/pet/incubate/pet_speedup_button.png",
      name = "ImageView_95736",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_add",
      res = "UI/alpha/1080P/common/buy_add.png",
      name = "ImageView_95484",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
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
      position = ccp(23.75, 18.75)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.skinDetailPop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(860.5, 479.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 35, 15, 55),
      res = "UI/alpha/1080P/common/com_img_9bg2.png",
      name = "bg",
      z = 999
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      fix_wh = {w = 40.5, h = 41.25},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 1,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(849.75, 468.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_skin",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(430.25, 237.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 153.599990784, h = 45.199997288},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_get",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(556.25, 104.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_288",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(581, 457)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_mid",
      z = 0,
      parent = "layer_skin",
      res = "UI/alpha/1080P/hero/hero_bg_mid_1.png",
      capInsets = CCRectMake(12, 150, 12, 150)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-163.5, -225)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 159.5, h = 456},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_mid",
      res = "UI/alpha/1080P/skin/skin_bg_1.png",
      name = "deco_right",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(503.5, 231)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 159.5, h = 456},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_mid",
      res = "UI/alpha/1080P/skin/skin_bg_1.png",
      name = "deco_left",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74.5, 231)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 594.5, h = 460},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_mid",
      res = "UI/alpha/1080P/skin/skin_bg.png",
      name = "bg_skin",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290, 229.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 234, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_mid",
      res = "UI/alpha/1080P/skin/skin_name_frame.png",
      name = "bg_skin_name",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(296, 426.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(860.5, 479.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15, 32.5, 15, 15),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg_Copy0",
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
      name = "skin_name",
      z = 0,
      parent = "bg_skin_name",
      text = "",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 226, h = 46},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/three_kingdom/three_kingdom_access.png",
      name = "tipbg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(553.25, 108.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 206, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_754",
      z = 0,
      parent = "btn_get",
      text = T("\229\142\187\232\142\183\229\143\150"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "tipbg",
      res = "UI/alpha/1080P/activity/three_kingdom/three_kingdom_get.png",
      name = "btn_got",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(143, 251, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_got",
      z = 0,
      parent = "btn_got",
      text = T("\231\154\174\232\130\164\229\183\178\230\139\165\230\156\137"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76.5, 11.75)
    }
  }
}

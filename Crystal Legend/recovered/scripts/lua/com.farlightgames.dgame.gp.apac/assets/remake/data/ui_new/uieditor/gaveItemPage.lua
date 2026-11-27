ed.uieditor = ed.uieditor or {}
ed.uieditor.gaveItemPage = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(485, 306)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 50, 50, 100),
      res = "UI/alpha/1080P/common/com_img_9bg1.png",
      name = "outClickLay",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(481, 273)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 318.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 50, 5, 50),
      res = "UI/alpha/1080P/common/com_img_9bg2.png",
      name = "mail9Bj_14363",
      z = 2
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
      scaleSize = CCSizeMake(310, 30)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 0.5, 50, 27),
      res = "UI/alpha/1080P/battle/battle_prepare_name_bg.png",
      name = "ImageView_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 409.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(435, 187.5)
    },
    t = "Layer",
    base = {name = "lay_post", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(262, 198)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 252, 230),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 22,
      text = T("\230\143\144\231\164\186"),
      name = "Label_title",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478.5, 411)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(475, 75)
    },
    t = "Layer",
    base = {name = "Panel_up", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(243.5, 133.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 41.25},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "ImageView_close",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(715.5, 415)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(225, 6.25)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_8432",
      z = 5,
      parent = "Panel_up",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      capInsets = CCRectMake(17, 0.5, 16.5, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(121.5, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(13.5, 14.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_823232",
      z = 5,
      parent = "Panel_up",
      res = "UI/alpha/1080P/common/comm_line_b_star.png",
      capInsets = CCRectMake(10.5, 0.5, 5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(235.5, 65.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(225, 6.25)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_8463",
      z = 5,
      parent = "Panel_up",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      capInsets = CCRectMake(17, 0.5, 16.5, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(113, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "butt_a",
      z = 1,
      parent = "Panel_up",
      res = "UI/alpha/1080P/common/button_mini_red.png",
      capInsets = CCRectMake(15, 15, 50, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(113, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "butt_b",
      z = 1,
      parent = "Panel_up",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(15, 15, 50, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(365, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(113, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "butt_c",
      z = 1,
      parent = "Panel_up",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(15, 15, 50, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105, 22.5)
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
      name = "Label_891",
      z = 0,
      parent = "butt_a",
      text = T("\229\188\186\232\161\140\233\162\134\229\143\150"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(235, 213, 138),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_892",
      z = 0,
      parent = "butt_b",
      text = T("\231\161\174\229\174\154"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(235, 213, 138),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_893",
      z = 0,
      parent = "butt_c",
      text = T("\229\143\150\230\182\136"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56.5, 23)
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
      parent = "ImageView_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_334",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28.5)
    }
  }
}

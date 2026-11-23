ed.uieditor = ed.uieditor or {}
ed.uieditor.stage_choose_loot_pop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(525, 277.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(7.5, 7.5, 7, 7),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "ImageView_3329",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 285.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.7999946, h = 38.4999945},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_3329",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(514, 266.75)
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
      parent = "ImageView_3329",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "ImageView_3333",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154, 252.25)
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
      parent = "ImageView_3329",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_3335",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(371.5, 252.75)
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
      name = "Label_3336",
      z = 0,
      parent = "ImageView_3329",
      text = T("\232\175\183\233\128\137\230\139\169\231\129\181\233\173\130\231\159\179"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(260.5, 252.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(485, 168)
    },
    t = "Layer",
    base = {
      parent = "ImageView_3329",
      name = "Panel_3337",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(19.5, 68.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 3.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_3338",
      z = 0,
      parent = "ImageView_3329",
      res = "UI/alpha/1080P/pool/pool_line.png",
      capInsets = CCRectMake(125, 0.5, 45, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(262.5, 67.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_3329",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_cancel",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(152.5, 33.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_3329",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(372, 33.25)
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
      name = "ImageView_3332",
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
      color = ccc3(252, 241, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3340",
      z = 0,
      parent = "btn_cancel",
      text = T("\229\143\150\230\182\136"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 241, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3341",
      z = 0,
      parent = "btn_right",
      text = T("\233\128\137\230\139\169"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 25.25)
    }
  }
}

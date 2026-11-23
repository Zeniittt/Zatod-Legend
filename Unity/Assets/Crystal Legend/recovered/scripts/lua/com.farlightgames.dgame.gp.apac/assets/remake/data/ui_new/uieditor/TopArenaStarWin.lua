ed.uieditor = ed.uieditor or {}
ed.uieditor.TopArenaStarWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 748, h = 420.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/toparena_star_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 266)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/peakarena_close.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(731.5, 403.25)
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
      name = "title",
      z = 0,
      parent = "bg",
      text = "Text Label",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(377, 390.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = -64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "btn_next",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-22.5, 243.25)
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
      name = "label_next",
      z = 10,
      parent = "bg",
      text = T("\228\184\139\230\156\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-22, 243.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = -64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "btn_cur",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-22.5, 332.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 72, h = 77},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_next",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
      name = "btn_next_selected",
      z = 3
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(64.75, 36.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cur",
      z = 10,
      parent = "bg",
      text = T("\230\156\172\230\156\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-22.5, 332.75)
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
      name = "label_skill",
      z = 0,
      parent = "bg",
      text = "label_skill",
      size = 10
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(63.5, 343.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4103",
      z = 0,
      parent = "bg",
      text = T("\233\128\130\231\148\168\232\139\177\233\155\132"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(377, 262.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.5, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/toparena_star_prepare_line.png",
      name = "ImageView_4104",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(481, 260.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 72, h = 77},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_cur",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
      name = "btn_cur_selected",
      z = 3
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(64.75, 36.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 47.5, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/toparena_star_prepare_line.png",
      name = "ImageView_4104_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(271, 260.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(640, 165)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_4106",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(55.5, 75.25)
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
      name = "Label_4523",
      z = 0,
      parent = "bg",
      text = "Text Label",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(374, 39.75)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.playerRename = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(413, 225.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 10),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(480, 435)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_100",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(306, 201.5)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_100_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.5, 201.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lb_title",
      z = 0,
      parent = "bg",
      text = T("\230\155\180\230\148\185\230\136\152\233\152\159\229\144\141\231\167\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205.5, 203)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(327.5, 53)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_input",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/playerinfo/window_bg2.png",
      capInsets = CCRectMake(9, 12.5, 9, 12.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(206.5, 140)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 101.5, h = 42},
      flip = "",
      labelConfig = {
        color = ccc3(253, 240, 158)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_cancel",
      z = 0,
      parent = "bg",
      text = T("\229\143\150\230\182\136"),
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.5, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 101.5, h = 42},
      flip = "",
      labelConfig = {
        color = ccc3(253, 240, 158)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_confirm",
      z = 0,
      parent = "bg",
      text = T("\231\161\174\232\174\164"),
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(322.5, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.82, x = 0.82},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.96, h = 22.96},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "cost",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(304.5, 74)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "cost_num",
      z = 0,
      parent = "bg",
      text = "999",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(332, 74.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_input",
      res = "UI/alpha/1080P/playerinfo/icon_rename.png",
      name = "btn_rand",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(296.25, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(220.5, 44)
    },
    t = "Layer",
    base = {
      parent = "bg_input",
      name = "panel_input",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(47.75, 2.5)
    }
  }
}

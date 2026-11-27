ed.uieditor = ed.uieditor or {}
ed.uieditor.crevicedefendStatisticWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(668, 440)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 10),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478, 259)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.2, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(655.5, 426.5)
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
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_902",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28.5)
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
      name = "title",
      z = 0,
      parent = "bg",
      text = T("\230\149\176\230\141\174\231\187\159\232\174\161"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(333.5, 421)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(142.5, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_board",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(20, 20, 5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(334, 26)
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
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "img_title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(235.5, 419.5)
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
      name = "img_title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(433, 419.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 139.5, h = 66},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_board",
      res = "UI/alpha/1080P/toparena/toparena_team_invisible_choose.png",
      name = "btn_hide_save",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71.25, 21)
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
      name = "label_hide_tips",
      z = 2,
      parent = "btn_board",
      text = T("\228\184\128\233\148\174\228\184\138\233\152\181"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.25, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 355)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_team",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9.5, 49.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildEnlistSubscribePop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(577, 368)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15, 15, 15, 15),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "ImageView_bj",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476, 280)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "ImageView_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(560, 353)
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
      name = "ImageView_451",
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
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "ImageView_452",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(190, 342)
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
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_453",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(387.5, 341.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 222, 182),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_454",
      z = 0,
      parent = "ImageView_bj",
      text = T("\230\139\155\229\139\159\230\156\141\229\138\161"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(288.5, 344)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(549.5, 312)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_455",
      z = 0,
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/common/mail_bj9.png",
      capInsets = CCRectMake(20, 20, 20, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(288.5, 164)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 197.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/common/battle_prepare_lins_2.png",
      name = "ImageView_456",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(285, 124.5)
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
      parent = "ImageView_bj",
      name = "Panel_open",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(288.5, 1.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "ImageView_bj",
      name = "Panel_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(288.5, 1.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_open_desc",
      z = 0,
      parent = "Panel_open",
      text = T("\230\156\141\229\138\161\229\145\168\230\156\159\228\184\186\228\184\128\228\184\170\230\156\136\239\188\140\229\136\176\230\156\159\229\144\142\228\188\154\233\135\141\230\150\176\232\175\132\228\188\176\229\133\172\228\188\154\230\152\175\229\144\166\230\187\161\232\182\179\229\188\128\229\144\175\232\181\132\230\160\188"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 95.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 192, h = 56.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_open",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_open",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-0.5, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 371.5, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/guild/guild_enlist/opening_background.png",
      name = "ImageView_458",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-0.5, 45.5)
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
      name = "Label_457",
      z = 0,
      parent = "Panel_right",
      text = T("\230\141\174\230\156\141\229\138\161\231\187\147\230\157\159\232\191\152\230\156\137"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-39, 95.5)
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
      name = "Label_time",
      z = 0,
      parent = "Panel_right",
      text = T("24\229\164\169"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(13, 95.5)
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
      name = "Label_459",
      z = 0,
      parent = "btn_open",
      text = T("\229\188\128\229\144\175\230\156\141\229\138\161"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.5, 29.75)
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
      name = "Label_459",
      z = 0,
      parent = "ImageView_458",
      text = T("\231\148\159\230\149\136\228\184\173"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(186.25, 21)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(475, 160)
    },
    t = "Layer",
    base = {
      parent = "ImageView_bj",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(51, 134)
    }
  }
}

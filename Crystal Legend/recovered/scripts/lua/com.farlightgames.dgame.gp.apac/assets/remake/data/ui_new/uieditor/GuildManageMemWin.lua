ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildManageMemWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 240)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 19.5, 201.5),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
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
      name = "line1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(279, 211.5)
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
      parent = "line1",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "line2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-124.5, 6)
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
      z = 1,
      parent = "line1",
      text = T("\229\133\172\228\188\154\232\174\190\231\189\174"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-45.5, 6)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(385.5, 225.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(120, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_find",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_mini_sys.png",
      capInsets = CCRectMake(10, 10, 81.5, 22)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110, 120)
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
      name = "ImageView_2427",
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
      scaleSize = CCSizeMake(120, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_exit",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_mini_sys.png",
      capInsets = CCRectMake(10, 10, 81.5, 22)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290, 120)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(120, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_recruit",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_mini_sys.png",
      capInsets = CCRectMake(10, 10, 81.5, 22)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_find",
      res = "UI/alpha/1080P/guild/seach_1.png",
      name = "icon_find",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 21)
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
      name = "label_find",
      z = 0,
      parent = "btn_find",
      text = T("\230\159\165\230\137\190\229\133\172\228\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_exit",
      res = "UI/alpha/1080P/guild/dissolve.png",
      name = "icon_exit",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 21)
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
      name = "label_exit",
      z = 0,
      parent = "btn_exit",
      text = T("\233\128\128\229\135\186\229\133\172\228\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_recruit",
      res = "UI/alpha/1080P/guild/guild_enlist/tab_unselected.png",
      name = "icon_recruit",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 21)
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
      name = "label_recruit",
      z = 0,
      parent = "btn_recruit",
      text = T("\229\133\172\228\188\154\230\139\155\229\139\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(120, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_rank",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_mini_sys.png",
      capInsets = CCRectMake(10, 10, 81.5, 22)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290, 72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rank",
      res = "UI/alpha/1080P/guild/ranking/ranking.png",
      name = "icon_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 21)
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
      name = "label_rank",
      z = 0,
      parent = "btn_rank",
      text = T("\231\142\169\230\179\149\230\142\146\232\161\140"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.5, 22.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildEnlistShieldPop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(580, 383)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(18, 20.5, 50, 350),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "ImageView_bj",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477.5, 276.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(272.7, 28.8)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_471",
      z = 0,
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/package/bg_compose.png",
      capInsets = CCRectMake(50, 0, 105.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290, 356)
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
      name = "ImageView_475",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(456, 354.5)
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
      name = "ImageView_475_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124.5, 355)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(548.5, 312)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_477",
      z = 0,
      parent = "ImageView_bj",
      res = "UI/alpha/1080P/common/mail_bj9.png",
      capInsets = CCRectMake(25, 0, 24.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290, 179.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(0, 0, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_478",
      z = 0,
      parent = "ImageView_bj",
      text = T("\232\162\171\229\177\143\232\148\189\231\154\132\229\133\172\228\188\154\230\136\144\229\145\152\231\154\132\228\191\161\230\129\175\228\184\141\228\188\154\230\152\190\231\164\186\229\156\168\229\136\151\232\161\168\228\184\173"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(291.5, 320.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(229, 178, 73),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_478_Copy0",
      z = 0,
      parent = "ImageView_bj",
      text = T("\232\162\171\229\177\143\232\148\189\231\154\132\229\133\172\228\188\154\230\136\144\229\145\152\231\154\132\228\191\161\230\129\175\228\184\141\228\188\154\230\152\190\231\164\186\229\156\168\229\136\151\232\161\168\228\184\173"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(291.5, 321.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(542.5, 259.5)
    },
    t = "Layer",
    base = {
      parent = "ImageView_bj",
      name = "Panel_480",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(19, 52)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 234),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_481",
      z = 0,
      parent = "ImageView_bj",
      text = T("\229\183\178\229\177\143\232\148\189\229\133\172\228\188\154\230\149\176\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(494, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(229, 178, 73),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_guild_count",
      z = 0,
      parent = "ImageView_bj",
      text = "3",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(543.5, 35.5)
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
      position = ccp(561, 365)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 234),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_472",
      z = 9,
      parent = "ImageView_471",
      text = T("\229\177\143\232\148\189\229\133\172\228\188\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(0, 0, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_472_Copy0",
      z = 0,
      parent = "ImageView_471",
      text = T("\229\177\143\232\148\189\229\133\172\228\188\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(151, 15.5)
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
  }
}

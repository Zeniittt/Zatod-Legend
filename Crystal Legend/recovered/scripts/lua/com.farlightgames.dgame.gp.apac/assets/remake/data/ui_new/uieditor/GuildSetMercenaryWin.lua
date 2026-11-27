ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildSetMercenaryWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(585.5, 350)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 50, 350),
      res = "UI/alpha/1080P/common/com_new_2.png",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line1",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      capInsets = CCRectMake(33, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(497.75, 322.5)
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
      parent = "bg",
      text = T("\229\133\172\228\188\154\228\189\163\229\133\181"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(288.75, 324)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 1.30000007},
      flip = "",
      opacity = 255,
      fix_wh = {w = 267.150014385, h = 28.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/package/bg_compose.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292.75, 323.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      capInsets = CCRectMake(33, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.75, 322.5)
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
      position = ccp(567.25, 334)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/mercenary_tab_1.png",
      name = "btn_self",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(634.25, 271)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/mercenary_tab_1.png",
      name = "btn_guild",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(634.25, 199)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(560, 285)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_item",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/mail_bj9.png",
      capInsets = CCRectMake(25, 104, 25, 104)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292.75, 158)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.199998728, h = 21.199998728},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(332.75, 323.5)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_self",
      res = "UI/alpha/1080P/guild/mercenary_tab.png",
      name = "btn_self_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 31)
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
      name = "label_self",
      z = 0,
      parent = "btn_self",
      text = T("\230\136\145\231\154\132\228\189\163\229\133\181"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.25, 31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.5, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_item",
      res = "UI/alpha/1080P/guild/mercenary_1.png",
      name = "ImageView_12727",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(519, 272.5)
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
      name = "label_guild",
      z = 0,
      parent = "btn_guild",
      text = T("\229\133\172\228\188\154\228\189\163\229\133\181"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.25, 31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 62},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_guild",
      res = "UI/alpha/1080P/guild/mercenary_tab.png",
      name = "btn_guild_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 31)
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
      name = "label_xxx",
      z = 0,
      parent = "bg_item",
      text = T("\229\183\178\230\180\190\229\135\186\228\189\163\229\133\181\230\149\176\233\135\143:"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(456.5, 272.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(560, 261.5)
    },
    t = "Layer",
    base = {
      parent = "bg_item",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 1)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "icon_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
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
      name = "label_self_selected",
      z = 0,
      parent = "btn_self_selected",
      text = T("\230\136\145\231\154\132\228\189\163\229\133\181"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.25, 31)
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
      name = "label_num",
      z = 0,
      parent = "ImageView_12727",
      text = "1/2",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 10.5)
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
      name = "label_guild_selected",
      z = 0,
      parent = "btn_guild_selected",
      text = T("\229\133\172\228\188\154\228\189\163\229\133\181"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.25, 31)
    }
  }
}

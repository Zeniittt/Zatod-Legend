ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueRankWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 990, h = 540},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/rank/rank_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(447.5, 263.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/rank/rank_esc_button.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(879, 461)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(495, 471)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(109, 79, 32),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc",
      z = 0,
      parent = "image_bg",
      text = T("\230\160\185\230\141\174\229\141\149\229\156\186\231\180\175\231\167\175\232\142\183\229\190\151\231\143\141\231\143\160\230\149\176\232\191\155\232\161\140\230\142\146\229\144\141"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(498, 425.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(730, 327.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(132.5, 86.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 785, h = 94},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/rank/rank_backboard_5.png",
      name = "my_rank_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(497, 84.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(118.5, 300)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_tab_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(878.5, 110)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 171.5, h = 152},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/rank/rank_empty.png",
      name = "image_empty",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(495, 270)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(239, 219, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_empty_tips",
      z = 0,
      parent = "image_empty",
      text = T("\230\142\146\232\161\140\230\166\156\232\153\154\228\189\141\228\187\165\229\190\133\229\147\166"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85.75, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "my_rank_bg",
      res = "UI/alpha/1080P/skilltower/abyss/abyss_rank_base_mine_name.png",
      name = "my_rank_tips_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89, 63.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 80)
    },
    t = "Layer",
    base = {
      parent = "my_rank_bg",
      name = "panel_my_rank_head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(150, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(350, 90)
    },
    t = "Layer",
    base = {
      parent = "my_rank_bg",
      name = "self_panel_pearl",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(398.5, 1.5)
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
      name = "label_my_rank",
      z = 0,
      parent = "my_rank_bg",
      text = "289",
      size = 40
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.5, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(350, 90)
    },
    t = "Layer",
    base = {
      parent = "my_rank_bg",
      name = "self_panel_damage",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(398.5, 1.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(350, 90)
    },
    t = "Layer",
    base = {
      parent = "my_rank_bg",
      name = "self_panel_bless",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(398.5, 1.5)
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
      name = "label_my_rank_tips",
      z = 0,
      parent = "my_rank_tips_bg",
      text = T("\230\136\145\231\154\132\230\142\146\229\144\141"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.25, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1.5, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "self_panel_pearl",
      res = "UI/alpha/1080P/rogue/rank/rank_line_1.png",
      name = "image_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.5, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "self_panel_pearl",
      res = "UI/alpha/1080P/rogue/rank/rank_pearl_bg_4.png",
      name = "image_pearl_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210.5, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1.5, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "self_panel_damage",
      res = "UI/alpha/1080P/rogue/rank/rank_line_1.png",
      name = "image_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(8.5, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1.5, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "self_panel_damage",
      res = "UI/alpha/1080P/rogue/rank/rank_line_1.png",
      name = "image_line_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(130.5, 45)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "self_panel_damage",
      name = "panel_hero_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(288, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage",
      z = 0,
      parent = "self_panel_damage",
      text = "999999",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200.5, 33)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage_tips",
      z = 0,
      parent = "self_panel_damage",
      text = T("\229\141\149\229\156\186\230\156\128\233\171\152\232\190\147\229\135\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(201, 57)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 92, 92),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_crisis_amount",
      z = 0,
      parent = "self_panel_damage",
      text = "9",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(102, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "self_panel_damage",
      res = "UI/alpha/1080P/rogue/rank/rank_crisis_icon.png",
      name = "crisis_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85.5, 46)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_diff",
      z = 0,
      parent = "self_panel_damage",
      text = T("\233\154\190\229\186\1664"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 46)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_bless_amount",
      z = 0,
      parent = "self_panel_bless",
      text = "654",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(280.5, 46)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_bless_tips",
      z = 0,
      parent = "self_panel_bless",
      text = T("\229\141\149\229\156\186\231\180\175\231\167\175\232\142\183\229\143\150\231\165\157\231\166\143\230\149\176\233\135\143\239\188\154"),
      size = 17
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(279.5, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1.5, h = 71},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "self_panel_bless",
      res = "UI/alpha/1080P/rogue/rank/rank_line_2.png",
      name = "image_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_pearl_bg",
      res = "UI/alpha/1080P/icon/pearl.png",
      name = "pearl_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_pearl_amount",
      z = 0,
      parent = "image_pearl_bg",
      text = "10000",
      size = 24
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(83, 15)
    }
  }
}

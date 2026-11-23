ed.uieditor = ed.uieditor or {}
ed.uieditor.nian_monster_rank_win = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1058.5, h = 577},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/nianmonster/nian_rank_bg.png",
      name = "image_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(468, 298)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 166, h = 89},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_rank_title.png",
      name = "image_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(548.75, 440)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 188, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc",
      z = 0,
      parent = "image_bg",
      text = T("\230\160\185\230\141\174\229\142\134\229\143\178\230\156\128\233\171\152\231\131\173\229\138\155\232\191\155\232\161\140\230\142\146\232\161\140\239\188\140\228\187\133\228\190\155\229\177\149\231\164\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(540.75, 390.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(746, 311.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "list_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(176.25, 68.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(813, 450)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "layer_click_area",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(120.75, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_rank_exit.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(918.75, 423.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 172, h = 143.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_rank_empty.png",
      name = "image_empty_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(540.75, 236)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(741, 102.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "my_rank_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_rank_shade.png",
      capInsets = CCRectMake(253, 34, 253, 34)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(547.25, 90.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_rank_tattoo.png",
      name = "image_dec1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(693.75, 390.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 16, h = 9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_rank_tattoo.png",
      name = "image_dec2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(386.75, 390.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(158, 102, 94),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_empty_tips",
      z = 0,
      parent = "image_empty_tips",
      text = T("\230\142\146\232\161\140\230\166\156\232\153\154\228\189\141\228\187\165\229\190\133\229\147\166"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86, 5.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 728.5, h = 80},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "my_rank_bg",
      res = "UI/alpha/1080P/hades/hades_rank_bg2.png",
      name = "image_my_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(372.5, 38.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 187.5, h = 78},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_my_rank",
      res = "UI/alpha/1080P/hades/hades_rank_light2.png",
      name = "image_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(473.25, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(90, 90)
    },
    t = "Layer",
    base = {
      parent = "image_my_rank",
      name = "panel_head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(97.25, -5)
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
      name = "label_player_name",
      z = 0,
      parent = "image_my_rank",
      text = T("\231\142\169\229\174\182\229\144\141\231\167\176\231\142\169\229\174\182\229\144\141\231\167\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(188.75, 53.5)
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
      name = "label_guild_name",
      z = 0,
      parent = "image_my_rank",
      text = T("\229\133\172\228\188\154\229\144\141\231\167\176\228\184\131\228\184\170\229\173\151"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(188.75, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(249, 206, 151),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_1",
      z = 1,
      parent = "image_my_rank",
      text = T("\229\142\134\229\143\178\230\156\128\233\171\152\231\131\173\229\138\155"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(440.25, 61)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 200, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_2",
      z = 0,
      parent = "image_my_rank",
      text = T("\233\128\154\229\133\179\230\151\182\233\151\180:"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(623.25, 61)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.1999944, h = 44.44999365},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_my_rank",
      res = "UI/alpha/1080P/nianmonster/nian_main_boss_heat.png",
      name = "heat_icon",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(397.25, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(249, 222, 151),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_heat",
      z = 1,
      parent = "image_my_rank",
      text = "21",
      size = 25
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(426.75, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 182),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "image_my_rank",
      text = "08:19:13",
      size = 24
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(573.25, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61.5, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_my_rank",
      res = "UI/alpha/1080P/toparena/rank/rank_1st.png",
      name = "image_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.25, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 223),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_3",
      z = 0,
      parent = "image_my_rank",
      text = T("\230\136\145\231\154\132\230\142\146\229\144\141"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.75, 53.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 223),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank",
      z = 0,
      parent = "label_3",
      text = "294",
      size = 28
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, -15)
    }
  }
}

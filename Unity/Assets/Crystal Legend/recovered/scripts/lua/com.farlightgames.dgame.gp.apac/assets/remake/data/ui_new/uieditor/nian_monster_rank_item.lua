ed.uieditor = ed.uieditor or {}
ed.uieditor.nian_monster_rank_item = {
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
      res = "UI/alpha/1080P/hades/hades_rank_bg2.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
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
      parent = "image_bg",
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
      parent = "image_bg",
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
      parent = "image_bg",
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
      parent = "image_bg",
      text = T("\229\142\134\229\143\178\230\156\128\233\171\152\231\131\173\229\138\155"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(440.25, 60)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.72, x = 0.72},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.32, h = 45.72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_main_boss_heat.png",
      name = "heat_icon",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(396.25, 33.5)
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
      parent = "image_bg",
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
      color = ccc3(255, 200, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_2",
      z = 0,
      parent = "image_bg",
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
      parent = "image_bg",
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
      fix_wh = {w = 187.5, h = 78},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61.5, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
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
      name = "label_rank",
      z = 0,
      parent = "image_bg",
      text = "294",
      size = 28
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 39.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMountRankItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 679.5, h = 80},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guildmount/rank/first_floor.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(364, 40)
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
      parent = "bg",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(226.75, 50.5)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "label_server_name",
      z = 0,
      parent = "bg",
      text = T("3\229\140\186\229\183\168\233\190\153\229\174\136\230\138\164"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(226.75, 27)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 188),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_des",
      z = 0,
      parent = "bg",
      text = T("\231\167\175\229\136\134:"),
      size = 23
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(548.75, 39)
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
      parent = "bg",
      name = "layer_head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(139.25, -1)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 30)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_score",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(553.75, 24.5)
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
      name = "label_guild_name",
      z = 0,
      parent = "bg",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(226.75, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 188),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_round_des",
      z = 0,
      parent = "bg",
      text = T("\231\172\17225\232\189\174"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(529.75, 39)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "label_round_percent",
      z = 0,
      parent = "bg",
      text = "65.23%",
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(615.75, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 25)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(29.25, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1.5, h = 74},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/rank/line.png",
      name = "ImageView_71312",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(467.25, 39)
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
      name = "label_boss_des",
      z = 0,
      parent = "bg",
      text = T("\230\140\145\230\136\152\232\174\176\229\189\149"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(227.25, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(155, 44)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "list_boss_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(289.75, 2)
    }
  }
}

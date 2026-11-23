ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMountRankListWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 966.5, h = 576.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guildmount/rank/background.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 309.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 735.5, h = 95},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/rank/myrank_floor.png",
      name = "bg_self",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(483.25, 35.75)
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
      parent = "bg_self",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(252.75, 56.5)
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
      name = "label_server_name",
      z = 0,
      parent = "bg_self",
      text = T("359\230\156\141"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(252.75, 33)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 186, 78),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_info",
      z = 0,
      parent = "bg",
      text = T("\230\180\187\229\138\168\231\187\147\230\157\159\229\144\142\239\188\140\230\160\185\230\141\174\230\142\146\229\144\141\229\143\145\230\148\190\228\184\170\228\186\186\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(488.25, 385.75)
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
      parent = "bg_self",
      text = T("\231\167\175\229\136\134:"),
      size = 23
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(576.75, 46.5)
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
      parent = "bg_self",
      name = "layer_head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(168.75, 8)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(694, 285)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "list_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(136.25, 81.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(116.5, 50)
    },
    t = "Layer",
    base = {
      parent = "bg_self",
      name = "panel_myrank",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(25.25, 23)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 33)
    },
    t = "Layer",
    base = {
      parent = "bg_self",
      name = "panel_myscore",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(585.75, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 300)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(881.75, 68.75)
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
      parent = "bg_self",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(252.75, 56.5)
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
      parent = "bg_self",
      text = "65.23%",
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(642.75, 48.5)
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
      name = "label_nobody",
      z = 0,
      parent = "bg",
      text = T("\232\191\152\230\178\161\230\156\137\233\152\159\233\149\191\228\184\138\230\166\156"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(483.25, 245.25)
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
      parent = "bg_self",
      text = T("\231\172\17225\232\189\174"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(556.75, 49)
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
      parent = "bg_self",
      name = "list_boss_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(314.75, 8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53, h = 56.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/rank/close_button.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(855.75, 454.25)
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
      parent = "bg_self",
      text = T("\230\140\145\230\136\152\232\174\176\229\189\149"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(253.75, 32)
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
      name = "panel_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(434.75, 417.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 50)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_boss_tips",
      z = 2,
      parent = "bg",
      res = "UI/alpha/1080P/common/com_new_3.png",
      capInsets = CCRectMake(10, 10, 4, 4)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355.25, 66.25)
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
      name = "label_boss_tips",
      z = 0,
      parent = "img_boss_tips",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 25)
    }
  }
}

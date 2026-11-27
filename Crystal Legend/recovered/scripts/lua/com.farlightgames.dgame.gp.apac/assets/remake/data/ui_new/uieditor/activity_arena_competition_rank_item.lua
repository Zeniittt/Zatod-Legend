ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_arena_competition_rank_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 533.5, h = 91.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_rank4+.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(270, 46)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 178),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank",
      z = 0,
      parent = "bg",
      text = "28",
      size = 35
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.75, 48.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 64.35, h = 34.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/rank/rank_3rd.png",
      name = "img_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.75, 48.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 82.5, h = 82.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_honor_king.png",
      name = "img_guild_frame",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(155.25, 49.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/pvp_guild/pvp_guild_scorebg1.png",
      name = "bg_score",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(426.75, 48.25)
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
      text = T("\232\135\170\229\183\177\231\154\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(201.25, 57.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 240, 136),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_chairman_name",
      z = 0,
      parent = "bg",
      text = T("\228\188\154\233\149\191\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(201.75, 37.25)
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
      name = "label_score_des",
      z = 0,
      parent = "bg_score",
      text = T("\231\171\158\230\138\128\229\156\186\230\128\187\231\167\175\229\136\134"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.25, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 25)
    },
    t = "Layer",
    base = {
      parent = "bg_score",
      name = "panel_score",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(17.25, 6.5)
    }
  }
}

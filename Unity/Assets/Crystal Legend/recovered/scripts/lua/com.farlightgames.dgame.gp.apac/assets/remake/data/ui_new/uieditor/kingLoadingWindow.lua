ed.uieditor = ed.uieditor or {}
ed.uieditor.kingLoadingWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/battle/battle_enter_bg.jpg",
      name = "image_bg",
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
      fix_scale = {y = 0.399999917, x = 0.399999917},
      flip = "",
      opacity = 255,
      fix_wh = {w = 78.799983649, h = 205.199957421},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_count_vs.png",
      name = "image_vs",
      z = 1
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
      scaleSize = CCSizeMake(750, 221)
    },
    t = "Layer",
    base = {
      name = "panel_hero_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(105, 313)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(750, 221)
    },
    t = "Layer",
    base = {
      name = "panel_hero_red",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(105, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 595, h = 74.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/battle/battle_enter_b_bg.png",
      name = "player_info_bg_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(192, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 595, h = 74.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/battle/battle_enter_r_bg.png",
      name = "player_info_bg_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(768.5, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 251.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_info_bg_blue",
      res = "UI/alpha/1080P/newkingspvp/battle/battle_player_name_bg.png",
      name = "player_name_bg_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(418.5, 53.75)
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
      name = "label_guild_tips_blue",
      z = 0,
      parent = "player_info_bg_blue",
      text = T("\229\133\172\228\188\154\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(345.5, 31.75)
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
      name = "label_server_tips_blue",
      z = 0,
      parent = "player_info_bg_blue",
      text = T("\230\156\141\229\138\161\229\153\168\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(345.5, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 209, 130),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guild_name_blue",
      z = 0,
      parent = "player_info_bg_blue",
      text = T("\229\133\172\228\188\154\229\144\141\231\167\176"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(396.5, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 209, 130),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_name_blue",
      z = 0,
      parent = "player_info_bg_blue",
      text = T("\230\156\141\229\138\161\229\153\168\229\144\141\231\167\176"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(411, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "player_info_bg_red",
      name = "panel_head_red",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(264.5, 2.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "player_info_bg_blue",
      name = "panel_head_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(261, 2.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 209, 130),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_name_red",
      z = 0,
      parent = "player_info_bg_red",
      text = T("\230\156\141\229\138\161\229\153\168\229\144\141\231\167\176"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(249.5, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 209, 130),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guild_name_red",
      z = 0,
      parent = "player_info_bg_red",
      text = T("\229\133\172\228\188\154\229\133\172\228\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(249.5, 31.75)
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
      name = "label_server_tips_red",
      z = 0,
      parent = "player_info_bg_red",
      text = T("\230\156\141\229\138\161\229\153\168\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(119, 14.25)
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
      name = "label_guild_tips_red",
      z = 0,
      parent = "player_info_bg_red",
      text = T("\229\133\172\228\188\154\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(182.5, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 251.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "player_info_bg_red",
      res = "UI/alpha/1080P/newkingspvp/battle/battle_player_name_bg.png",
      name = "panel_name_bg_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(176.5, 53.25)
    }
  }
}

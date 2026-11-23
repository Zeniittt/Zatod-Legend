ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashBattleInfoWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 703, h = 445.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/background.png",
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
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.7999946, h = 38.4999945},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(695, 436.75)
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
      name = "ImageView_102",
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
      fix_wh = {w = 29.5, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/icon_midroad.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(289.5, 419.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 221, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 0,
      parent = "bg",
      text = T("\228\184\173\232\183\175\230\136\152\230\150\151\229\189\162\229\188\143"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(368.5, 420.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 47.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_unselected.png",
      name = "tab2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(754, 280.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 111.5, h = 47.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_selected.png",
      name = "tab2_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(758.5, 280.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 47.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_unselected.png",
      name = "tab1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(754, 341.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 111.5, h = 47.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/tab_selected.png",
      name = "tab1_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(759, 341.75)
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
      name = "label_tab2",
      z = 0,
      parent = "tab2",
      text = T("\229\142\134\229\143\178\230\175\148\232\181\155"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(691, 285)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(6.5, 7.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(700, 95)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_2189",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1.5, 294.25)
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
      name = "label_tab2_selected",
      z = 0,
      parent = "tab2_selected",
      text = T("\229\142\134\229\143\178\230\175\148\232\181\155"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.75, 24.25)
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
      name = "label_tab1",
      z = 0,
      parent = "tab1",
      text = T("\229\189\147\229\137\141\230\175\148\232\181\155"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 24.25)
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
      name = "label_tab1_selected",
      z = 0,
      parent = "tab1_selected",
      text = T("\229\189\147\229\137\141\230\175\148\232\181\155"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.75, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 351, h = 96},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_2189",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/nature_guildfloor.png",
      name = "left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174.5, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 353, h = 92},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_2189",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/dark_guildfloor.png",
      name = "right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(526, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 188, h = 114},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_2189",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/icon_vs.png",
      name = "icon_vs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(349.5, 50)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(182, 230, 192),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "camp1",
      z = 0,
      parent = "left",
      text = T("\230\136\145\230\150\185"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.5, 48)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "left",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_normal.png",
      name = "avatar_camp1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264.5, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 228, 123),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "camp1_teams",
      z = 0,
      parent = "left",
      text = T("\229\137\169\228\189\153\233\152\159\228\188\141:185/240"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(225.5, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 196, 188),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name_camp1",
      z = 0,
      parent = "left",
      text = T("\229\133\172\228\188\154\229\144\141\229\133\173\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(225.5, 56)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 196, 188),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "camp2",
      z = 0,
      parent = "right",
      text = T("\230\149\140\230\150\185"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "right",
      res = "UI/alpha/1080P/guild/avatar_frame/guild_avatar_frame_normal.png",
      name = "avatar_camp2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86, 47)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 228, 123),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "camp2_teams",
      z = 0,
      parent = "right",
      text = T("\229\137\169\228\189\153\233\152\159\228\188\141:185/240"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(128, 36.5)
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
      name = "name_camp2",
      z = 0,
      parent = "right",
      text = T("\229\133\172\228\188\154\229\144\141\229\133\173\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(128, 57)
    }
  }
}

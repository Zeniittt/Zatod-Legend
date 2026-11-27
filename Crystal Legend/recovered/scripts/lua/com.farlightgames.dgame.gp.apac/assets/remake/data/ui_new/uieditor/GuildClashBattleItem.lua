ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashBattleItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(700, 42.5)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 360.5, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/nature_winrole.png",
      name = "camp1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 360, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/enemy_dark_winrole.png",
      name = "camp2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(520, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/icon_retract.png",
      name = "open",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(667, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 700, h = 57},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/afterpull_floor.png",
      name = "bg_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(351, -28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 26},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/icon_lose.png",
      name = "icon_result",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(349.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name_camp2",
      z = 0,
      parent = "camp2",
      text = "Text Label",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name_camp1",
      z = 0,
      parent = "camp1",
      text = "Text Label",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180.25, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.65, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/crusade/btn_replay.png",
      name = "btn_replay",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 31.5)
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
      name = "label_replay",
      z = 0,
      parent = "bg_bottom",
      text = T("\232\167\130\230\136\152"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_6.png",
      name = "camp1_hero2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(223, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_6.png",
      name = "camp1_hero3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_6.png",
      name = "camp1_hero4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_6.png",
      name = "camp1_hero5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_6.png",
      name = "camp1_hero1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(278, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_6.png",
      name = "camp2_hero1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(422, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_6.png",
      name = "camp2_hero2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_6.png",
      name = "camp2_hero3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(532, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "xy",
      opacity = 255,
      fix_wh = {w = 360, h = 41},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "camp2",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/role_mask.png",
      name = "camp2_mask",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 360, h = 41},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "camp1",
      res = "UI/alpha/1080P/guild/guild_clash_fightshow/role_mask.png",
      name = "camp1_mask",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180.25, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_6.png",
      name = "camp2_hero4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(587, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_bottom",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_6.png",
      name = "camp2_hero5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(642, 26.5)
    }
  }
}

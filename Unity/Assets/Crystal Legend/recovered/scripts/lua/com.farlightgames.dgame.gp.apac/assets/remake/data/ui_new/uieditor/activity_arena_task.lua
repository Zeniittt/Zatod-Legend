ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_arena_task = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "arena_reward",
      z = 0
    },
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
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "arena_reward",
      res = "UI/alpha/1080P/activity/pvptask/pvptask_bg.jpg",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(491, 310)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "task_list",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(570, 180.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(410, 80)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "title_panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(619.5, 496)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 508.5, h = 445.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/pvptask/pvptask_icon_frame.png",
      name = "card_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(444, 356.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230, h = 230},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "card_bg",
      res = "UI/alpha/1080P/activity/pvptask/pvptask_father_icon.png",
      name = "act_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(249.25, 252.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 250, 214),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "act_name",
      z = 0,
      parent = "card_bg",
      text = T("\229\129\135\233\157\162\231\139\130\230\172\162"),
      size = 32
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(247.25, 130.25)
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
      parent = "card_bg",
      res = "UI/alpha/1080P/dungeon/dungeon_countdown.png",
      name = "ImageView_70094",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(158.25, 80.75)
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
      name = "left_time",
      z = 0,
      parent = "card_bg",
      text = T("\229\137\169\228\189\153\230\151\182\233\151\180: 10\229\164\16910\229\176\143\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(261.25, 81.25)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_real_arena_legend_equip = {
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
      res = "UI/alpha/1080P/activity/realarena_reward/bg.jpg",
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
      scaleSize = CCSizeMake(455, 323)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "task_list",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(605, 172.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 630, h = 445.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/realarena_reward/icon_frame.png",
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
      position = ccp(322, 48.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 207, h = 140},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/legendactivity/art1.png",
      name = "image_title_fire",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(672, 566.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 240, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tips",
      z = 0,
      parent = "image_bg",
      text = T("\229\133\136\233\148\139\230\156\141\228\184\147\229\177\158\230\180\187\229\138\168"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(841.5, 508)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 277.5, h = 75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "card_bg",
      res = "UI/alpha/1080P/activity/legendactivity/buff_board3.png",
      name = "image_tips_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(315, 98.75)
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
      position = ccp(219.5, 47.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 264, h = 184.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_title_fire",
      res = "UI/alpha/1080P/activity/legendactivity/art2.png",
      name = "ImageView_24139",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103.5, 70)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 292, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_tips_bg",
      res = "UI/alpha/1080P/activity/legendactivity/buff_board1.png",
      name = "ImageView_23963",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(138.75, 63)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(210, 40)
    },
    t = "Layer",
    base = {
      parent = "image_tips_bg",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(31.25, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_23963",
      res = "UI/alpha/1080P/activity/legendactivity/buff_board2.png",
      name = "ImageView_23965",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(213, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 205),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_act_name",
      z = 0,
      parent = "ImageView_23963",
      text = T("\228\188\160\229\165\135\232\175\184\231\142\139\228\185\139\229\156\176"),
      size = 19
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(178.5, 17.25)
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
      name = "Label_23967",
      z = 0,
      parent = "ImageView_23965",
      text = T("\231\148\159\230\149\136\228\184\173"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.25, 10)
    }
  }
}

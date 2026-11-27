ed.uieditor = ed.uieditor or {}
ed.uieditor.arenaRewardWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(572.5, 386)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(40, 40, 0.5, 200),
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478.5, 247.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(572.5, 390)
    },
    t = "Scale9Sprite",
    base = {
      name = "main_frame",
      z = 2,
      parent = "bg",
      res = "UI/alpha/1080P/scale9/frame_common1.png",
      capInsets = CCRectMake(13, 103.5, 50, 107)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(286.25, 193)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(555.5, 315.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(8.25, 6)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(558.75, 372)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 561, h = 54.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pvp/ornament_bg.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(286.25, 354.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 561, h = 54.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pvp/ornament_bg.png",
      name = "bg_title1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(286.25, 354.5)
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
      name = "ImageView_2427",
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
      fix_scale = {y = 1, x = -1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = -64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "btn_times",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-31.25, 213)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_times",
      z = 10,
      parent = "bg",
      text = T("\230\140\145\230\136\152\229\165\150\229\138\177"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-30.75, 213)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 201.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/skilltower/bg_title.png",
      name = "bg_titlename",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109, 22.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(567.5, 6)
    },
    t = "Scale9Sprite",
    base = {
      name = "icon_line",
      z = 0,
      parent = "bg_title",
      res = "UI/alpha/1080P/common/cuparena_line.png",
      capInsets = CCRectMake(11.5, 11.5, 23, 23)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(280.5, -0.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = -64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "btn_reward",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-31.25, 302.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 203),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6843",
      z = 0,
      parent = "bg_title",
      text = T("\230\175\143\230\151\16521\231\130\185\231\187\147\231\174\151\229\165\150\229\138\177"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(555, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reward",
      z = 10,
      parent = "bg",
      text = T("\230\142\146\229\144\141\229\165\150\229\138\177"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-31.25, 302.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(567.5, 6)
    },
    t = "Scale9Sprite",
    base = {
      name = "icon_line",
      z = 0,
      parent = "bg_title1",
      res = "UI/alpha/1080P/common/cuparena_line.png",
      capInsets = CCRectMake(11.5, 11.5, 23, 23)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(280.5, -0.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 203),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6844",
      z = 0,
      parent = "bg_title1",
      text = T("\230\175\143\230\151\165\230\140\145\230\136\152\230\172\161\230\149\176\229\165\150\229\138\177"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(554, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 141),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title1",
      z = 0,
      parent = "bg_title1",
      text = T("\230\140\145\230\136\152\230\172\161\230\149\176\229\165\150\229\138\177"),
      size = 24
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 203),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "bg_titlename",
      text = T("\229\189\147\229\137\141\231\171\158\230\138\128\229\156\186\230\142\146\229\144\141"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8.75, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_titlename",
      res = "UI/alpha/1080P/crusade/number/crusade_1.png",
      name = "rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(155.25, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 141),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_titlename",
      z = 0,
      parent = "bg_titlename",
      text = T("\230\142\146\229\144\141\229\165\150\229\138\177"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8.75, 33.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 72, h = 77},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_times",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
      name = "btn_times_selected",
      z = 3
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(64.75, 36.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 72, h = 77},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reward",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
      name = "btn_reward_selected",
      z = 3
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(64.75, 36.25)
    }
  }
}

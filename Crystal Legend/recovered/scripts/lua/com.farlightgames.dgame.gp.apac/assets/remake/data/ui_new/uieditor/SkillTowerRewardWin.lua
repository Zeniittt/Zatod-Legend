ed.uieditor = ed.uieditor or {}
ed.uieditor.SkillTowerRewardWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(579.5, 400)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 50, 350),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 280)
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
      res = "UI/alpha/1080P/skilltower/bg_reward_up.png",
      name = "bg_top",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(289.75, 366)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 201.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_top",
      res = "UI/alpha/1080P/skilltower/bg_title.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(107.5, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(203, 255, 240),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_star",
      z = 0,
      parent = "bg_title",
      text = T("\229\189\147\229\137\141\230\148\182\233\155\134\230\152\159\230\152\159\230\149\176"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(9.75, 10.75)
    }
  },
  {
    config = {
      rotation = 90,
      fix_scale = {y = 1.21, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 7.5, h = 563.255},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_top",
      res = "UI/alpha/1080P/mail/mail_lin.png",
      name = "icon_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(282, 0.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(203, 255, 240),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_star_num",
      z = 0,
      parent = "bg_title",
      text = "11/200",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(136.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.1999973, h = 16.49999725},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "icon_star",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(125.25, 10.75)
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
      position = ccp(561.75, 385.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(548, 315)
    },
    t = "Layer",
    base = {
      parent = "bg_top",
      name = "layer_reward_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(6.5, -318.75)
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
      name = "icon_back",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(137, 253, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "bg_title",
      text = T("\233\155\134\230\152\159\229\165\150\229\138\177"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(10.25, 34.75)
    }
  }
}

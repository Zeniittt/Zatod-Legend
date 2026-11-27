ed.uieditor = ed.uieditor or {}
ed.uieditor.dayAwardsScene = {
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
      res = "UI/alpha/1080P/fireforge/DayAwards/background.jpg",
      name = "ImageView_bg",
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
      scaleSize = CCSizeMake(502, 279.5)
    },
    t = "Layer",
    base = {name = "Panel_left", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(305.5, 42)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(147, 279.5)
    },
    t = "Layer",
    base = {
      name = "Panel_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(809.5, 42)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(647, 105)
    },
    t = "Layer",
    base = {name = "Panel_top", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(305.5, 322.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 268.5, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/campaign/worldmap/worldmap_title_bg.png",
      name = "img_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105, 580)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 687.5, h = 176.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bg",
      res = "UI/alpha/1080P/fireforge/DayAwards/art1.png",
      name = "ImageView_304",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(726.5, 597)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 258.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bg",
      res = "UI/alpha/1080P/activity/seven_day/seven_day_time_bg.png",
      name = "ImageView_305",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(203, 139.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(552, 100)
    },
    t = "Layer",
    base = {
      parent = "Panel_top",
      name = "panel_line_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(95.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 142},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_top",
      res = "UI/alpha/1080P/fireforge/DayAwards/lastreward.png",
      name = "hero_icon_bg",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(603.5, 67)
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
      parent = "img_title_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "img_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-31.25, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_title_bg",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "img_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212.75, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 234),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_306",
      z = 0,
      parent = "ImageView_305",
      text = T("\229\137\169\228\189\153\230\151\182\233\151\180:"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85.75, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 215, 65),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_time",
      z = 0,
      parent = "ImageView_305",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(127.75, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_close",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "ImageView_313",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.5, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_315",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.75, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 258.5, h = 107.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bg",
      res = "UI/alpha/1080P/fireforge/DayAwards/only_left.png",
      name = "ImageView_2489",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(208.5, 488.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 98.5, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_top",
      res = "UI/alpha/1080P/fireforge/DayAwards/only_right.png",
      name = "ImageView_2488",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(603, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164.5, h = 100},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bg",
      res = "UI/alpha/1080P/fireforge/DayAwards/board_left.png",
      name = "ImageView_2590",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(208.5, 212)
    }
  }
}

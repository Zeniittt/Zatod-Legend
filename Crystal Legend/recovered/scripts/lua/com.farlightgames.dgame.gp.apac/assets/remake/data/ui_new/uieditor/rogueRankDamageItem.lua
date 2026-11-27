ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueRankDamageItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 730, h = 80},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/rank/rank_backboard_1.png",
      name = "image_bg",
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
      fix_wh = {w = 61.5, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/rank/rank_1st.png",
      name = "image_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 40)
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
      parent = "image_bg",
      name = "panel_head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(122, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1.5, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/rank/rank_line_1.png",
      name = "image_line_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(378.5, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1.5, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/rank/rank_line_1.png",
      name = "image_line_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(501, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_diff",
      z = 0,
      parent = "image_bg",
      text = T("\233\154\190\229\186\1664"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(413.5, 40)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/rank/rank_crisis_icon.png",
      name = "crisis_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(455.5, 40)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 92, 92),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_crisis_amount",
      z = 0,
      parent = "image_bg",
      text = "9",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(472, 40)
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
      name = "label_damage_tips",
      z = 0,
      parent = "image_bg",
      text = T("\229\141\149\229\156\186\230\156\128\233\171\152\232\190\147\229\135\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(571, 51)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage",
      z = 0,
      parent = "image_bg",
      text = "999999",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(570.5, 27)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_hero_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(658, 14)
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
      name = "label_rank",
      z = 0,
      parent = "image_bg",
      text = "4",
      size = 35
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 40)
    }
  }
}

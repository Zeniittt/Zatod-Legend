ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueRankFirstBloodItem = {
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
      res = "UI/alpha/1080P/rogue/rank/rank_firstblood_1.png",
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
      position = ccp(183, 0)
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
      position = ccp(452, 39.5)
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
      name = "label_diff",
      z = 0,
      parent = "image_bg",
      text = T("\233\154\190\229\186\166IV"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 40)
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
      position = ccp(96, 40)
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
      size = 22
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(113.5, 40)
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
      name = "label_time_tips",
      z = 0,
      parent = "image_bg",
      text = T("\229\135\187\230\157\128\230\151\182\233\151\180\239\188\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(598, 52)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 232, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/rank/rank_firstblood_3.png",
      name = "image_time_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(591, 27)
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
      name = "label_time",
      z = 0,
      parent = "image_time_bg",
      text = T("2024\229\185\18008\230\156\13608\230\151\165 00:00:00"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116, 12)
    }
  }
}

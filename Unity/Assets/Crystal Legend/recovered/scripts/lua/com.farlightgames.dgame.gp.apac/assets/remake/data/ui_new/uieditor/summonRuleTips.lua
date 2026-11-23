ed.uieditor = ed.uieditor or {}
ed.uieditor.summonRuleTips = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(600, 336)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 10),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "Image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 279.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(594, 286)
    },
    t = "Layer",
    base = {name = "panel_win", z = 2},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(183.5, 122.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(590, 290)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 10),
      res = "UI/alpha/1080P/common/main_vit_tips.png",
      name = "panel_clipping",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 264)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(594, 286)
    },
    t = "Layer",
    base = {
      name = "panel_win_touch",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(183.5, 122.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 350)
    },
    t = "Layer",
    base = {
      name = "panel_touch",
      z = 99
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(157, 105)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(575, 275)
    },
    t = "Layer",
    base = {
      parent = "panel_win",
      name = "page_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(10.5, 7.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Image_bg",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "ImageView_692",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205.5, 309.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(575, 275)
    },
    t = "Layer",
    base = {
      parent = "panel_win",
      name = "page_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(600, 7.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Image_bg",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "ImageView_692_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(403, 309)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_699",
      z = 0,
      parent = "Image_bg",
      text = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(301.5, 311.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 57.5, h = 49.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_touch",
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "arrow_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 177.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 49.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_touch",
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "arrow_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(623, 177.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 524.5, h = 219.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_1",
      res = "UI/alpha/1080P/summon/rule_tip_bg.png",
      name = "Image_tab_bj",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(285.5, 115.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 239),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "page_1_desc",
      z = 0,
      parent = "page_1",
      text = T("\231\142\169\229\174\182\228\189\191\231\148\168\229\143\172\229\148\164\229\136\184\239\188\140\229\143\175\229\156\168\229\143\172\229\148\164\230\179\149\233\152\181\229\184\184\233\169\187\229\143\172\229\148\164\230\137\128\230\156\137\232\139\177\233\155\132\229\146\140\232\139\177\233\155\132\231\129\181\233\173\130\231\159\179\227\128\130\230\166\130\231\142\135\229\133\172\231\164\186\229\166\130\228\184\139:"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20.5, 251)
    }
  }
}

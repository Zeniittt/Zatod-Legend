ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_runcricket_page = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "page_lay", z = 0},
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
      parent = "page_lay",
      res = "UI/alpha/1080P/chesscard/sevenday/bg.jpg",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 910, h = 81.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/chesscard/sevenday/decoration_4.png",
      name = "progress_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(484, 445)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 910, h = 81.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/chesscard/sevenday/decoration_5.png",
      name = "progress_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(484, 445)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105.5, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/chesscard/sevenday/time_bg.png",
      name = "ImageView_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(257.5, 418.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 208.5, h = 102.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/chesscard/sevenday/title.png",
      name = "ImageView_2668",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(324.5, 439.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 301, h = 396},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/chesscard/sevenday/banner.png",
      name = "ImageView_card",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(326.5, 246)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 529, h = 335},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/chesscard/sevenday/item_bg.png",
      name = "ImageView_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(692.5, 225)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.5, h = 15.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "ImageView_time",
      res = "UI/alpha/1080P/chesscard/sevenday/time.png",
      name = "ImageView_open",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.75, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(236, 252, 254),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_time",
      z = 0,
      parent = "ImageView_time",
      text = "",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.25, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.5, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_time",
      res = "UI/alpha/1080P/chesscard/sevenday/time.png",
      name = "ImageView_end",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(336, 294.5)
    },
    t = "Layer",
    base = {
      parent = "ImageView_right",
      name = "Panel_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(25.5, 14)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 294.5)
    },
    t = "Layer",
    base = {
      parent = "ImageView_right",
      name = "Panel_btns",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(355, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 529, h = 335},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "ImageView_right",
      res = "UI/alpha/1080P/chesscard/sevenday/shader.png",
      name = "ImageView_shader",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264.5, 167.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 137.7, h = 49.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_card",
      res = "UI/alpha/1080P/chesscard/match/match_button_2.png",
      name = "ImageView_goto",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(236, 252, 254),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2663",
      z = 0,
      parent = "ImageView_open",
      text = T("\229\188\128\229\144\175\230\151\182\233\151\180"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.25, 7.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(236, 252, 254),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2663",
      z = 0,
      parent = "ImageView_end",
      text = T("\229\137\169\228\189\153"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31.75, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_shader",
      res = "UI/alpha/1080P/chesscard/sevenday/lock_1.png",
      name = "ImageView_2675",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(191.5, 169)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 247, 230),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_shader",
      z = 0,
      parent = "ImageView_shader",
      text = T("\230\180\187\229\138\168\230\152\142\229\164\1695:00\229\144\142\229\188\128\229\144\175"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(272.5, 168.5)
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
      name = "Label_2678",
      z = 0,
      parent = "ImageView_goto",
      text = T("\229\137\141\229\190\128"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81, 30.5)
    }
  }
}

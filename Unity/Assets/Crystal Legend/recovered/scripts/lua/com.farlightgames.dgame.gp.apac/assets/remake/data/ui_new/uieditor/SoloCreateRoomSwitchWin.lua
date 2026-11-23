ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloCreateRoomSwitchWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(530, 305)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 25, 21.5, 21.5),
      res = "UI/alpha/1080P/chesscard/match/match_bg1.png",
      name = "bg",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 235, 194),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_title_slr",
      z = 1,
      parent = "bg",
      text = T("\231\187\132\233\152\159\230\168\161\229\188\143"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265.5, 276.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 52, h = 52},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/closed.png",
      name = "btn_close_slr",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(521.5, 296.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 120.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/mode_3.png",
      name = "bg_mode1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122, 152.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 104.399993736, h = 25.99999844},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/mode_bg.png",
      name = "img_title_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122, 74)
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
      parent = "btn_close_slr",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_2357",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 480, h = 43.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/invitefriend_bg.png",
      name = "ImageView_8964",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264, 277.5)
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
      name = "lab_title_1",
      z = 1,
      parent = "img_title_1",
      text = T("\231\187\132\233\152\159\228\188\145\233\151\178"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.25, 16.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80.5, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_8964",
      res = "UI/alpha/1080P/chesscard/match/line.png",
      name = "ImageView_8965",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(178, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -80.5, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_8964",
      res = "UI/alpha/1080P/chesscard/match/line.png",
      name = "ImageView_8965_Copy0",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(465.5, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 120.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/mode_1.png",
      name = "bg_mode2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265, 152.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120.5, h = 120.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/mode_2.png",
      name = "bg_mode3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(408.5, 152.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 104.399993736, h = 25.99999844},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/mode_bg.png",
      name = "img_title_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265, 74)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 104.399993736, h = 25.99999844},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/mode_bg.png",
      name = "img_title_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(408.5, 74)
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
      name = "lab_title_2",
      z = 1,
      parent = "img_title_2",
      text = T("\231\187\132\233\152\159\229\164\169\230\162\175"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.25, 16.25)
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
      name = "lab_title_3",
      z = 1,
      parent = "img_title_3",
      text = T("\231\187\132\233\152\159\228\186\186\230\156\186"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.25, 16.25)
    }
  }
}

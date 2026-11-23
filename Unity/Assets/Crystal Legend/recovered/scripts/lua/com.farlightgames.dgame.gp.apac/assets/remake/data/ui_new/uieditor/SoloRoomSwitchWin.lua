ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloRoomSwitchWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(504, 300)
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
      text = T("\233\128\137\230\139\169\230\168\161\229\188\143"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(252.5, 274)
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
      position = ccp(498.5, 291)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 156},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/selectmode.png",
      name = "bg_mode1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145, 153.5)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 156},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/selectmode.png",
      name = "bg_mode2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(362, 153.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 130.5, h = 32.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_mode1",
      res = "UI/alpha/1080P/chess/mode/mode_text_bg.png",
      name = "img_title_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.5, -21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 130.5, h = 32.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_mode2",
      res = "UI/alpha/1080P/chess/mode/mode_text_bg.png",
      name = "img_title_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.5, -21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 94, h = 82},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/chesscard/match/team_icon.png",
      name = "btn_createroom",
      z = 0,
      parent = "img_title_1",
      text = "",
      press = "UI/alpha/1080P/chesscard/match/team_icon.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.25, 114.75)
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
      text = T("\229\136\155\229\187\186\233\152\159\228\188\141"),
      size = 20
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
      fix_wh = {w = 81.5, h = 80},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/chesscard/match/match_icon.png",
      name = "btn_joinroom",
      z = 0,
      parent = "img_title_2",
      text = "",
      press = "UI/alpha/1080P/chesscard/match/match_icon.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.25, 113.75)
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
      text = T("\229\138\160\229\133\165\233\152\159\228\188\141"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.25, 16.25)
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
      position = ccp(250.5, 272)
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
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/line.png",
      name = "ImageView_8965",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(144, 274)
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
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/match/line.png",
      name = "ImageView_8965_Copy0",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(360, 274)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessRoomSwitchWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(682.5, 323)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(150, 150, 300, 50),
      res = "UI/alpha/1080P/chess/mode/Invite_bg_2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 303)
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
      position = ccp(341.75, 298)
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
      name = "btn_close_slr",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(672.25, 315.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178, h = 160.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/mode/texture.png",
      name = "bg_mode1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(126.25, 168)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178, h = 160.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/mode/texture.png",
      name = "bg_mode2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(341.25, 168)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178, h = 160.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/mode/texture.png",
      name = "bg_mode3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(556.25, 168.5)
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
      position = ccp(89, -19.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 137.5, h = 137.5},
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
      normal = "UI/alpha/1080P/chess/mode/createroom.png",
      name = "btn_createroom",
      z = 0,
      parent = "img_title_1",
      text = "",
      press = "UI/alpha/1080P/chess/mode/createroom.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.25, 114.25)
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
      position = ccp(89, -19.25)
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
      flip = "",
      opacity = 255,
      fix_wh = {w = 130.5, h = 32.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_mode3",
      res = "UI/alpha/1080P/chess/mode/mode_text_bg.png",
      name = "img_title_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89, -18.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 137.5, h = 137.5},
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
      normal = "UI/alpha/1080P/chess/mode/Joinroom.png",
      name = "btn_joinroom",
      z = 0,
      parent = "img_title_2",
      text = "",
      press = "UI/alpha/1080P/chess/mode/Joinroom.png",
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
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 137.5, h = 137.5},
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
      normal = "UI/alpha/1080P/chess/mode/match.png",
      name = "btn_matchroom",
      z = 0,
      parent = "img_title_3",
      text = "",
      press = "UI/alpha/1080P/chess/mode/match.png",
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
      name = "lab_title_3",
      z = 1,
      parent = "img_title_3",
      text = T("\232\135\170\231\148\177\229\140\185\233\133\141"),
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
      position = ccp(27, 27.5)
    }
  }
}

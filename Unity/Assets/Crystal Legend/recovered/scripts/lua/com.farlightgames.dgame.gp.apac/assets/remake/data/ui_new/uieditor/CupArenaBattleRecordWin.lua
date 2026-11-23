ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaBattleRecordWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(800, 478.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(30, 130, 30, 130),
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_record_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(470, 266.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 39.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_quit_button.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(785, 464.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(768, 388)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_audition",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(14.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 93.5, h = 62.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/cuparena_record_tab_1.png",
      name = "btn_audition",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(842, 369.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 93.5, h = 62.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/cuparena_record_tab_1.png",
      name = "btn_knockout",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(842, 286.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 93.5, h = 62.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_audition",
      res = "UI/alpha/1080P/cuparena/cuparena_record_tab_2.png",
      name = "btn_audition_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.75, 31.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(205, 179, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_audition",
      z = 0,
      parent = "btn_audition",
      text = T("\230\181\183\233\128\137\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.75, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(205, 179, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_knockout",
      z = 0,
      parent = "btn_knockout",
      text = T("\229\183\133\229\179\176\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.75, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 93.5, h = 62.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_knockout",
      res = "UI/alpha/1080P/cuparena/cuparena_record_tab_2.png",
      name = "btn_knockout_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.75, 31.25)
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
      name = "label_audition_selected",
      z = 0,
      parent = "btn_audition_selected",
      text = T("\230\181\183\233\128\137\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.75, 31.75)
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
      name = "label_knockout_selected",
      z = 0,
      parent = "btn_knockout_selected",
      text = T("\229\183\133\229\179\176\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.75, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(768, 388)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_knockout",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(14.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 174, h = 145},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_record_empty.png",
      name = "img_empty",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(409, 250.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_empty",
      z = 0,
      parent = "img_empty",
      text = T("\230\154\130\230\151\160\230\140\145\230\136\152\232\174\176\229\189\149"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 14.5)
    }
  }
}

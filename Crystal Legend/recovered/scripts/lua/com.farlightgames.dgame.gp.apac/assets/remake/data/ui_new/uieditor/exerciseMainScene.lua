ed.uieditor = ed.uieditor or {}
ed.uieditor.exerciseMainScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210, 497.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 127, h = 37.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "title_bg",
      res = "UI/alpha/1080P/pool/pool_title.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.25, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 26.5, h = 26.5},
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
      normal = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "rule_btn",
      z = 0,
      parent = "title_bg",
      text = "",
      press = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(171.75, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 960, h = 85},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pool/pool_frame_2.png",
      name = "bottom_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(480, 0)
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
      parent = "rule_btn",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 278, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pool/pool_challenge_times.png",
      name = "challenge_times_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(702.5, 497)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 98.5, h = 34},
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
      normal = "UI/alpha/1080P/pool/pool_preview_button.png",
      name = "preview_btn",
      z = 2,
      text = "",
      press = "UI/alpha/1080P/pool/pool_preview_button.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(866, 496)
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
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      size = 20,
      text = T("\230\156\172\230\151\165\232\175\149\231\130\188"),
      name = "today_label",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 452.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "times",
      z = 0,
      parent = "challenge_times_bg",
      text = T("\228\187\138\230\151\165\229\137\169\228\189\153\230\140\145\230\136\152\230\172\161\230\149\176\239\188\1545/5"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(870, 354)
    },
    t = "Layer",
    base = {name = "listLayer", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(43, 44),
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
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "close_btn",
      z = 3,
      capInsets = CCRectMake(10, 20, 30, 15),
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 495)
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
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "preview_label",
      z = 0,
      parent = "preview_btn",
      text = T("\230\156\170\230\157\165\233\162\132\232\168\128"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.25, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29.6, h = 28.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "close_btn",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(141, 55)
    },
    t = "Scale9Sprite",
    base = {
      name = "title_light",
      z = 0,
      parent = "title_bg",
      res = "UI/alpha/1080P/common/title_light.png",
      capInsets = CCRectMake(16.5, 18, 16.5, 18)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.25, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 218),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "title_light",
      text = T("\232\139\177\233\155\132\232\175\149\231\130\188"),
      size = 29
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70.5, 27.5)
    }
  }
}

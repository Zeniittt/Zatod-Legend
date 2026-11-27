ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaGambleScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 219, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_time_bg.png",
      name = "bg_progress",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(473, 501)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(809, 410)
    },
    t = "Layer",
    base = {name = "panel_main", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(75.5, 22)
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
      name = "label_time_des",
      z = 0,
      parent = "bg_progress",
      text = T("\229\137\169\228\189\15314\229\164\1694\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132, 16)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(248.5, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 0, 40, 35.5),
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140.5, 503)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57, h = 354},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_dec.png",
      name = "bg_line_right_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(972.5, 451)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57, h = 354},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_dec.png",
      name = "bg_line_right_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(915.5, 526.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57, h = 354},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_dec.png",
      name = "bg_line_left_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 526)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57, h = 354},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_dec.png",
      name = "bg_line_left_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-14, 450.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_progress",
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_time_icon.png",
      name = "img_time_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(202, 196, 151),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time_out",
      z = 0,
      parent = "bg_progress",
      text = T("\230\156\172\230\151\165\231\171\158\231\140\156\229\183\178\231\187\147\230\157\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109.5, 16)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 204,
      visible = true,
      scaleSize = CCSizeMake(108.5, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(30, 10, 5, 9.5),
      res = "UI/alpha/1080P/lottery/lottery_meat_bg.png",
      name = "bg_gamble_val",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(952.5, 505)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 201, h = 128.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/knockout/gamble/gamble_empty.png",
      name = "img_empty",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 284)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_gamble_val",
      res = "UI/alpha/1080P/common/goldicon_small.png",
      name = "img_gamble_val",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 16.25)
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
      name = "label_gamble_val",
      z = 0,
      parent = "bg_gamble_val",
      text = "9999",
      size = 19
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(101.5, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(218.75, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.4, h = 59.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_line_right_1",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.5, 69)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(180, 151, 92),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_empty",
      z = 0,
      parent = "img_empty",
      text = T("\230\130\168\230\156\170\229\143\130\229\138\160\230\156\172\229\156\186\231\171\158\231\140\156"),
      size = 36
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100.5, -18.25)
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
      parent = "btn_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "icon_rule",
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
      fix_scale = {y = 1.111, x = 1.111},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.106, h = 41.6625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_record",
      res = "UI/alpha/1080P/pvp/record.png",
      name = "icon_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.111, x = 1.111},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_record",
      z = 0,
      parent = "btn_record",
      text = T("\232\174\176\229\189\149"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 5)
    }
  }
}

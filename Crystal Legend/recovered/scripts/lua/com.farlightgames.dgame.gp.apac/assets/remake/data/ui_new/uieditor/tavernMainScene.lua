ed.uieditor = ed.uieditor or {}
ed.uieditor.tavernMainScene = {
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
      res = "UI/alpha/1080P/tavern/tavern_bg.jpg",
      name = "image_bg",
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
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "image_title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88, 507.5)
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
      parent = "image_title_bg",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(191.75, 17.75)
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
      name = "ImageView_27775",
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
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 83.65, h = 78.4},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/tavern/tavern_next_button.png",
      name = "image_arrow_left",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-13, 310)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 83.65, h = 78.4},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/tavern/tavern_next_button.png",
      name = "image_arrow_right",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(959.5, 310)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 423},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/tavern/tavern_counter.png",
      name = "image_desk",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 121)
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
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_toke_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1019.5, 510)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 181, 121),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 15,
      text = T("\239\188\136\230\156\172\229\145\168\232\142\183\229\143\150\228\184\138\233\153\144\239\188\154100/100\239\188\137"),
      name = "label_weekly_amount",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(1031, 475.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(119.5, 28)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(4, 9, 4, 9),
      res = "UI/alpha/1080P/main/main_status_number_bg.png",
      name = "image_token_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(939, 510)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 250)
    },
    t = "Layer",
    base = {
      name = "panel_puppet",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(390, 137.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(282, 104.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(100, 25, 10, 25),
      res = "UI/alpha/1080P/tavern/tavern_talk.png",
      name = "image_bubble",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(528, 407)
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
      parent = "btn_toke_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_27775",
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
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_token_bg",
      res = "UI/alpha/1080P/tavern/tavern_token.png",
      name = "image_token_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.75, 14.5)
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
      name = "label_token_amount",
      z = 0,
      parent = "image_token_bg",
      text = "1234",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(80.75, 14)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1170, 325)
    },
    t = "Layer",
    base = {
      parent = "image_desk",
      name = "slide_arena",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 90.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "image_desk",
      name = "pos_left",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(365.5, 188.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "image_desk",
      name = "pos_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(802, 188.5)
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
      name = "label_bubble_1",
      z = 0,
      parent = "image_bubble",
      text = T("\230\172\162\232\191\142\230\157\165\229\136\176\233\133\146\233\166\134\239\188\140\230\131\179\229\150\157\231\130\185\228\187\128\228\185\136\239\188\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141, 75.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 136, 206),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_bubble_2",
      z = 0,
      parent = "image_bubble",
      text = T("\231\130\185\229\135\187\230\136\145\229\143\175\228\187\165\232\180\173\228\185\176\229\149\134\229\147\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141, 49.75)
    }
  }
}

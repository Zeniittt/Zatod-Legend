ed.uieditor = ed.uieditor or {}
ed.uieditor.DreamlandGiftWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 781.5, h = 474.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/impulsegift/impulsegift_dreamland/bg1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(447.5, 289)
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
      parent = "bg",
      name = "panel_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(297.75, 155.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 425)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_touch",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(72.75, 0.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 289)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(516.25, 58.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 50)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_worth",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(518.25, 380.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/impulsegift_dreamland/purchase_button1.png",
      name = "btn_buy",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(299.75, 97.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/impulsegift_dreamland/purchase_button2.png",
      name = "btn_buy_disable",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(299.75, 96.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 52.5, h = 53},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/impulsegift_dreamland/close.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(758.75, 416.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 248, h = 43},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/impulsegift_dreamland/bg2.png",
      name = "img_grass",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(632.75, 54.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 88, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/impulsegift_dreamland/page_button.png",
      name = "btn_last",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(155.25, 99.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/impulsegift_dreamland/page_button.png",
      name = "btn_next",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(446.25, 99.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(355, 50)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(127.75, 375.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 20)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_buy_des",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(128.75, 353.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_worth_des",
      z = 0,
      parent = "bg",
      text = T("\232\182\133\229\128\188\233\153\144\230\151\182\231\164\188\229\140\133"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(614.75, 365.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 74, h = 76.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/impulsegift_dreamland/text_bg.png",
      name = "img_limit",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154.25, 313.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 40)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_page_dot",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(381.75, -14.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 206, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/impulsegift_dreamland/remainingtime_text_bg.png",
      name = "img_left_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(299.75, 138.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(107, 64, 9),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time",
      z = 0,
      parent = "img_left_time",
      text = T("\229\137\169\228\189\1531\229\164\1693\229\176\143\230\151\18244\229\136\134"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111.5, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_buy",
      res = "UI/alpha/1080P/impulsegift/impulsegift_dreamland/lock.png",
      name = "img_buy_lock",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148.75, 44)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(62, 82, 14),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_last_des",
      z = 0,
      parent = "btn_last",
      text = T("\231\172\1722\230\156\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, 22.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(62, 82, 14),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_next_des",
      z = 0,
      parent = "btn_next",
      text = T("\231\172\1722\230\156\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32, 22.25)
    }
  },
  {
    config = {
      rotation = -14,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(252, 255, 146),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_limit",
      z = 0,
      parent = "img_limit",
      text = T("\233\153\144\232\180\173\228\184\128\230\172\161"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_left_time",
      res = "UI/alpha/1080P/impulsegift/impulsegift_dreamland/remainingtime.png",
      name = "icon_left_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.5, 10)
    }
  }
}

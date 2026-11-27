ed.uieditor = ed.uieditor or {}
ed.uieditor.EnjoyGiftWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 758.5, h = 499.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/impulsegift/bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(420, 296.5)
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
      position = ccp(68.75, -3.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(430, 180)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(264.75, 93.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 500, h = 200},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/time_limited.png",
      name = "img_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(500.75, 367.25)
    }
  },
  {
    config = {
      rotation = -1.5,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 254, 236),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time",
      z = 0,
      parent = "bg",
      text = T("\229\137\169\228\189\1533\229\164\16916\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(319.25, 297.75)
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
      position = ccp(397.75, -10.25)
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
      position = ccp(538.75, 288.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 200)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_gear",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(720.75, 75.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 213, h = 75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/purchase_button1.png",
      name = "btn_buy",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(439.25, 61.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 213, h = 75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/purchase_button2.png",
      name = "btn_buy_disable",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(439.25, 61.25)
    }
  },
  {
    config = {
      rotation = 180,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/slide.png",
      name = "btn_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175.75, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/slide.png",
      name = "btn_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(697.25, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.5, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/impulsegift/close.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(692.75, 401.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_buy",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "img_buy_diamond",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_buy_disable",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "img_disable_diamond",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_left",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "img_left_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.75, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_right",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "img_right_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.75, 27.75)
    }
  }
}

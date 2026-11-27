ed.uieditor = ed.uieditor or {}
ed.uieditor.RechargeGiftTicketLayer = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(7.81, 7.81)
    },
    t = "Layer",
    base = {name = "panel", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(171.88, 43.75)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg",
      z = 0,
      parent = "panel",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(10, 10, 19, 201.5)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(312.5, 458.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 1,
      visible = true,
      scaleSize = CCSizeMake(56.25, 39.06)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_switch_touch",
      z = 0,
      parent = "panel",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(11.72, 11.72, 70.31, 35.16)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(367.19, 440.63)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.46874390625, h = 30.46874390625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/gift_ticket_6.png",
      name = "img_ticket_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.84, 22.66)
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
      name = "label_ticket_1",
      z = 0,
      parent = "bg",
      text = "34",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(44.06, 22.66)
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
      name = "label_ticket_2",
      z = 0,
      parent = "bg",
      text = "34",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(44.06, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.46874390625, h = 30.46874390625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/gift_ticket_6.png",
      name = "img_ticket_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.84, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.46874390625, h = 30.46874390625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/gift_ticket_6.png",
      name = "img_ticket_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.84, 22.66)
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
      name = "label_ticket_3",
      z = 0,
      parent = "bg",
      text = "34",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(44.06, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.46874390625, h = 30.46874390625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/gift_ticket_6.png",
      name = "img_ticket_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.84, 22.66)
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
      name = "label_ticket_4",
      z = 0,
      parent = "bg",
      text = "34",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(44.06, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.46874390625, h = 30.46874390625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/gift_ticket_6.png",
      name = "img_ticket_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.84, 22.66)
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
      name = "label_ticket_5",
      z = 0,
      parent = "bg",
      text = "34",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(44.06, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.46874390625, h = 30.46874390625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/gift_ticket_6.png",
      name = "img_ticket_6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.84, 22.66)
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
      name = "label_ticket_6",
      z = 0,
      parent = "bg",
      text = "34",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(44.06, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.46874390625, h = 30.46874390625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/gift_ticket_6.png",
      name = "img_ticket_7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.84, 22.66)
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
      name = "label_ticket_7",
      z = 0,
      parent = "bg",
      text = "34",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(44.06, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.46874390625, h = 30.46874390625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/gift_ticket_6.png",
      name = "img_ticket_8",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.84, 22.66)
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
      name = "label_ticket_8",
      z = 0,
      parent = "bg",
      text = "34",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(44.06, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.46874390625, h = 30.46874390625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/gift_ticket_6.png",
      name = "img_ticket_9",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.84, 22.66)
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
      name = "label_ticket_9",
      z = 0,
      parent = "bg",
      text = "34",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(44.06, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.46874390625, h = 30.46874390625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/gift_ticket_6.png",
      name = "img_ticket_10",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.84, 22.66)
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
      name = "label_ticket_10",
      z = 0,
      parent = "bg",
      text = "34",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(44.06, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.46874390625, h = 30.46874390625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/gift_ticket_6.png",
      name = "img_ticket_11",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.84, 22.66)
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
      name = "label_ticket_11",
      z = 0,
      parent = "bg",
      text = "34",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(44.06, 22.66)
    }
  },
  {
    config = {
      rotation = 90,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.78125, h = 35.9375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "button_switch",
      res = "UI/alpha/1080P/guide/tutorial_arrow_right.png",
      name = "img_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.8, 29.3)
    }
  }
}

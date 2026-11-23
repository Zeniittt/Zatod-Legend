ed.uieditor = ed.uieditor or {}
ed.uieditor.GobackPrivilegePage = {
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
      res = "UI/alpha/1080P/goback/bonus/goback_bonus_bg.jpg",
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
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(660, 318.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(350, 215.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 212.5, h = 370.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/bonus/goback_bonus_buy_vitality_discount.png",
      name = "item1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(485, 339.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 212.5, h = 370.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/bonus/goback_bonus_buy_vitality_discount.png",
      name = "item2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(710.5, 339.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 212.5, h = 370.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/bonus/goback_bonus_buy_vitality_discount.png",
      name = "item3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(935.5, 339.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item1",
      res = "UI/alpha/1080P/goback/bonus/goback_bonus_time.png",
      name = "bg_time1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.25, 349.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210.5, h = 75.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item1",
      res = "UI/alpha/1080P/goback/bonus/goback_bonus_txt_bg.png",
      name = "title1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.25, 102.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 143.69997605, h = 43.1999928},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item1",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.25, 37.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item2",
      res = "UI/alpha/1080P/goback/bonus/goback_bonus_time.png",
      name = "bg_time2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.25, 349.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210.5, h = 75.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item2",
      res = "UI/alpha/1080P/goback/bonus/goback_bonus_txt_bg.png",
      name = "title2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.25, 102.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 143.69997605, h = 43.1999928},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item2",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.25, 37.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item3",
      res = "UI/alpha/1080P/goback/bonus/goback_bonus_time.png",
      name = "bg_time3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.25, 349.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210.5, h = 75.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item3",
      res = "UI/alpha/1080P/goback/bonus/goback_bonus_txt_bg.png",
      name = "title3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.25, 102.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 143.69997605, h = 43.1999928},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "item3",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.25, 37.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "time1",
      z = 0,
      parent = "bg_time1",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82, 33)
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
      name = "btn_label1",
      z = 0,
      parent = "btn1",
      text = T("\229\137\141\229\190\128"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.75, 41)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "time2",
      z = 0,
      parent = "bg_time2",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82, 33)
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
      name = "btn_label2",
      z = 0,
      parent = "btn2",
      text = T("\229\137\141\229\190\128"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.75, 41)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "time3",
      z = 0,
      parent = "bg_time3",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82, 33)
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
      name = "btn_label3",
      z = 0,
      parent = "btn3",
      text = T("\229\137\141\229\190\128"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.75, 41)
    }
  }
}

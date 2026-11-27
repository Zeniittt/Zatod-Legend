ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_riseStar = {
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
      res = "UI/alpha/1080P/risestar/bg.jpg",
      name = "page_lay",
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
      fix_wh = {w = 286, h = 151},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/risestar/title.png",
      name = "image_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(497, 562.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 94, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/risestar/itembg.png",
      name = "image_costIcon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(861, 596)
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
      parent = "page_lay",
      name = "page_left",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(35, 183)
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
      parent = "page_lay",
      name = "page_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(958, 361)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(476.5, 331.5)
    },
    t = "Layer",
    base = {
      parent = "page_right",
      name = "task_list",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-393.5, -167.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_title",
      res = "UI/alpha/1080P/risestar/timebg.png",
      name = "image_timetitle",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(370.5, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_costIcon",
      res = "UI/alpha/1080P/risestar/itemicon.png",
      name = "ImageView_38387",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 17.75)
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
      name = "label_num",
      z = 0,
      parent = "image_costIcon",
      text = "288888",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(37.5, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 297, h = 74},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_left",
      res = "UI/alpha/1080P/risestar/summon.png",
      name = "btn_summon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355.5, 1)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 196, h = 85.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_right",
      res = "UI/alpha/1080P/risestar/shop_button.png",
      name = "btn_exchange",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-25.5, -214)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_timetitle",
      res = "UI/alpha/1080P/risestar/time.png",
      name = "ImageView_38383",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.5, 15.25)
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
      name = "label_time",
      z = 0,
      parent = "image_timetitle",
      text = "",
      size = 22
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(45, 13.75)
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
      name = "Label_38389",
      z = 0,
      parent = "btn_exchange",
      text = T("\229\133\145\230\141\162"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.5, 57.75)
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
      name = "Label_38835",
      z = 0,
      parent = "btn_summon",
      text = "",
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149.5, 39)
    }
  },
  {
    config = {
      rotation = 9.74549,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_exchange",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_redpoint",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172.5, 72.25)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_login = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "page_lay", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
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
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/login_gift/login_gift_bg.jpg",
      name = "ImageView_45",
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
      fix_wh = {w = 420, h = 550.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/login_gift/login_gift_cat.png",
      name = "cat_img",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(298, 275.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 630.5, h = 374.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/login_gift/login_gift_title.png",
      name = "login_str_img",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(647, 442)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_374",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(670, 53.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(750, 316.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_375",
      z = 0,
      parent = "Panel_374",
      res = "UI/alpha/1080P/activity/login_gift/login_gift_items_bj.png",
      capInsets = CCRectMake(50, 17.5, 550, 50)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 159)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(321, 261)
    },
    t = "Layer",
    base = {
      parent = "Panel_374",
      name = "panel_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-215.5, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 258},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_374",
      res = "UI/alpha/1080P/activity/login_gift/login_gift_item_big_bg.png",
      name = "login_item_7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(187, 168)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 472.5, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_374",
      res = "UI/alpha/1080P/activity/login_gift/login_gift_item_str_bg.png",
      name = "ImageView_383",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 257.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "login_item_7",
      res = "UI/alpha/1080P/activity/login_gift/login_gift_item_big_pass.png",
      name = "login_item_7_pass",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 129)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(69, 102, 176),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "login_item_7_Label",
      z = 3,
      parent = "login_item_7",
      text = T("\231\172\1727\229\164\169"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.25, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(236, 252, 254),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "ImageView_383",
      text = T("\229\137\169\228\189\153 12\229\164\1696\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(202.75, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_383",
      res = "UI/alpha/1080P/activity/login_gift/login_gift_item_icon.png",
      name = "ImageView_384",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(181.75, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(217, 215, 234),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "login_item_7_pass_Label",
      z = 0,
      parent = "login_item_7_pass",
      text = T("\231\172\1727\229\164\169"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.25, 21.25)
    }
  }
}

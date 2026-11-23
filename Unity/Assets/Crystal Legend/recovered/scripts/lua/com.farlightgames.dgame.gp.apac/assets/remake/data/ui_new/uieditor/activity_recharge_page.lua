ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_recharge_page = {
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
      res = "UI/alpha/1080P/activity/recharge_gift/recharge_gift_bg.jpg",
      name = "ImageView_27",
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
      fix_wh = {w = 1170, h = 720},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/hero_gift/hero_gift_bg.jpg",
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
      fix_wh = {w = 960, h = 59},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/recharge_gift/recharge_gift_title_bg.png",
      name = "ImageView_46",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 417.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 280, h = 372.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/recharge_gift/recharge_gift_icon_img.png",
      name = "ImageView_47",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(414.5, 321.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 394.5, h = 161.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/recharge_gift/recharge_gift_title_img.png",
      name = "ImageView_48",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(411, 437)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 248.5, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/recharge_gift/recharge_gift_time_str_bg.png",
      name = "ImageView_50",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(766, 161.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(51, 255, 75),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_52",
      z = 0,
      parent = "page_lay",
      text = T("\229\137\169\228\189\153 12\229\164\1696\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(764, 162)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 239.5, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "ImageView_53",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(764, 105)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 119, h = 143.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/recharge_gift/recharge_gift_item_bg.png",
      name = "gift_box_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(643, 286.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 119, h = 143.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/recharge_gift/recharge_gift_item_bg.png",
      name = "gift_box_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(763.5, 286.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 119, h = 143.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/recharge_gift/recharge_gift_item_bg.png",
      name = "gift_box_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(885, 286.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/recharge_gift/recharge_gift_star.png",
      name = "ImageView_51",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(601, 422.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 253, 187),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tips",
      z = 1,
      parent = "page_lay",
      text = T("\228\187\187\230\132\143\229\133\133\229\128\188\233\128\129\229\165\189\231\164\188"),
      size = 33
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(757, 418.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/recharge_gift/recharge_gift_star.png",
      name = "ImageView_52",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(911.5, 422.5)
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
      name = "Label_54",
      z = 0,
      parent = "ImageView_53",
      text = T("\229\137\141\229\190\128\229\133\133\229\128\188"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.75, 40)
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
      name = "Label_day_1",
      z = 0,
      parent = "gift_box_1",
      text = "1",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.5, 105.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(209, 122, 48),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_57",
      z = 0,
      parent = "gift_box_1",
      text = T("\231\172\172"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(39.5, 105.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(209, 122, 48),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_57_Copy0",
      z = 0,
      parent = "gift_box_1",
      text = T("\229\164\169"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(79.5, 105.75)
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
      name = "Label_day_2",
      z = 0,
      parent = "gift_box_2",
      text = "2",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.5, 105.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(209, 122, 48),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_57",
      z = 0,
      parent = "gift_box_2",
      text = T("\231\172\172"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(39.5, 105.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(209, 122, 48),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_57_Copy0",
      z = 0,
      parent = "gift_box_2",
      text = T("\229\164\169"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(79.5, 105.75)
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
      name = "Label_day_3",
      z = 0,
      parent = "gift_box_3",
      text = "3",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.5, 105.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(209, 122, 48),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_57",
      z = 0,
      parent = "gift_box_3",
      text = T("\231\172\172"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(39.5, 105.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(209, 122, 48),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_57_Copy0",
      z = 0,
      parent = "gift_box_3",
      text = T("\229\164\169"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(79.5, 105.75)
    }
  }
}

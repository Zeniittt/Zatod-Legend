ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_physical_page = {
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
      res = "UI/alpha/1080P/activity/physical_gift/physical_gift_bg.jpg",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 170)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_136",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(460, 241)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 170)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_136_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(460, 69.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 154.5, h = 62.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_136",
      res = "UI/alpha/1080P/activity/physical_gift/physical_gift_str_bg_1.png",
      name = "img_title_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 143)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 185, h = 185},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_136",
      res = "UI/alpha/1080P/activity/physical_gift/physical_gift_icon_lunch.png",
      name = "img_food_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122, 66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 421.5, h = 119.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/physical_gift/physical_gift_str_img_1.png",
      name = "ImageView_452",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(571, 456)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 284, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_136",
      res = "UI/alpha/1080P/activity/physical_gift/physical_gift_str_bg.png",
      name = "ImageView_13911",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355.5, 145.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 221, 177),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title_1",
      z = 0,
      parent = "img_title_1",
      text = T("\228\184\176\231\155\155\229\141\136\233\164\144"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76.75, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 190.5, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_136",
      res = "UI/alpha/1080P/activity/physical_gift/physical_gift_strnum.png",
      name = "img_food_num_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(352.5, 88.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 203.575, h = 61.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_136",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(352, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 154.5, h = 62.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_136_Copy0",
      res = "UI/alpha/1080P/activity/physical_gift/physical_gift_str_bg_1.png",
      name = "img_title_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 143)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 185, h = 185},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_136_Copy0",
      res = "UI/alpha/1080P/activity/physical_gift/physical_gift_icon_dinner.png",
      name = "img_food_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122, 66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 284, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_136_Copy0",
      res = "UI/alpha/1080P/activity/physical_gift/physical_gift_str_bg.png",
      name = "ImageView_139",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355.5, 145.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time_1",
      z = 0,
      parent = "ImageView_13911",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 203.575, h = 61.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_136_Copy0",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(352, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 190.5, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_136_Copy0",
      res = "UI/alpha/1080P/activity/physical_gift/physical_gift_strnum.png",
      name = "img_food_num_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(352.5, 88.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 57),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_food_num_1",
      z = 0,
      parent = "img_food_num_1",
      text = T("\232\161\165\229\133\133120\231\130\185\228\189\147\229\138\155"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95.25, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 221, 177),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title_2",
      z = 0,
      parent = "img_title_2",
      text = T("\230\184\169\233\166\168\230\153\154\233\164\144"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76.75, 31.75)
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
      name = "label_btn_1",
      z = 0,
      parent = "btn_1",
      text = T("\228\186\171\231\148\168"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120.25, 40)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time_2",
      z = 0,
      parent = "ImageView_139",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131, 15.75)
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
      name = "label_btn_2",
      z = 0,
      parent = "btn_2",
      text = T("\228\186\171\231\148\168"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120.25, 40)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 57),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_food_num_2",
      z = 0,
      parent = "img_food_num_2",
      text = T("\232\161\165\229\133\133120\231\130\185\228\189\147\229\138\155"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95.25, 24)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "label_cost_num_1",
      z = 0,
      parent = "btn_1",
      text = "10",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74.75, 40)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_1",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "img_cost_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.25, 40)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "label_cost_recover_1",
      z = 0,
      parent = "btn_1",
      text = T("\232\161\165\233\162\134"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150.25, 40)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "label_cost_recover_2",
      z = 0,
      parent = "btn_2",
      text = T("\232\161\165\233\162\134"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149.75, 40)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_2",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "img_cost_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.75, 40)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "label_cost_num_2",
      z = 0,
      parent = "btn_2",
      text = "10",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74.75, 40)
    }
  }
}

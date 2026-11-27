ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_exchange = {
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
      res = "UI/alpha/1080P/activity/exchange/exchange_bg.jpg",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(440, 342.5)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "item_list",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(505.5, 57)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(85, 85)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "target_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(261, 201.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(98, 72, 54),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "target_reward_desc_1",
      z = 0,
      parent = "page_lay",
      text = T("\229\183\178\230\182\136\232\128\151"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(294, 169.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "target_task_desc",
      z = 0,
      parent = "page_lay",
      text = T("\231\180\175\232\174\161\230\182\136\232\128\151\233\157\146\231\171\185\233\162\134\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(304, 140)
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
      name = "token_amount",
      z = 0,
      parent = "page_lay",
      text = T("\230\140\129\230\156\13712345"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(889, 427.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 247.5, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/exchange/exchange_timeup_bg.png",
      name = "left_time_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(311.5, 76.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 197, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/exchange/exchange_title.png",
      name = "image_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(511, 474)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 645.5, h = 353.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/exchange/exchange_goods_frame.png",
      name = "item_list_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(723.5, 232.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(98, 72, 54),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "target_reward_desc_2",
      z = 0,
      parent = "page_lay",
      text = "123/1234",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(314, 169)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/icon/exchange_bamboo.png",
      name = "target_task_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(304, 170)
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
      parent = "left_time_bg",
      res = "UI/alpha/1080P/activity/exchange/exchange_time_icon.png",
      name = "ImageView_743",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 20.25)
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
      name = "left_time",
      z = 0,
      parent = "left_time_bg",
      text = T("\229\137\169\228\189\153 12\229\164\1696\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(73.75, 20.75)
    }
  }
}

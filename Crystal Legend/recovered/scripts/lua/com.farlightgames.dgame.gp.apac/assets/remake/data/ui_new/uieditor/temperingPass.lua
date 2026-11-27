ed.uieditor = ed.uieditor or {}
ed.uieditor.temperingPass = {
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
      res = "UI/alpha/1080P/legendequipfund/background.jpg",
      name = "page_lay",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(524, 277.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(523, 244)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "pass_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(396.5, 201)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 419.5, h = 136},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/legendequipfund/art1.png",
      name = "title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(598.5, 541.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 123),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "level",
      z = 0,
      parent = "page_lay",
      text = T("\231\180\175\232\174\161\233\148\187\233\128\160\230\172\161\230\149\176"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(349.5, 416.5)
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
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn_buy",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(624.5, 178)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 232.5, h = 315.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/legendequipfund/art2.png",
      name = "ImageView_341",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1033, 282.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 255, 189),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_base_reward",
      z = 0,
      parent = "page_lay",
      text = T("\229\159\186\231\161\128\230\148\182\231\155\138"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(347, 338.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 255, 188),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_advanced_reward",
      z = 1,
      parent = "page_lay",
      text = T("\230\138\149\232\181\132\229\155\158\230\138\165"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(347, 254.5)
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
      name = "label_buy",
      z = 3,
      parent = "btn_buy",
      text = T("\232\180\173\228\185\176"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.75, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 255, 189),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "page_lay",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(621.5, 460)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(700, 40)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "title_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(307, 446)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 36.5)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "title_tips_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(319, 236.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 86, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/legendequipfund/nowtimes_board.png",
      name = "ImageView_21339",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(347.5, 399)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 255, 189),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_base_number",
      z = 0,
      parent = "ImageView_21339",
      text = T("\229\189\147\229\137\141: 200\230\172\161"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.5, 8.25)
    }
  }
}

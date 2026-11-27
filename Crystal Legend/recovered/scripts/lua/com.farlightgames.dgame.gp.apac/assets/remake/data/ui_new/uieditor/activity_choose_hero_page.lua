ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_choose_hero_page = {
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
      res = "UI/alpha/1080P/activity/bbpick/bbpick_bg.jpg",
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
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_gift",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(344.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(344.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/login_gift_midautumn/login_gift_item_icon.png",
      name = "ImageView_3278",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(658.5, 430)
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
      name = "Label_time",
      z = 0,
      parent = "page_lay",
      text = T("\229\137\169\228\189\153 "),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(679, 430.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 380, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_hero",
      res = "UI/alpha/1080P/activity/bbpick/bbpick_info_unchoose.png",
      name = "ImageView_3258",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(333, 142.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 380, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_gift",
      res = "UI/alpha/1080P/activity/bbpick/bbpick_info_choose.png",
      name = "ImageView_3258s",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(332.5, 88)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 191.599988504, h = 59.599996424},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_hero",
      res = "UI/alpha/1080P/activity/abyss_show/abyss_show_button.png",
      name = "btn_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.5, 84.5)
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
      parent = "Panel_gift",
      name = "Panel_mod",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(309.5, 230.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 191.599988504, h = 59.599996424},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_gift",
      res = "UI/alpha/1080P/activity/abyss_show/abyss_show_button.png",
      name = "btn_gift",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.5, 84.5)
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
      parent = "Panel_hero",
      name = "Panel_hero_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(312.5, 284.5)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "Label_3280",
      z = 0,
      parent = "Panel_gift",
      text = T("\229\183\178\233\162\134\229\143\150"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313, 84)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 243, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_001",
      z = 0,
      parent = "ImageView_3258",
      text = T("\233\128\137\230\139\169   \228\184\170\229\191\131\228\187\170\231\154\132\231\164\188\231\137\169\239\188\140"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(121.5, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 193),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_002",
      z = 0,
      parent = "ImageView_3258",
      text = "1",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 193),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_003",
      z = 0,
      parent = "ImageView_3258",
      text = T("\230\172\161\230\151\165\229\141\179\229\143\175\233\162\134\229\143\150"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(271, 19.25)
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
      name = "Label_btn_right",
      z = 0,
      parent = "btn_right",
      text = T("\231\161\174\229\174\154\233\128\137\230\139\169"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.25, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 243, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_01",
      z = 0,
      parent = "ImageView_3258s",
      text = T("\230\130\168\229\183\178\233\128\137\230\139\169\229\191\131\228\187\170\231\164\188\231\137\169\239\188\140\232\174\176\229\190\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 193),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_03",
      z = 0,
      parent = "ImageView_3258s",
      text = T("\230\152\142\230\151\165\229\184\166ta\229\155\158\229\174\182\229\147\166\239\188\129"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(295.5, 17.75)
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
      name = "Label_btn_gift",
      z = 0,
      parent = "btn_gift",
      text = T("\233\162\134\229\143\150"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.25, 40.75)
    }
  }
}

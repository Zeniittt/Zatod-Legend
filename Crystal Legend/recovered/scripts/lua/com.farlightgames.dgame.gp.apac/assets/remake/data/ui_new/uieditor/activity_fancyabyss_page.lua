ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_fancyabyss_page = {
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
      res = "UI/alpha/1080P/activity/abyss_show/abyss_show_bg.jpg",
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
      name = "Label_52",
      z = 0,
      parent = "page_lay",
      text = T("\229\189\147\229\137\141\229\177\130\230\149\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(420.5, 281.5)
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
      name = "Label_52_Copy0",
      z = 0,
      parent = "page_lay",
      text = T("\233\128\154\229\133\179\230\151\182\233\151\180"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(420.5, 241.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 128),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "page_lay",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(618, 241.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 128),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_level",
      z = 0,
      parent = "page_lay",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(618, 281.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(290, 87)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "panel_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(371, 85.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 128),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buff_name",
      z = 0,
      parent = "page_lay",
      text = T("\230\156\172\230\156\159\230\149\136\230\158\156\239\188\154\233\173\148\230\179\149\228\188\164\229\174\179\229\162\158\229\138\160"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(417, 394.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(265, 58)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "panel_txt",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(416, 322.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(275, 100)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "panel_goto",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(713.5, 78)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 191.6, h = 59.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_goto",
      res = "UI/alpha/1080P/activity/abyss_show/abyss_show_button.png",
      name = "btn_go",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17, h = 17},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_goto",
      res = "UI/alpha/1080P/activity/abyss_show/abyss_show_time_icon.png",
      name = "ImageView_2929",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 77.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_countdown",
      z = 0,
      parent = "panel_goto",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(51, 77.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 244, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_challenge",
      z = 0,
      parent = "btn_go",
      text = T("\230\140\145\230\136\152"),
      size = 36
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.75, 40.25)
    }
  }
}

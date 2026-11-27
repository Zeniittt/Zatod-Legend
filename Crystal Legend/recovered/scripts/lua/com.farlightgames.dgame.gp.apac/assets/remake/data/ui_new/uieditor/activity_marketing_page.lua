ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_marketing_page = {
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
      fix_wh = {w = 1170, h = 719.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/snakehappynewyear/old_bg.jpg",
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
      fix_wh = {w = 545.5, h = 184.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/snakehappynewyear/old_5.png",
      name = "ImageView_3610",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(497, 447)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 674.5, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/snakehappynewyear/old_2.png",
      name = "ImageView_3611",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487, 353.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 194, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/snakehappynewyear/old_3.png",
      name = "ImageView_3612",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(780, 532.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(680, 331.5)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(155, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 290.5, h = 102},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/snakehappynewyear/old_4.png",
      name = "btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(495, 40)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.5, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/snakehappynewyear/snake_time.png",
      name = "ImageView_3669",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(444, 95.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 187),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_time",
      z = 3,
      parent = "page_lay",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(457.5, 95.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 178.5, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/snakehappynewyear/time_bg.png",
      name = "ImageView_3671",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(495, 95.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 223, 135),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3614",
      z = 0,
      parent = "ImageView_3611",
      text = T("\229\174\140\230\136\144\230\140\135\229\174\154\230\180\187\232\183\131\229\186\166\231\155\174\230\160\135\229\143\175\228\187\165\233\162\134\229\143\150\229\165\150\229\138\177"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(337.25, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 184),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3613",
      z = 0,
      parent = "ImageView_3612",
      text = T("\231\155\174\229\137\141\230\180\187\232\183\131\229\186\166\239\188\154999"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97, 12.75)
    }
  }
}

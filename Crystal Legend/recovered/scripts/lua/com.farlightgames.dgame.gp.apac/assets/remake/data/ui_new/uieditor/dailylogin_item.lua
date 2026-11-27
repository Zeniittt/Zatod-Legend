ed.uieditor = ed.uieditor or {}
ed.uieditor.dailylogin_item = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(104.5, 71)
    },
    t = "Layer",
    base = {name = "all_panel", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
      name = "txt_day",
      z = 7,
      parent = "all_panel",
      text = "1",
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10, 59.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(40, 40)
    },
    t = "Layer",
    base = {
      parent = "all_panel",
      name = "item_pos",
      z = 7
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(32.5, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.5, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "all_panel",
      res = "UI/alpha/1080P/dailylogin/dailylogin_data_img.png",
      name = "ImageView_78",
      z = 6
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 52.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 70},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "all_panel",
      res = "UI/alpha/1080P/dailylogin/dailylogin_itembj2.png",
      name = "img_disabled",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 104.5, h = 71},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "all_panel",
      res = "UI/alpha/1080P/dailylogin/dailylogin_itembj4.png",
      name = "img_normal",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 70},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "all_panel",
      res = "UI/alpha/1080P/dailylogin/dailylogin_itembj3.png",
      name = "img_pressed",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.75, h = 23.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "all_panel",
      res = "UI/alpha/1080P/package/selected.png",
      name = "img_selected",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 52.5, h = 53.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "all_panel",
      res = "UI/alpha/1080P/dailylogin/dailylogin_itembj1.png",
      name = "img_buqian",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.5, 33.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 219, 124),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buqian",
      z = 0,
      parent = "img_buqian",
      text = T("\232\161\165\231\173\190"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.25, 27.25)
    }
  }
}

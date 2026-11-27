ed.uieditor = ed.uieditor or {}
ed.uieditor.GobackTabItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(177.5, 58)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
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
      fix_wh = {w = 188.5, h = 64},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/goback_tag_bg_b.png",
      name = "selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 188.5, h = 64},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/goback_tag_bg_a.png",
      name = "unselected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "selected",
      res = "UI/alpha/1080P/activity/activity_tag_img_days_login_b.png",
      name = "icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.75, 32)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unselected",
      res = "UI/alpha/1080P/activity/activity_tag_img_days_login_a.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.75, 32)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title1",
      z = 0,
      parent = "unselected",
      text = T("\231\153\187\233\153\134\229\165\189\231\164\188"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(56.75, 32)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title2",
      z = 0,
      parent = "selected",
      text = T("\231\153\187\233\153\134\229\165\189\231\164\188"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(62.25, 32)
    }
  }
}

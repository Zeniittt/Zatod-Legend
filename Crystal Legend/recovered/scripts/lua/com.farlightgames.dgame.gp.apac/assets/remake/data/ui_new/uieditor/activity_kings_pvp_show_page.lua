ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_kings_pvp_show_page = {
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
      res = "UI/alpha/1080P/activity/specialactivity_show/bg.jpg",
      name = "image_bg",
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
      fix_wh = {w = 186.5, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/specialactivity_show/button.png",
      name = "btn_go",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(787, 162.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 678, h = 493},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/specialactivity_show/icon.png",
      name = "image_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(339, 305.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224.5, h = 251.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/specialactivity_show/1.png",
      name = "image_detail1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(565.5, 405)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224.5, h = 251.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/specialactivity_show/2.png",
      name = "image_detail2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(779, 405)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224.5, h = 251.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/specialactivity_show/3.png",
      name = "image_detail3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(993, 405)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 772, h = 205},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activity/specialactivity_show/text.png",
      name = "image_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(784, 278.5)
    }
  }
}

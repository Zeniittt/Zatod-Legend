ed.uieditor = ed.uieditor or {}
ed.uieditor.package_stone = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/package/bg_progress_bar.png",
      name = "bg_percent",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(4, 8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88, h = 88},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/package/frame1.png",
      name = "frame",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 53.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.95, h = 16.9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_percent",
      res = "UI/alpha/1080P/icon/herodetail_soulstone_icon.png",
      name = "icon_stone",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(3.5, 7.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 69, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_percent",
      res = "UI/alpha/1080P/package/progress_bar2.png",
      name = "percent",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0.5, 7.5)
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
      name = "label_percent",
      z = 0,
      parent = "bg_percent",
      text = "50/100",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 7.5)
    }
  }
}

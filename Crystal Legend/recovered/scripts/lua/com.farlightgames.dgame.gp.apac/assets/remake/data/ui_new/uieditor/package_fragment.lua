ed.uieditor = ed.uieditor or {}
ed.uieditor.package_fragment = {
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
      name = "bg_precent",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12, 8)
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
      parent = "bg_precent",
      res = "UI/alpha/1080P/package/progress_bar1.png",
      name = "percent",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(1.5, 7.5)
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
      parent = "bg_precent",
      text = "50/100",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.5, 7.5)
    }
  }
}

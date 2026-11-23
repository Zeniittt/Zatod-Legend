ed.uieditor = ed.uieditor or {}
ed.uieditor.package_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75, h = 78},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/battle/social_head_bg.png",
      name = "ImageView_136",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 87},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_136",
      res = "UI/alpha/HVGA/equip_frame_white.png",
      name = "ImageView_137",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 39)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.799998152, h = 12.799999232},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_136",
      res = "UI/alpha/1080P/package/bg_timer.png",
      name = "ImageView_180",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.5, 69)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 88},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "ImageView_137",
      res = "UI/alpha/1080P/package/icon_selected.png",
      name = "ImageView_142",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 45)
    }
  },
  {
    config = {
      rotation = -24,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9.999998, h = 13.4999973},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_180",
      res = "UI/alpha/HVGA/SeasonArena/treasure/unlock_icon.png",
      name = "ImageView_181",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(7.25, 8)
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
      name = "Label_182",
      z = 0,
      parent = "ImageView_180",
      text = "12h",
      size = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.25, 8)
    }
  }
}

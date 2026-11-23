ed.uieditor = ed.uieditor or {}
ed.uieditor.heroHaggleHeroItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 80)
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
      fix_wh = {w = 67.5, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_hero_not_owned.png",
      name = "name_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 62)
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
      name = "label_hero_name",
      z = 0,
      parent = "name_bg",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.75, 11.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 80)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.76, x = 0.76},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.66, h = 35.72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero",
      res = "UI/alpha/1080P/common/common_mark.png",
      name = "image_ban_Tag",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 34.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/summon/summon_hero_star_max.png",
      name = "layer_max",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 62)
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
      name = "label_hero_name_max",
      z = 0,
      parent = "layer_max",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 11)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.multi_hero_panel = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 921.5, h = 122.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/battle/list_bg.png",
      name = "image_bg",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(405, 100)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_hero_list_left",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(35.75, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(405, 100)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_hero_list_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480.75, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.5, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/battle/me_icon.png",
      name = "image_title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.25, 103.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dungeon/battle/boss_icon.png",
      name = "image_title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(906.25, 103.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 125),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left",
      z = 0,
      parent = "image_title_left",
      text = T("\230\136\145\230\150\185\233\152\159\228\188\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(12.25, -2.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 129, 134),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_right",
      z = 0,
      parent = "image_title_right",
      text = T("\230\149\140\230\150\185\233\152\159\228\188\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(16.5, -2.25)
    }
  }
}

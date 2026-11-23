ed.uieditor = ed.uieditor or {}
ed.uieditor.fire_forge_smelter_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 95, h = 95},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/forge_empty.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 95, h = 95},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/fireforge/forge_icon.png",
      name = "image_forge_item",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 47.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 95, h = 95},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/fireforge/forge_lock.png",
      name = "image_lock",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 47.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 62, h = 16.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/fireforge/timeline_empty.png",
      name = "image_bar_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 8.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.5, h = 21.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/fireforge/skip_one.png",
      name = "btn_skip_one",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79.5, 8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 140.4, h = 140.4},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/taskModel/player_award_list_item_eff.png",
      name = "image_light",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 47.5)
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
      name = "label_left_time",
      z = 1,
      parent = "image_bar_bg",
      text = "00:00:00",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(57, 13)
    },
    t = "Layer",
    base = {
      parent = "image_bar_bg",
      name = "bar_clip",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(2.5, 2.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bar_clip",
      res = "UI/alpha/1080P/fireforge/timeline_full.png",
      name = "image_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 6)
    }
  }
}

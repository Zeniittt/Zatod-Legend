ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueRevelationIcon = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 146, h = 146},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_battle_echo_frame.png",
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
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 128.1, h = 128.1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_battle_echo_bg.png",
      name = "image_lock_mask",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74.5, 72.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 146, h = 146},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_battle_echo_light.png",
      name = "image_light",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.8, h = 59.85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_echo_lock.png",
      name = "image_lock",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.58, x = 0.58},
      flip = "",
      opacity = 255,
      fix_wh = {w = 112.52, h = 81.78},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/bless_the_strength_simple.png",
      name = "image_icon",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73.5, 74.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(95, 95)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_energy_clip",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(26, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 244, 149),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time",
      z = 6,
      parent = "image_bg",
      text = "3",
      size = 39
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 128.1, h = 128.1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_energy_clip",
      res = "UI/alpha/1080P/rogue/instance/instance_prepare_echo_actcharge.png",
      name = "image_energy",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 47)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.echoSkillIcon = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 170, h = 170},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/nianmonster/nian_battle_bg2.png",
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
      fix_wh = {w = 170, h = 170},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_battle_bg3.png",
      name = "image_bg2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85, 85)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.33, x = 1.33},
      flip = "",
      opacity = 255,
      fix_wh = {w = 93.1, h = 93.1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/DOTA-ITEM/101.jpg",
      name = "image_skill_icon",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85, 85)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 170, h = 170},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_battle_shadow.png",
      name = "image_shadow",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85, 85)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 170, h = 170},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_battle_frame1.png",
      name = "image_unready",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85, 85)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 170, h = 170},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_battle_frame2.png",
      name = "image_ready",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85, 85)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 170, h = 170},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_battle_light.png",
      name = "image_light",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85, 85)
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
      z = 5,
      parent = "image_bg",
      text = "12",
      size = 39
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85, 85)
    }
  }
}

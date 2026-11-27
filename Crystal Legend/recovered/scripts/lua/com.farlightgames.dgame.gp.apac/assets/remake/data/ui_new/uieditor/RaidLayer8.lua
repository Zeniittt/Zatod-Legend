ed.uieditor = ed.uieditor or {}
ed.uieditor.RaidLayer8 = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 830.5, h = 516},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/raid/map_13.png",
      name = "bg",
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
      fix_scale = {y = 1.15, x = 1.15},
      flip = "",
      opacity = 255,
      fix_wh = {w = 234.6, h = 233.45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-250-locked.png",
      name = "boss",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(412.75, 192.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 83.25, h = 56.7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "boss",
      res = "UI/alpha/1080P/raid/boss_text.png",
      name = "boss_text",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204, h = 203},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "boss",
      res = "UI/alpha/1080P/stages/stage-250-passed.png",
      name = "boss_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102, 101.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 212, h = 175},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-237.png",
      name = "stage1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.25, 179.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 212, h = 186},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-246.png",
      name = "stage2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(147.25, 349)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 212, h = 175},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage1",
      res = "UI/alpha/1080P/stages/stage-237-passed.png",
      name = "stage1_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106, 87.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209, h = 181},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-464.png",
      name = "stage3",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(498.75, 390)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 169},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-240.png",
      name = "stage4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(656.25, 343)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 212, h = 186},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage2",
      res = "UI/alpha/1080P/stages/stage-246-passed.png",
      name = "stage2_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106, 93)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209, h = 181},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-463.png",
      name = "stage5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(706.25, 197)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209, h = 181},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage3",
      res = "UI/alpha/1080P/stages/stage-464-passed.png",
      name = "stage3_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 90.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 169},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage4",
      res = "UI/alpha/1080P/stages/stage-240-passed.png",
      name = "stage4_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 84.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209, h = 181},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage5",
      res = "UI/alpha/1080P/stages/stage-463-passed.png",
      name = "stage5_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 90.5)
    }
  }
}

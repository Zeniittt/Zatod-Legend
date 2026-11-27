ed.uieditor = ed.uieditor or {}
ed.uieditor.RaidLayer6 = {
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
      res = "UI/alpha/1080P/raid/map_11.png",
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
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 244.8, h = 198},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-214-locked.png",
      name = "boss",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(380.75, 235.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 207},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-197.png",
      name = "stage1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.75, 298.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210, h = 237},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-200.png",
      name = "stage2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164.75, 175)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 230},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-203.png",
      name = "stage3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(260.25, 402)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 195.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-206.png",
      name = "stage4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(505.25, 433)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 217, h = 207},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-209.png",
      name = "stage5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(638.25, 151.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 219},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-212.png",
      name = "stage6",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(755.25, 237.5)
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
      position = ccp(102, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204, h = 165},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "boss",
      res = "UI/alpha/1080P/stages/stage-214-passed.png",
      name = "boss_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102, 82.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 207},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage1",
      res = "UI/alpha/1080P/stages/stage-197-passed.png",
      name = "stage1_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 103.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210, h = 237},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage2",
      res = "UI/alpha/1080P/stages/stage-200-passed.png",
      name = "stage2_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105, 118.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 230},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage3",
      res = "UI/alpha/1080P/stages/stage-203-passed.png",
      name = "stage3_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 115)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 217},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage4",
      res = "UI/alpha/1080P/stages/stage-206-passed.png",
      name = "stage4_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 108.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 217, h = 207},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage5",
      res = "UI/alpha/1080P/stages/stage-209-passed.png",
      name = "stage5_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.5, 103.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 219},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage6",
      res = "UI/alpha/1080P/stages/stage-212-passed.png",
      name = "stage6_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 109.5)
    }
  }
}

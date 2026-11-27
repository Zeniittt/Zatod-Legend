ed.uieditor = ed.uieditor or {}
ed.uieditor.RaidLayer7 = {
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
      res = "UI/alpha/1080P/raid/map_12.png",
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
      fix_scale = {y = 1.05, x = 1.05},
      flip = "",
      opacity = 255,
      fix_wh = {w = 221.55, h = 236.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-234-locked.png",
      name = "boss",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(284.75, 303.5)
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
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-216.png",
      name = "stage1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109.25, 333)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 217, h = 227},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-218.png",
      name = "stage2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(138.75, 176)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204, h = 208},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-221.png",
      name = "stage3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(371.75, 144)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210, h = 207},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-224.png",
      name = "stage4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(489.75, 421)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210, h = 219},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-226.png",
      name = "stage5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(516.25, 227)
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
      res = "UI/alpha/1080P/stages/stage-229.png",
      name = "stage6",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(700.75, 160)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210, h = 217},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-231.png",
      name = "stage7",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(729.25, 385)
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
      position = ccp(105.5, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 225},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "boss",
      res = "UI/alpha/1080P/stages/stage-234-passed.png",
      name = "boss_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 112.5)
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
      parent = "stage1",
      res = "UI/alpha/1080P/stages/stage-216-passed.png",
      name = "stage1_light",
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
      fix_wh = {w = 217, h = 227},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage2",
      res = "UI/alpha/1080P/stages/stage-218-passed.png",
      name = "stage2_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.5, 113.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204, h = 208},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage3",
      res = "UI/alpha/1080P/stages/stage-221-passed.png",
      name = "stage3_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102, 104)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210, h = 207},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage4",
      res = "UI/alpha/1080P/stages/stage-224-passed.png",
      name = "stage4_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105, 103.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210, h = 219},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage5",
      res = "UI/alpha/1080P/stages/stage-226-passed.png",
      name = "stage5_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105, 109.5)
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
      parent = "stage6",
      res = "UI/alpha/1080P/stages/stage-229-passed.png",
      name = "stage6_light",
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
      fix_wh = {w = 210, h = 217},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage7",
      res = "UI/alpha/1080P/stages/stage-231-passed.png",
      name = "stage7_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105, 108.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.RaidLayer4 = {
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
      res = "UI/alpha/1080P/raid/map_9.png",
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
      fix_wh = {w = 253.2, h = 236.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-174-locked.png",
      name = "boss",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(347.75, 354.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 202},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-157.png",
      name = "stage1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.25, 351)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 194},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-160.png",
      name = "stage2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136.75, 129.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 201},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-162.png",
      name = "stage3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(373.25, 151.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 205},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-165.png",
      name = "stage4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(572.25, 299.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 195},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-167.png",
      name = "stage5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(722.25, 405.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 197},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-170.png",
      name = "stage6",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(749.75, 194)
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
      position = ccp(105.5, 36.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 197},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "boss",
      res = "UI/alpha/1080P/stages/stage-174-passed.png",
      name = "boss_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 98.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 202},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage1",
      res = "UI/alpha/1080P/stages/stage-157-passed.png",
      name = "stage1_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 101)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 194},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage2",
      res = "UI/alpha/1080P/stages/stage-160-passed.png",
      name = "stage2_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 97)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 201},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage3",
      res = "UI/alpha/1080P/stages/stage-162-passed.png",
      name = "stage3_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 100.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 205},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage4",
      res = "UI/alpha/1080P/stages/stage-165-passed.png",
      name = "stage4_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 102.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 195},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage5",
      res = "UI/alpha/1080P/stages/stage-167-passed.png",
      name = "stage5_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 97.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 197},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage6",
      res = "UI/alpha/1080P/stages/stage-170-passed.png",
      name = "stage6_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 98.5)
    }
  }
}

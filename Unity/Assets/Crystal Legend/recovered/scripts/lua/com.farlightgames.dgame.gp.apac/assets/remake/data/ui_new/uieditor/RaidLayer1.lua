ed.uieditor = ed.uieditor or {}
ed.uieditor.RaidLayer1 = {
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
      res = "UI/alpha/1080P/raid/map_6.png",
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
      fix_wh = {w = 246, h = 229.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-114-locked.png",
      name = "boss",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(547.75, 234)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204, h = 203},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-95.png",
      name = "stage1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73.25, 386.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 163},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-98.png",
      name = "stage2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154.25, 194)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 207, h = 199},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-101.png",
      name = "stage3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(235.75, 338)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 184.5, h = 175.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-104.png",
      name = "stage4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(358.25, 137.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 176},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-107.png",
      name = "stage5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(505.25, 399)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 181},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-109.png",
      name = "stage6",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(719.75, 139.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 165},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/stages/stage-112.png",
      name = "stage7",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(739.75, 378.5)
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
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204, h = 203},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage1",
      res = "UI/alpha/1080P/stages/stage-95-passed.png",
      name = "stage1_light",
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
      fix_wh = {w = 205, h = 163},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage2",
      res = "UI/alpha/1080P/stages/stage-98-passed.png",
      name = "stage2_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 81.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 207, h = 199},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage3",
      res = "UI/alpha/1080P/stages/stage-101-passed.png",
      name = "stage3_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103.5, 99.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 191},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "boss",
      res = "UI/alpha/1080P/stages/stage-114-passed.png",
      name = "boss_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 95.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 195},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage4",
      res = "UI/alpha/1080P/stages/stage-104-passed.png",
      name = "stage4_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 97.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 176},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage5",
      res = "UI/alpha/1080P/stages/stage-107-passed.png",
      name = "stage5_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 88)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 181},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage6",
      res = "UI/alpha/1080P/stages/stage-109-passed.png",
      name = "stage6_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 90.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 165},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "stage7",
      res = "UI/alpha/1080P/stages/stage-112-passed.png",
      name = "stage7_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 82.5)
    }
  }
}

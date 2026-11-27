ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessTagItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(38, 48)
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
      fix_wh = {w = 37, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/tag/herodetail_symbol_chemist.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53, h = 53},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/tag_select.png",
      name = "icon_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 28)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(38, 10)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 1)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(38, 10)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 1)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(38, 10)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 1)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "level",
      z = 2,
      parent = "bg",
      text = "2",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 18)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1",
      res = "UI/alpha/1080P/chess/battle/dark1_1.png",
      name = "dark1_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer2",
      res = "UI/alpha/1080P/chess/battle/dark1_2.png",
      name = "dark2_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.5, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer2",
      res = "UI/alpha/1080P/chess/battle/dark1_2.png",
      name = "dark2_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer3",
      res = "UI/alpha/1080P/chess/battle/dark1_3.png",
      name = "dark3_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(7.5, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer3",
      res = "UI/alpha/1080P/chess/battle/dark1_3.png",
      name = "dark3_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer3",
      res = "UI/alpha/1080P/chess/battle/dark1_3.png",
      name = "dark3_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.5, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dark1_1",
      res = "UI/alpha/1080P/chess/battle/light1_1.png",
      name = "light1_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 4.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dark2_1",
      res = "UI/alpha/1080P/chess/battle/light1_2.png",
      name = "light2_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9, 4.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dark2_2",
      res = "UI/alpha/1080P/chess/battle/light1_2.png",
      name = "light2_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9, 4.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dark3_1",
      res = "UI/alpha/1080P/chess/battle/light1_3.png",
      name = "light3_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(5.75, 4.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dark3_2",
      res = "UI/alpha/1080P/chess/battle/light1_3.png",
      name = "light3_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(5.75, 4.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dark3_3",
      res = "UI/alpha/1080P/chess/battle/light1_3.png",
      name = "light3_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(5.75, 4.25)
    }
  }
}

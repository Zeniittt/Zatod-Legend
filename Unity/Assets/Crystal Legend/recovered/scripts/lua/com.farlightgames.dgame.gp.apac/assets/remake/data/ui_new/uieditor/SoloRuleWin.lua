ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloRuleWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 414.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/rule/bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 292)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 137, h = 437},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/rule/cosmetic_1.png",
      name = "ImageView_2838",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198, 184.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/solobook/page_satr_bg.png",
      name = "ImageView_2843",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(626, 44.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 757.5, h = 269},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chesscard/rule/1.png",
      name = "ImageView_2854",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(648, 207.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 89, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2838",
      res = "UI/alpha/1080P/chesscard/rule/cosmetic_2.png",
      name = "ImageView_2839",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 324.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2843",
      res = "UI/alpha/1080P/chesscard/solobook/switch_1.png",
      name = "ImageView_2851",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-10, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -42, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2843",
      res = "UI/alpha/1080P/chesscard/solobook/switch_1.png",
      name = "ImageView_2852",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89, 15.5)
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
      name = "Label_2853",
      z = 0,
      parent = "ImageView_2843",
      text = "1/5",
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 8.5, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2839",
      res = "UI/alpha/1080P/chesscard/rule/page_2.png",
      name = "ImageView_2840",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 8.5, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2839",
      res = "UI/alpha/1080P/chesscard/rule/page_2.png",
      name = "ImageView_2840_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70.5, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(42, 92, 89),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2842",
      z = 0,
      parent = "ImageView_2839",
      text = T("\229\159\186\231\161\128"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.5, 18.25)
    }
  }
}

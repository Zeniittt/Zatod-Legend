ed.uieditor = ed.uieditor or {}
ed.uieditor.summonRiseStarConfirmWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
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
      fix_wh = {w = 235, h = 433},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/summonbeginner/beignner_hero_choose_gate.png",
      name = "bg_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(481, 386)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.5, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_hero",
      res = "UI/alpha/1080P/herohot/herohot_fire_icon.png",
      name = "icon_hot",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.5, 29.5)
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
      name = "label_hot",
      z = 0,
      parent = "icon_hot",
      text = "111",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(-3.25, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 248, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name",
      z = 2,
      parent = "bg_hero",
      text = T("\228\187\153\229\165\179\233\190\153"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.5, 57.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167.5, h = 52.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/summonbeginner/beignner_cancel_button.png",
      name = "btn_cancel",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(342, 91.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_hero",
      res = "UI/alpha/1080P/common/shop_token_icon.png",
      name = "hero",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.5, 81)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167.5, h = 52.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/summonbeginner/beignner_confirm_button.png",
      name = "btn_ok",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(619, 91)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 244, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cancel",
      z = 0,
      parent = "btn_cancel",
      text = T("\230\136\145\229\134\141\230\131\179\230\131\179"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.75, 27.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 709, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/summonbeginner/beignner_hero_choose_shade.png",
      name = "ImageView_740",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 152.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167.5, h = 52.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/summonbeginner/beignner_wait_button.png",
      name = "btn_ok_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(619, 91)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 244, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_ok1",
      z = 0,
      parent = "btn_ok",
      text = T("\231\161\174 \232\174\164"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.75, 27.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 471, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_740",
      res = "UI/alpha/1080P/summonbeginner/beignner_hero_choose_tip.png",
      name = "ImageView_739",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(354.5, 17)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 226),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_ok",
      z = 0,
      parent = "btn_ok_Copy0",
      text = T("\231\161\174 \232\174\164"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.75, 27.75)
    }
  }
}

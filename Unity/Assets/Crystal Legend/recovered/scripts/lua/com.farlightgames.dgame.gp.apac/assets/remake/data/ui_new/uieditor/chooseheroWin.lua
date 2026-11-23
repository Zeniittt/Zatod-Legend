ed.uieditor = ed.uieditor or {}
ed.uieditor.chooseheroWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 450)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 25, 10, 25),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 248)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_2454",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 417.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 135),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2452",
      z = 0,
      parent = "bg",
      text = T("\233\128\137\230\139\169\232\139\177\233\155\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250, 417.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_2453",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(150.5, 417.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 50,
      visible = true,
      scaleSize = CCSizeMake(489.5, 300)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_6499",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5.5, 79)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.73},
      flip = "",
      opacity = 255,
      fix_wh = {w = 486.91, h = 300.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/bg_statics_main.png",
      name = "bg_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250, 231)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(490, 298.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_6501",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5, 81)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 296.2500237, h = 14.25000114},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_2.png",
      name = "ImageView_6502",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250, 81.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(250, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "tag1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-140, -2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "tag2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-70, -2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "tag3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "tag4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70, -2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "tag5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, -2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "tag1",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "tag_selected1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_tag1",
      z = 1,
      parent = "tag1",
      text = T("\229\133\168\233\131\168"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "tag2",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "tag_selected2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_tag2",
      z = 1,
      parent = "tag2",
      text = T("\229\137\141\230\142\146"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "tag3",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "tag_selected3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_tag3",
      z = 1,
      parent = "tag3",
      text = T("\228\184\173\230\142\146"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "tag4",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "tag_selected4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_tag4",
      z = 1,
      parent = "tag4",
      text = T("\229\144\142\230\142\146"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "tag5",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "tag_selected5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_tag5",
      z = 1,
      parent = "tag5",
      text = T("\230\148\182\232\151\143"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  }
}

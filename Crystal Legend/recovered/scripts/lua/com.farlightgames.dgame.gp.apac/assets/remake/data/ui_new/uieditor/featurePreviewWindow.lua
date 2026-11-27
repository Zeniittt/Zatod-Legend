ed.uieditor = ed.uieditor or {}
ed.uieditor.featurePreviewWindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(695, 441.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(19.5, 20.5, 50, 350),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(470, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 377.99997732, h = 51.199996928},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/campaign/lineup_guide/title.png",
      name = "ImageView_3252",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(349.5, 407.75)
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
      name = "Label_title",
      z = 0,
      parent = "bg",
      text = T("\229\138\159\232\131\189\233\162\132\229\145\138"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350.5, 420.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_3254",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/campaign/lineup_guide/element.png",
      capInsets = CCRectMake(25, 0, 17.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135, 414.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_3259",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/campaign/lineup_guide/element.png",
      capInsets = CCRectMake(25, 0, 17.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(564.5, 414.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(675.5, 304)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_3256",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(10, 96.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 398, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/campaign/lineup_guide/line.png",
      name = "ImageView_3257",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355.5, 92.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 192, h = 56.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350.5, 53.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(678.5, 427.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(249, 243, 166),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3259",
      z = 0,
      parent = "btn",
      text = T("\228\184\128\233\148\174\233\162\134\229\143\150"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_3261",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28)
    }
  }
}

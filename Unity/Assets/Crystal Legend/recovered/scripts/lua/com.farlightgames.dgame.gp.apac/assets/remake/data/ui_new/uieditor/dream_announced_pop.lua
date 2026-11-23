ed.uieditor = ed.uieditor or {}
ed.uieditor.dream_announced_pop = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 706, h = 357},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dreamland/dream_announce_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(507, 263)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      name = "boss1_fca_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(308, 175.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      name = "boss2_fca_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(505, 175.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      name = "boss3_fca_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(702, 175.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(152, 26)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(12.5, 0, 10, 10),
      res = "UI/alpha/1080P/dreamland/dream_announce_time.png",
      name = "boss1_label",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(308, 355)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(152, 26)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(12.5, 0, 10, 10),
      res = "UI/alpha/1080P/dreamland/dream_announce_time.png",
      name = "boss2_label",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(505, 355)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(152, 26)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(12.5, 0, 10, 10),
      res = "UI/alpha/1080P/dreamland/dream_announce_time.png",
      name = "boss3_label",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(702, 355)
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
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(677.5, 347)
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
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_6223",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(353, 331)
    }
  }
}

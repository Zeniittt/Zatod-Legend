ed.uieditor = ed.uieditor or {}
ed.uieditor.RaidSelectWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(781.5, 374.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 50, 350),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 226)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 768, h = 61},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/raid/banner.png",
      name = "bg_top",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(390.75, 337.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 918, h = 448.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_top",
      res = "UI/alpha/1080P/raid/title_ornament.png",
      name = "frame",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(384, -63.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(551, 369.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 340.5, h = 38},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_top",
      res = "UI/alpha/1080P/raid/battletimes_bg.png",
      name = "bg_discount",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(385, 32)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 311.5, h = 120},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/1080P/raid/handleofsword.png",
      name = "ImageView_16737",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(469, 447.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "icon_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
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
      name = "btn_back",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-37.75, 465.25)
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
      name = "label_numReward",
      z = 0,
      parent = "bg_top",
      text = "Text Label",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(261.5, 31)
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
      visible = true
    },
    t = "Label",
    base = {
      name = "label_discount",
      z = 0,
      parent = "bg_discount",
      text = T("\230\175\143\229\145\168\229\188\128\229\144\175\228\188\152\230\131\160\229\137\169\228\189\153\230\172\161\230\149\176\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(423.75, 4)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 114, 45),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_times",
      z = 0,
      parent = "bg_discount",
      text = "0/1",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(503.75, 3.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 163, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_top",
      res = "UI/alpha/1080P/raid/liveness_bg.png",
      name = "bg_liveness",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(774, 179)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(746.5, 294)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(17.75, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 393, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_top",
      res = "UI/alpha/1080P/raid/active_bg.png",
      name = "ImageView_23510",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(696.5, 171.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "ImageView_2427",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
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
      name = "label_liveness",
      z = 0,
      parent = "bg_liveness",
      text = "Text Label",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.5, 14)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 205, 77),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "frame",
      text = T("\229\155\162\233\152\159\229\137\175\230\156\172"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(459, 369.25)
    }
  }
}

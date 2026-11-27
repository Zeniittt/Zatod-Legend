ed.uieditor = ed.uieditor or {}
ed.uieditor.HotHeroWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(670, 400)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15, 10, 15, 10),
      res = "UI/alpha/1080P/common/main_vit_tips.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478.5, 247.5)
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
      name = "label_title",
      z = 0,
      parent = "bg",
      text = T("\232\191\156\229\190\129\231\131\173\233\151\168\232\139\177\233\155\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(335, 378.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 54, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(654, 383.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(637.5, 306.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(16, 16.5)
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
      name = "Label_3108",
      z = 0,
      parent = "bg",
      text = T("\231\130\185\229\135\187\232\139\177\233\155\132\229\164\180\229\131\143\229\143\175\230\159\165\231\156\139\232\175\166\231\187\134\228\191\161\230\129\175"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(330.5, 348.5)
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
      parent = "label_title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_886",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-48.5, 10)
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
      parent = "label_title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_887",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(156, 10)
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
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
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
      fix_scale = {y = 1, x = 7.999993},
      flip = "",
      opacity = 255,
      fix_wh = {w = 259.9997725, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Label_3108",
      res = "UI/alpha/1080P/crusade/sperator_line.png",
      name = "ImageView_3109",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117, -5.5)
    }
  }
}

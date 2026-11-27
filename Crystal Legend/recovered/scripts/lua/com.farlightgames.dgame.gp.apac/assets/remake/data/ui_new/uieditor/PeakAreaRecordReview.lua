ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaRecordReview = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 263, h = 385},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/toparena_review_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(458, 268.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.6, x = 1.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131.2, h = 31.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/rank/toparena_rankname_4.png",
      name = "image_rank_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139, 262)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 82.5000066, h = 82.5000066},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/rank/toparena_rank_icon_7.png",
      name = "image_rank_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(130.5, 332)
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
      name = "lebel_season",
      z = 0,
      parent = "image_bg",
      text = T("S1\232\181\155\229\173\163"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(127, 196.5)
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
      name = "lebel_time",
      z = 0,
      parent = "image_bg",
      text = "2021.10-2021.12",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(128, 172)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313.5, 400.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(225, 122.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "layer_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(17.5, 26)
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
      name = "label_1",
      z = 0,
      parent = "layer_detail",
      text = T("\230\156\128\233\171\152\230\142\146\229\144\141"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 100)
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
      name = "label_max_rank",
      z = 0,
      parent = "layer_detail",
      text = "1900",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(199.5, 99.5)
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
      name = "label_season_rank",
      z = 0,
      parent = "layer_detail",
      text = "800",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(199, 60)
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
      name = "label_2",
      z = 0,
      parent = "layer_detail",
      text = T("\232\181\155\229\173\163\230\142\146\229\144\141"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 60.5)
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
      name = "label_rank_start",
      z = 0,
      parent = "layer_detail",
      text = "1900",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(199.5, 21.5)
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
      name = "label_3",
      z = 0,
      parent = "layer_detail",
      text = T("\232\181\155\229\173\163\228\185\139\230\152\159"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 22)
    }
  }
}

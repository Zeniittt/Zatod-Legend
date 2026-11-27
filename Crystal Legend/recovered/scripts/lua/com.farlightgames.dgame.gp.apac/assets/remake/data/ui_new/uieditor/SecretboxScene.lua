ed.uieditor = ed.uieditor or {}
ed.uieditor.SecretboxScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 295, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newshop/secretbox/secretbox_title.png",
      name = "main_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 445)
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
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(644, 429.5)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 340, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newshop/secretbox/secretbox_refresh_bg.png",
      name = "bg_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 386)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(807.5, 24.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(40, 8, 1, 8.5),
      res = "UI/alpha/1080P/newshop/secretbox/secretbox_line_bg1.png",
      name = "bg_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(110, 177.5)
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
      name = "Label_1159",
      z = 0,
      parent = "bg_time",
      text = "Text Label",
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(170, 16)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(914.5, 300)
    },
    t = "Layer",
    base = {name = "layer_item", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(25, 90)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(247, 24.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bar",
      z = 2,
      parent = "bg_bar",
      res = "UI/alpha/1080P/newshop/secretbox/secretbox_line_1.png",
      capInsets = CCRectMake(20, 8, 798, 8.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0.5, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.5, h = 20.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/newshop/secretbox/secretbox_point.png",
      name = "point",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 441.5, h = 99.5},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newshop/integral_bg.png",
      name = "ImageView_74",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 60)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/newshop/secretbox/secretbox_progress_bg.png",
      name = "icon_cur",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.5, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 155),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cur",
      z = 0,
      parent = "icon_cur",
      text = T("\229\189\147\229\137\141"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.25, 34)
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
      name = "label_progress",
      z = 0,
      parent = "icon_cur",
      text = "2448",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.25, 18.5)
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
      name = "Label_75",
      z = 0,
      parent = "ImageView_74",
      text = T("\229\142\134\229\143\178\231\180\175\232\174\161\231\167\175\229\136\134:"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(220.75, 49.75)
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
      name = "total_score",
      z = 0,
      parent = "ImageView_74",
      text = "1234567",
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(220.75, 49.75)
    }
  }
}

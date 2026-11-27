ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaShopScene = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(268.5, 38.5)
    },
    t = "Layer",
    base = {name = "pan_title", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(71, 482.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 268.5, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_title",
      res = "UI/alpha/1080P/campaign/worldmap/worldmap_title_bg.png",
      name = "ImageView_1077",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134, 19)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(278, 30)
    },
    t = "Layer",
    base = {name = "pan_updata", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(491.5, 486)
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
      parent = "pan_title",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(206.5, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(820, 483)
    },
    t = "Layer",
    base = {name = "pan_item", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(70, 2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 278, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_updata",
      res = "UI/alpha/1080P/pvp/battlenum_bg.png",
      name = "ImageView_1082",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139, 15)
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
      name = "ImageView_1080",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1084",
      z = 0,
      parent = "pan_updata",
      text = T("\230\150\176\232\181\155\229\173\163\229\188\128\229\167\139\230\151\182\229\136\183\230\150\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141.5, 16)
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
      name = "price_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
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
      parent = "price_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_1080",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  }
}

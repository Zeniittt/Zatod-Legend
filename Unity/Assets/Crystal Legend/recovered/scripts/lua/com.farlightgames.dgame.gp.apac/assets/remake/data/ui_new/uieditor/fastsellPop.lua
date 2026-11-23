ed.uieditor = ed.uieditor or {}
ed.uieditor.fastsellPop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(600, 450)
    },
    t = "Layer",
    base = {name = "Panel_1109", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(575, 415)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_1106",
      z = 0,
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(12, 12, 15, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(300.5, 225)
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
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_1110",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207.5, 407)
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
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_1110_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(389.5, 407)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 227, 186),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "Panel_1109",
      text = T("\231\137\169\229\147\129\229\148\174\229\141\150"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(300, 408)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 6.75, h = 7.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/battle_star_lins.png",
      name = "ImageView_1113",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(300, 136.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(375, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line_l",
      z = 0,
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      capInsets = CCRectMake(20, 0, 40, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(297, 133.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(375, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line_r",
      z = 0,
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      capInsets = CCRectMake(20, 0, 40, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(303, 133.5)
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
      parent = "Panel_1109",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_yes",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(300, 60)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 228)
    },
    t = "Layer",
    base = {
      parent = "Panel_1109",
      name = "txt_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(26.5, 135.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(242, 211, 125),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title_Copy0",
      z = 0,
      parent = "Panel_1109",
      text = T("\230\152\175\229\144\166\229\176\134\228\187\165\228\184\139\230\151\160\231\148\168\231\137\169\229\147\129\229\141\150\231\187\153\229\149\134\228\186\186\239\188\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(300, 375.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(242, 211, 125),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title_Copy1",
      z = 0,
      parent = "Panel_1109",
      text = T("\229\143\175\232\142\183\229\190\151\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(246, 108)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_1109",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "img_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(295, 109)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(235, 168, 66),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_count",
      z = 0,
      parent = "Panel_1109",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(315.5, 108)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 48, 29),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1117",
      z = 0,
      parent = "btn_yes",
      text = T("\231\161\174\232\174\164\229\141\150\229\135\186"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 242, 166),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_1117_Copy0",
      z = 0,
      parent = "btn_yes",
      text = T("\231\161\174\232\174\164\229\141\150\229\135\186"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97, 29.25)
    }
  }
}

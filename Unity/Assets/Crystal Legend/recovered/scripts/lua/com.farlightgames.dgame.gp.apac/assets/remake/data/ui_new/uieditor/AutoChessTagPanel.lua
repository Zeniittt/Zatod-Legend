ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessTagPanel = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(260, 140)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(9.5, 11, 20, 199.5),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(-104, 49.5)
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
      parent = "bg",
      name = "layer_main",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-1.5, 138.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_main",
      res = "UI/alpha/1080P/chess/tag/herodetail_symbol_Blade.png",
      name = "node_tag_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, -26)
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
      name = "level",
      z = 1,
      parent = "layer_main",
      text = "2",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.5, -35)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(232.5, 266)
    },
    t = "Scale9Sprite",
    base = {
      name = "layer_hero_detail",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(10, 10, 19, 201.5)
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(255.5, 140)
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
      name = "label_effect",
      z = 0,
      parent = "layer_main",
      text = T("\231\178\190\231\129\181"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(65, -26)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc",
      z = 0,
      parent = "layer_main",
      text = T("tag\230\143\143\232\191\176"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(19, -57.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.4000001, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 228.5, h = 1.4000001},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_main",
      res = "UI/alpha/1080P/chess/battle/fine_line.png",
      name = "line1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(130, -48.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_hero_detail",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.5, 234)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.4000001, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 228.5, h = 1.4000001},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_main",
      res = "UI/alpha/1080P/chess/battle/fine_line.png",
      name = "line2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(130, -97.5)
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
      name = "name",
      z = 0,
      parent = "layer_hero_detail",
      text = T("\232\139\177\233\155\132\229\144\141\229\173\151\229\133\173\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(82, 245.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(5.5, 5)
    },
    t = "Layer",
    base = {
      parent = "layer_main",
      name = "node_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(18, -115)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5999972, h = 19.5999972},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_hero_detail",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "gold",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92, 221)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 53),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "gold_num",
      z = 0,
      parent = "layer_hero_detail",
      text = "5",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(106.5, 221.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_hero_detail",
      res = "UI/alpha/1080P/chess/battle/tag_tips_bg.png",
      name = "bg_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.5, 189.5)
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
      parent = "layer_hero_detail",
      name = "Panel_513",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(10, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 26.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_attr1",
      z = 0,
      parent = "Panel_513",
      res = "UI/alpha/1080P/chess/battle/tag_mask.png",
      capInsets = CCRectMake(10, 5, 10, 40)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106, 111)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 26.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_attr2",
      z = 0,
      parent = "Panel_513",
      res = "UI/alpha/1080P/chess/battle/tag_mask.png",
      capInsets = CCRectMake(10, 5, 10, 40)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106, 84)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.4000001, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205.65, h = 1.4000001},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_513",
      res = "UI/alpha/1080P/chess/battle/fine_line.png",
      name = "line3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106, 61)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_513",
      res = "UI/alpha/1080P/common/frame/equip_frame_mask.png",
      name = "icon_skill",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc_skill",
      z = 0,
      parent = "Panel_513",
      text = T("\230\138\128\232\131\189\230\143\143\232\191\176"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(61.5, 51.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_attr1",
      res = "UI/alpha/1080P/chess/battle/chess_hp.png",
      name = "img_attr_icon_hp",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_attr_hp",
      z = 2,
      parent = "bg_attr1",
      text = "123456",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(37, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_attr_ad",
      z = 2,
      parent = "bg_attr1",
      text = "123456",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(133, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_attr1",
      res = "UI/alpha/1080P/chess/battle/chess_atk.png",
      name = "img_attr_icon_ad",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.5, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_attr2",
      res = "UI/alpha/1080P/chess/battle/chess_arm.png",
      name = "img_attr_icon_arm",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_attr_arm",
      z = 2,
      parent = "bg_attr2",
      text = "123456",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(37, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_attr_crit",
      z = 2,
      parent = "bg_attr2",
      text = "123456",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(133, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_attr2",
      res = "UI/alpha/1080P/chess/battle/chess_mr.png",
      name = "img_attr_icon_crit",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.5, 13.25)
    }
  }
}

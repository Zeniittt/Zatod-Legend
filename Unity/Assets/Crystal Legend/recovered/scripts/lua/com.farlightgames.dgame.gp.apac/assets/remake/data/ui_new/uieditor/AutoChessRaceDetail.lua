ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessRaceDetail = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 477, h = 316},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chess/hero/bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(475.5, 330.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 169.5, h = 150},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/hero/bg_actor.png",
      name = "bg_actor",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(382, 192.5)
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
      name = "label_skill_desc",
      z = 1,
      parent = "bg",
      text = T("\230\138\128\232\131\189\230\143\143\232\191\176"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(86.5, 124.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15.5, 15.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "node_btn",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(66.5, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 147, h = 101},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_actor",
      res = "UI/alpha/1080P/chess/battle/base_4.png",
      name = "img_actor_base",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.75, 7)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15.5, 15.5)
    },
    t = "Layer",
    base = {
      parent = "img_actor_base",
      name = "node_actor",
      z = 10
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(71, 61.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_btn",
      res = "UI/alpha/1080P/chess/hero/btn_unselected.png",
      name = "btn_star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(177, 3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_btn",
      res = "UI/alpha/1080P/chess/hero/btn_unselected.png",
      name = "btn_star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(312.5, 3)
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
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(466, 310)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_bg.png",
      name = "node_head",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 255)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 62.999991, h = 62.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "node_skill",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 99.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(237, 151, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_hero_name",
      z = 0,
      parent = "node_head",
      text = T("\232\139\177\233\155\132\229\144\141\229\173\151"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(95, 70.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 265, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/hero/bg_attr.png",
      name = "bg_attr1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.5, 192)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 265, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/hero/bg_attr.png",
      name = "bg_attr2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.5, 158.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 474, h = 236.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/hero/bg_purple.png",
      name = "bg_info",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(238.5, 168.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15.5, 15.5)
    },
    t = "Layer",
    base = {
      parent = "node_head",
      name = "node_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(95, 39)
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
      name = "label_rare_title",
      z = 0,
      parent = "node_head",
      text = T("\229\147\129\233\152\182\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(96, 12.5)
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
      name = "label_rare",
      z = 0,
      parent = "node_head",
      text = T("\230\153\174\233\128\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(139, 12.5)
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
      position = ccp(28, 13.25)
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
      name = "label_price_title",
      z = 0,
      parent = "node_head",
      text = T("\228\187\183\230\160\188\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(196, 12)
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
      z = 0,
      parent = "bg_attr1",
      text = "123456",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(63.5, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.4, h = 22.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_head",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "ImageView_12879",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(249, 12)
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
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(191, 13.25)
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
      name = "label_price",
      z = 0,
      parent = "node_head",
      text = "0",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(262.5, 12)
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
      position = ccp(153.5, 13.25)
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
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(63.5, 13.25)
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
      position = ccp(28, 13.25)
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
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(191, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_btn",
      res = "UI/alpha/1080P/chess/hero/btn_unselected.png",
      name = "btn_star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 3)
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
      position = ccp(153.5, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_star1",
      res = "UI/alpha/1080P/chess/hero/btn_selected.png",
      name = "btn_star1_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.1999973, h = 16.49999725},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_star1",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "ImageView_12904",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 44},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_star2",
      res = "UI/alpha/1080P/chess/hero/btn_selected.png",
      name = "btn_star2_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.1999973, h = 16.49999725},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_star2",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "ImageView_12904_Copy0",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.1999973, h = 16.49999725},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_star2",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "ImageView_12904_Copy1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.1999973, h = 16.49999725},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_star3",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "ImageView_12904_Copy2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.1999973, h = 16.49999725},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_star3",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "ImageView_12904_Copy3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.1999973, h = 16.49999725},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_star3",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "ImageView_12904_Copy4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 44},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_star3",
      res = "UI/alpha/1080P/chess/hero/btn_selected.png",
      name = "btn_star3_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 22)
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
      name = "ImageView_1645",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  }
}

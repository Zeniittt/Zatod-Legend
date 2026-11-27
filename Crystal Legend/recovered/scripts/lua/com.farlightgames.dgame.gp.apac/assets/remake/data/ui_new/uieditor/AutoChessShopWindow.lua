ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessShopWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 271.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chess/battle/shop_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 289)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 119, h = 119},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/chess/battle/chess_shop_refresh.png",
      name = "btn_refresh",
      z = 5,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/chess/battle/chess_shop_refresh.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1075, 96.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1.3},
      flip = "",
      opacity = 160,
      fix_wh = {w = 689, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/shop_probability.png",
      name = "img_chess_rate",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(816, -9.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(390.5, 19.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_chess_rate",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(643.5, -18.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.399998656, h = 22.399998656},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_refresh",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "img_cost_gold",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 73.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(85, 150.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_hero_1",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(229.5, 69.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 15),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cost_num",
      z = 10,
      parent = "btn_refresh",
      text = "0",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70, 73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_chess_rate",
      res = "UI/alpha/1080P/chess/battle/chess_1.png",
      name = "img_chess_rate_1",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120, 11)
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
      name = "label_chess_rate_1",
      z = 0,
      parent = "Panel_chess_rate",
      text = "0%",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(134, 9)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_chess_rate",
      res = "UI/alpha/1080P/chess/battle/chess_2.png",
      name = "img_chess_rate_2",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(208.5, 10.5)
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
      parent = "panel_hero_1",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "img_cost_hero_1",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, -34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 15),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cost_hero_1",
      z = 5,
      parent = "panel_hero_1",
      text = "0",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.5, -35)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 120,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_exit_tip",
      z = 0,
      parent = "bg",
      text = T("\231\130\185\229\135\187\231\169\186\231\153\189\229\164\132\229\141\179\229\143\175\229\133\179\233\151\173"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, -36.75)
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
      name = "label_chess_rate_2",
      z = 0,
      parent = "Panel_chess_rate",
      text = "0%",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(219.5, 9)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 136, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_1",
      res = "UI/alpha/1080P/chess/battle/shop_heroname_bg.png",
      name = "img_name_bg_1",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(800, 196)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_touch_rect",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(190.5, 46.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_chess_rate",
      res = "UI/alpha/1080P/chess/battle/chess_3.png",
      name = "img_chess_rate_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(287.5, 11)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(7.5, 7.5)
    },
    t = "Layer",
    base = {
      parent = "panel_hero_1",
      name = "node_hero_1",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(41, 39)
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
      parent = "panel_hero_1",
      res = "UI/alpha/1080P/chess/battle/base_1.png",
      name = "img_base_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 28)
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
      name = "label_chess_rate_3",
      z = 0,
      parent = "Panel_chess_rate",
      text = "0%",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(299.5, 9)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 65.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_1",
      res = "UI/alpha/1080P/chess/battle/shop_heroname_tips_bg.png",
      name = "img_hero_have_1",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 170)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85.5, h = 85.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/lock.png",
      name = "img_lock",
      z = 100
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114, 86.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_chess_rate",
      res = "UI/alpha/1080P/chess/battle/chess_4.png",
      name = "img_chess_rate_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(374, 11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 234, 197),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_refresh_title",
      z = 10,
      parent = "btn_refresh",
      text = T("\229\136\183\230\150\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60, 49.5)
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
      name = "label_chess_rate_4",
      z = 0,
      parent = "Panel_chess_rate",
      text = "0%",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(389.5, 9)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_chess_rate",
      res = "UI/alpha/1080P/chess/battle/chess_5.png",
      name = "img_chess_rate_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(455, 11)
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
      name = "label_chess_rate_5",
      z = 0,
      parent = "Panel_chess_rate",
      text = "0%",
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(470, 9)
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
      name = "label_name_1",
      z = 5,
      parent = "img_name_bg_1",
      text = T("\232\139\177\233\155\132\229\144\141\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(173, 155, 131),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_team_level_title",
      z = 0,
      parent = "Panel_chess_rate",
      text = "Lv.",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 9)
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
      name = "label_team_level",
      z = 0,
      parent = "Panel_chess_rate",
      text = "5",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(32.5, 9.5)
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
      parent = "img_base_1",
      res = "UI/alpha/1080P/chess/battle/base_light_1.png",
      name = "img_light_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73.5, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 185, 147),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_have_1",
      z = 0,
      parent = "img_hero_have_1",
      text = T("\229\183\178\230\139\165\230\156\137"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.5, 32.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(85, 150.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_hero_2",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(395, 69.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(85, 150.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_hero_3",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(553.5, 69.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(85, 150.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_hero_4",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(696, 69.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(85, 150.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_hero_5",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(845.5, 69.25)
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
      parent = "panel_hero_2",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "img_cost_hero_2",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, -34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 15),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cost_hero_2",
      z = 5,
      parent = "panel_hero_2",
      text = "0",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.5, -35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 136, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_2",
      res = "UI/alpha/1080P/chess/battle/shop_heroname_bg.png",
      name = "img_name_bg_2",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(7.5, 7.5)
    },
    t = "Layer",
    base = {
      parent = "panel_hero_2",
      name = "node_hero_2",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(41, 39)
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
      parent = "panel_hero_2",
      res = "UI/alpha/1080P/chess/battle/base_1.png",
      name = "img_base_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 65.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_2",
      res = "UI/alpha/1080P/chess/battle/shop_heroname_tips_bg.png",
      name = "img_hero_have_2",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 170)
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
      parent = "panel_hero_3",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "img_cost_hero_3",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, -34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 15),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cost_hero_3",
      z = 5,
      parent = "panel_hero_3",
      text = "0",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.5, -35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 136, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_3",
      res = "UI/alpha/1080P/chess/battle/shop_heroname_bg.png",
      name = "img_name_bg_3",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(7.5, 7.5)
    },
    t = "Layer",
    base = {
      parent = "panel_hero_3",
      name = "node_hero_3",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(41, 39)
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
      parent = "panel_hero_3",
      res = "UI/alpha/1080P/chess/battle/base_1.png",
      name = "img_base_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 65.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_3",
      res = "UI/alpha/1080P/chess/battle/shop_heroname_tips_bg.png",
      name = "img_hero_have_3",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 170)
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
      parent = "panel_hero_4",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "img_cost_hero_4",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, -34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 15),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cost_hero_4",
      z = 5,
      parent = "panel_hero_4",
      text = "0",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.5, -35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 136, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_4",
      res = "UI/alpha/1080P/chess/battle/shop_heroname_bg.png",
      name = "img_name_bg_4",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(7.5, 7.5)
    },
    t = "Layer",
    base = {
      parent = "panel_hero_4",
      name = "node_hero_4",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(41, 39)
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
      parent = "panel_hero_4",
      res = "UI/alpha/1080P/chess/battle/base_1.png",
      name = "img_base_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 65.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_4",
      res = "UI/alpha/1080P/chess/battle/shop_heroname_tips_bg.png",
      name = "img_hero_have_4",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 170)
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
      parent = "panel_hero_5",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "img_cost_hero_5",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, -34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 15),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cost_hero_5",
      z = 5,
      parent = "panel_hero_5",
      text = "0",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.5, -35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 136, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_5",
      res = "UI/alpha/1080P/chess/battle/shop_heroname_bg.png",
      name = "img_name_bg_5",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(7.5, 7.5)
    },
    t = "Layer",
    base = {
      parent = "panel_hero_5",
      name = "node_hero_5",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(41, 39)
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
      parent = "panel_hero_5",
      res = "UI/alpha/1080P/chess/battle/base_1.png",
      name = "img_base_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 65.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_5",
      res = "UI/alpha/1080P/chess/battle/shop_heroname_tips_bg.png",
      name = "img_hero_have_5",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 170)
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
      name = "label_name_2",
      z = 5,
      parent = "img_name_bg_2",
      text = T("\232\139\177\233\155\132\229\144\141\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, 13.5)
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
      parent = "img_base_2",
      res = "UI/alpha/1080P/chess/battle/base_light_1.png",
      name = "img_light_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73.5, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 185, 147),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_have_2",
      z = 0,
      parent = "img_hero_have_2",
      text = T("\229\183\178\230\139\165\230\156\137"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.5, 32.75)
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
      name = "label_name_3",
      z = 5,
      parent = "img_name_bg_3",
      text = T("\232\139\177\233\155\132\229\144\141\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, 13.5)
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
      parent = "img_base_3",
      res = "UI/alpha/1080P/chess/battle/base_light_1.png",
      name = "img_light_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73.5, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 185, 147),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_have_3",
      z = 0,
      parent = "img_hero_have_3",
      text = T("\229\183\178\230\139\165\230\156\137"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.5, 32.75)
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
      name = "label_name_4",
      z = 5,
      parent = "img_name_bg_4",
      text = T("\232\139\177\233\155\132\229\144\141\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, 13.5)
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
      parent = "img_base_4",
      res = "UI/alpha/1080P/chess/battle/base_light_1.png",
      name = "img_light_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73.5, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 185, 147),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_have_4",
      z = 0,
      parent = "img_hero_have_4",
      text = T("\229\183\178\230\139\165\230\156\137"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.5, 32.75)
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
      name = "label_name_5",
      z = 5,
      parent = "img_name_bg_5",
      text = T("\232\139\177\233\155\132\229\144\141\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, 13.5)
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
      parent = "img_base_5",
      res = "UI/alpha/1080P/chess/battle/base_light_1.png",
      name = "img_light_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73.5, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 185, 147),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_have_5",
      z = 0,
      parent = "img_hero_have_5",
      text = T("\229\183\178\230\139\165\230\156\137"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.5, 32.75)
    }
  }
}

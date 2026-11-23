ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloSelectHeroWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 50)
    },
    t = "Layer",
    base = {
      name = "panel_hero_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(305, 300)
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
      name = "name1",
      z = 4,
      parent = "panel_hero_1",
      text = T("\232\139\177\233\155\132\229\144\141\229\173\151"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-3, -67.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 189, h = 215.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_1",
      res = "UI/alpha/1080P/chesscard/hero/bg_8.png",
      name = "bg_selected1",
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
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 157.99999052, h = 57.99999652},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/main/teammatch_bg.png",
      name = "btn_ok",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 107)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 106, h = 106},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_1",
      res = "UI/alpha/1080P/chesscard/hero/hero_unlock.png",
      name = "icon1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 148, h = 172.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_1",
      res = "UI/alpha/1080P/chesscard/hero/bg_7.png",
      name = "frame1",
      z = 2
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
      fix_wh = {w = 236, h = 335},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/hero/bg_9.png",
      name = "bg_herodetail",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(245.5, 305.5)
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
      name = "Label_443",
      z = 0,
      parent = "btn_ok",
      text = T("\231\161\174\232\174\164"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(98.75, 36.25)
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
      name = "panel_hero_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 300)
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
      name = "panel_hero_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(655, 300)
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
      parent = "bg_herodetail",
      text = T("\232\139\177\233\155\132\229\144\141\229\173\151"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.5, 313.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 196.399988216, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_herodetail",
      res = "UI/alpha/1080P/chesscard/hero/bg_4.png",
      name = "node_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.5, 271)
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
      name = "node_factions",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 50)
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
      name = "label_faction_tip",
      z = 1,
      parent = "bg_herodetail",
      text = T("\230\142\168\232\141\144\230\181\129\230\180\190"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90.5, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.77, x = 0.77},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.1, h = 23.87},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_herodetail",
      res = "UI/alpha/1080P/chesscard/faction.png",
      name = "faction1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139.5, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68.5, h = 68.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chesscard/hero/btn_refresh.png",
      name = "btn_refresh",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(850, 117)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_herodetail",
      res = "UI/alpha/1080P/chesscard/hero/bg_icon_pasv.png",
      name = "icon_skill1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 123)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 189, h = 215.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_2",
      res = "UI/alpha/1080P/chesscard/hero/bg_8.png",
      name = "bg_selected2",
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
      fix_scale = {y = 0.77, x = 0.77},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.1, h = 23.87},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_herodetail",
      res = "UI/alpha/1080P/chesscard/faction.png",
      name = "faction2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(171, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105.0000084, h = 105.0000084},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_2",
      res = "UI/DOTA-HERO/AM.jpg",
      name = "icon2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_herodetail",
      res = "UI/alpha/1080P/chesscard/hero/icon_hp.png",
      name = "img_attr_icon_hp",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 234.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 148, h = 172.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_2",
      res = "UI/alpha/1080P/chesscard/hero/bg_7.png",
      name = "frame2",
      z = 2
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
      fix_wh = {w = 13, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_herodetail",
      res = "UI/alpha/1080P/chesscard/hero/icon_mpr.png",
      name = "img_attr_icon_mp",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140.5, 234.5)
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
      name = "name2",
      z = 4,
      parent = "panel_hero_2",
      text = T("\232\139\177\233\155\132\229\144\141\229\173\151"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-3, -67.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_herodetail",
      res = "UI/alpha/1080P/chesscard/hero/icon_speed.png",
      name = "img_attr_icon_speed",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 208.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 189, h = 215.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_3",
      res = "UI/alpha/1080P/chesscard/hero/bg_8.png",
      name = "bg_selected3",
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
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_herodetail",
      res = "UI/alpha/1080P/chesscard/4.png",
      name = "img_attr_icon_atk",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140.5, 208.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105.0000084, h = 105.0000084},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_3",
      res = "UI/DOTA-HERO/AM.jpg",
      name = "icon3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_herodetail",
      res = "UI/alpha/1080P/chesscard/hero/icon_dodg.png",
      name = "img_attr_icon_sb",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 182.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 148, h = 172.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_hero_3",
      res = "UI/alpha/1080P/chesscard/hero/bg_7.png",
      name = "frame3",
      z = 2
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
      fix_wh = {w = 17.5, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_herodetail",
      res = "UI/alpha/1080P/chesscard/hero/icon_crit.png",
      name = "img_attr_icon_crit",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140.5, 182.5)
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
      name = "name3",
      z = 4,
      parent = "panel_hero_3",
      text = T("\232\139\177\233\155\132\229\144\141\229\173\151"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-3, -67.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_herodetail",
      res = "UI/alpha/1080P/chesscard/hero/bg_icon_ult.png",
      name = "icon_skill2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 53.5)
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
      name = "label_skill_desc1",
      z = 0,
      parent = "icon_skill1",
      text = T("\230\138\128\232\131\189\230\143\143\232\191\176"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(56.5, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(237, 214, 147),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_skill_name1",
      z = 0,
      parent = "icon_skill1",
      text = T("\230\138\128\232\131\189\230\143\143\232\191\176"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(56.5, 40)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60.5, h = 17},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "icon_skill1",
      res = "UI/alpha/1080P/chesscard/hero/tip_skill_pasv.png",
      name = "bg_tag1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 4)
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
      parent = "btn_refresh",
      res = "UI/alpha/1080P/chesscard/hero/point_refresh.png",
      name = "ImageView_9031",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.25, 60.75)
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
      name = "label_attr_hp1",
      z = 2,
      parent = "img_attr_icon_hp",
      text = T("\231\148\159\229\145\189:"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17, 7.5)
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
      name = "label_attr_hp",
      z = 0,
      parent = "img_attr_icon_hp",
      text = "1000",
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(49.5, 7.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 70.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_refresh",
      res = "UI/alpha/1080P/chesscard/hero/bg_refresh.png",
      name = "ImageView_191",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.25, -1.75)
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
      name = "label_attr_mp",
      z = 0,
      parent = "img_attr_icon_mp",
      text = "1000",
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(47.5, 8)
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
      name = "label_attr_mp1",
      z = 2,
      parent = "img_attr_icon_mp",
      text = T("\229\155\158\232\147\157:"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(15, 8)
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
      name = "label_attr_speed",
      z = 0,
      parent = "img_attr_icon_speed",
      text = "1000",
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(47.75, 8.25)
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
      name = "label_attr_speed1",
      z = 2,
      parent = "img_attr_icon_speed",
      text = T("\230\148\187\233\128\159:"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(15.25, 8.25)
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
      name = "label_attr_atk",
      z = 0,
      parent = "img_attr_icon_atk",
      text = "1000",
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(49, 8)
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
      name = "tag1",
      z = 0,
      parent = "bg_tag1",
      text = T("\229\164\167\230\139\155"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.25, 9)
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
      name = "label_attr_atk1",
      z = 2,
      parent = "img_attr_icon_atk",
      text = T("\230\148\187\229\135\187:"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.5, 8)
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
      name = "label_attr_sb",
      z = 0,
      parent = "img_attr_icon_sb",
      text = "1000",
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(48.25, 8)
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
      name = "label_attr_sb1",
      z = 2,
      parent = "img_attr_icon_sb",
      text = T("\233\151\170\233\129\191:"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(15.75, 8)
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
      name = "label_attr_crit",
      z = 0,
      parent = "img_attr_icon_crit",
      text = "1000",
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(49.75, 7.75)
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
      name = "label_attr_crit1",
      z = 2,
      parent = "img_attr_icon_crit",
      text = T("\230\154\180\229\135\187:"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.25, 7.75)
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
      name = "label_skill_desc2",
      z = 0,
      parent = "icon_skill2",
      text = T("\230\138\128\232\131\189\230\143\143\232\191\176"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(56.5, 19)
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
      name = "Label_9032",
      z = 0,
      parent = "ImageView_9031",
      text = "1",
      size = 16
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
      fix_wh = {w = 22.5, h = 26.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_refresh",
      res = "UI/alpha/1080P/chesscard/hero/icon_refresh_item.png",
      name = "ImageView_3084",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.25, 81.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(237, 214, 147),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_skill_name2",
      z = 0,
      parent = "icon_skill2",
      text = T("\230\138\128\232\131\189\230\143\143\232\191\176"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(56.5, 39)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 60.5, h = 17},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "icon_skill2",
      res = "UI/alpha/1080P/chesscard/hero/tip_skill_ult.png",
      name = "bg_tag2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_192",
      z = 0,
      parent = "ImageView_191",
      text = T("\229\136\183\230\150\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 10.75)
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
      name = "tag2",
      z = 0,
      parent = "bg_tag2",
      text = T("\229\164\169\232\181\139"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(30.25, 8.5)
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
      name = "Label_3085",
      z = 0,
      parent = "ImageView_3084",
      text = "3/3",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(26.25, 13.25)
    }
  }
}

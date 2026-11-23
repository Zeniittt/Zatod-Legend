ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildSearchScene = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "layer_btn", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/shop/shop_tab_unchoose.png",
      name = "btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.5, 369.5)
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
      parent = "btn2",
      name = "unchoose_btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(79.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 167, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_u_btn2",
      z = 0,
      parent = "unchoose_btn2",
      text = T("\229\136\155\229\187\186\229\133\172\228\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-22.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unchoose_btn2",
      res = "UI/alpha/1080P/guild/create_tab_1.png",
      name = "icon_u_btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-37.5, 0)
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
      parent = "unchoose_btn2",
      res = "UI/alpha/1080P/shop/shop_point_unchoose.png",
      name = "desc_u_btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-58.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/shop/shop_tab_choose.png",
      name = "choose_btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.5, 369.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(131.5, 39.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(5, 5, 67.5, 25.5),
      res = "UI/alpha/1080P/common/button_com_sys.png",
      name = "btn_quit_guild",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.5, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/shop/shop_tab_unchoose.png",
      name = "btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124, 432.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "choose_btn2",
      res = "UI/alpha/1080P/guild/create_tab.png",
      name = "icon_btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.5, 29.25)
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
      parent = "choose_btn2",
      res = "UI/alpha/1080P/shop/shop_point_choose.png",
      name = "desc_btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/shop/shop_tab_choose.png",
      name = "choose_btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.5, 433)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 217),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn2",
      z = 0,
      parent = "choose_btn2",
      text = T("\229\136\155\229\187\186\229\133\172\228\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(56.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(208, 499)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/shop/shop_tab_unchoose.png",
      name = "btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124.5, 306)
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
      name = "Label_12371",
      z = 0,
      parent = "btn_quit_guild",
      text = T("\233\128\128\229\135\186\229\133\172\228\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.75, 21.25)
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
      parent = "btn1",
      name = "unchoose_btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(79.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/shop/shop_tab_choose.png",
      name = "choose_btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133, 306)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(697.5, 450)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 44.5, 351),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg_main",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(220.5, 13)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 158.5, h = 58.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/shop/shop_tab_unchoose.png",
      name = "btn4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124.5, 243)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "choose_btn1",
      res = "UI/alpha/1080P/guild/recommend_tab.png",
      name = "icon_btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 167, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_u_btn1",
      z = 0,
      parent = "unchoose_btn1",
      text = T("\230\142\168\232\141\144\229\133\172\228\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-22.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unchoose_btn1",
      res = "UI/alpha/1080P/guild/recommend_tab_1.png",
      name = "icon_u_btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-37.5, 0)
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
      parent = "choose_btn1",
      res = "UI/alpha/1080P/shop/shop_point_choose.png",
      name = "desc_btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20, 29.25)
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
      parent = "unchoose_btn1",
      res = "UI/alpha/1080P/shop/shop_point_unchoose.png",
      name = "desc_u_btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-58.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 175, h = 58.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/shop/shop_tab_choose.png",
      name = "choose_btn4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133, 243)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 217),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn1",
      z = 0,
      parent = "choose_btn1",
      text = T("\230\142\168\232\141\144\229\133\172\228\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(56.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 127, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/guild/title_search.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85.25, 16.75)
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
      parent = "btn3",
      name = "unchoose_btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(79.25, 29.25)
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
      parent = "bg_title",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172.75, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "choose_btn3",
      res = "UI/alpha/1080P/guild/seach_tab.png",
      name = "icon_btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.5, 29.25)
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
      parent = "choose_btn3",
      res = "UI/alpha/1080P/shop/shop_point_choose.png",
      name = "desc_btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 217),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn3",
      z = 0,
      parent = "choose_btn3",
      text = T("\230\159\165\230\137\190\229\133\172\228\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(56.5, 29.25)
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
      parent = "bg_main",
      name = "layer1",
      z = 0
    },
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
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "btn4",
      name = "unchoose_btn4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(79.25, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 167, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_u_btn3",
      z = 0,
      parent = "unchoose_btn3",
      text = T("\230\159\165\230\137\190\229\133\172\228\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-22.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unchoose_btn3",
      res = "UI/alpha/1080P/guild/seach_tab_1.png",
      name = "icon_u_btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-37.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn4",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "red_btn4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.25, 52.75)
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
      parent = "unchoose_btn3",
      res = "UI/alpha/1080P/shop/shop_point_unchoose.png",
      name = "desc_u_btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-58.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg_main",
      name = "layer2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(348.5, 222.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg_main",
      name = "layer3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(348.5, 222.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "choose_btn4",
      res = "UI/alpha/1080P/guild/guild_enlist/tab_unselected.png",
      name = "icon_btn4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.5, 29.25)
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
      fix_wh = {w = 16, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "choose_btn4",
      res = "UI/alpha/1080P/shop/shop_point_choose.png",
      name = "desc_btn4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg_main",
      name = "layer4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(348.5, 222.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 217),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_btn4",
      z = 0,
      parent = "choose_btn4",
      text = T("\230\139\155\229\139\159\229\164\167\229\142\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(56.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "choose_btn4",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "red_choose_btn4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153, 52.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 183, 137),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "info",
      z = 0,
      parent = "layer1",
      text = T("\229\133\172\228\188\154\228\191\161\230\129\175"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106, 425)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 167, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_u_btn4",
      z = 0,
      parent = "unchoose_btn4",
      text = T("\230\139\155\229\139\159\229\164\167\229\142\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-22.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "unchoose_btn4",
      res = "UI/alpha/1080P/guild/guild_enlist/tab_selected.png",
      name = "icon_u_btn4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-37.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 183, 137),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "num",
      z = 0,
      parent = "layer1",
      text = T("\228\186\186\230\149\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(217, 426)
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
      parent = "unchoose_btn4",
      res = "UI/alpha/1080P/shop/shop_point_unchoose.png",
      name = "desc_u_btn4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-58.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 183, 137),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "slogan",
      z = 0,
      parent = "layer1",
      text = T("\230\139\155\229\139\159\229\174\163\232\168\128"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(319.5, 426)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 183, 137),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "cond",
      z = 0,
      parent = "layer1",
      text = T("\231\148\179\232\175\183\230\157\161\228\187\182"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(435.5, 426)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 183, 137),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "vitality",
      z = 0,
      parent = "layer1",
      text = T("3\230\151\165\230\180\187\232\183\131\229\186\166"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(529.5, 426)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1.30000007},
      flip = "",
      opacity = 255,
      fix_wh = {w = 267.150014385, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer2",
      res = "UI/alpha/1080P/package/bg_compose.png",
      name = "bg_title_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 195)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 12.5, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1",
      res = "UI/alpha/1080P/guild/splitline.png",
      name = "line1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183.5, 426)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line5",
      z = 0,
      parent = "layer2",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      capInsets = CCRectMake(33, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205, 192.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 12.5, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1",
      res = "UI/alpha/1080P/guild/splitline.png",
      name = "line2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(255, 426)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line6",
      z = 0,
      parent = "layer2",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      capInsets = CCRectMake(33, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-205, 192.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 12.5, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1",
      res = "UI/alpha/1080P/guild/splitline.png",
      name = "line3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(373.5, 426)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 247, 237),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title_2",
      z = 1,
      parent = "layer2",
      text = T("\229\136\155\229\187\186\229\133\172\228\188\154"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 195)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 12.5, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1",
      res = "UI/alpha/1080P/guild/splitline.png",
      name = "line4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 426)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name_2",
      z = 0,
      parent = "layer2",
      text = T("\229\133\172\228\188\154\229\144\141\231\167\176\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-139.5, 102)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guildid",
      z = 0,
      parent = "layer3",
      text = T("\229\133\172\228\188\154ID\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(-151, 121)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 20.8000031},
      flip = "",
      opacity = 255,
      fix_wh = {w = 676.00010075, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer1",
      res = "UI/alpha/1080P/crusade/sperator_line.png",
      name = "sperator_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(348.5, 412)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_icon",
      z = 0,
      parent = "layer2",
      text = T("\229\133\172\228\188\154\229\155\190\230\160\135\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-139.5, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 341.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer3",
      res = "UI/alpha/1080P/guild/setup_rename_bg.png",
      name = "bg_input1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 121)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(670, 392.5)
    },
    t = "Layer",
    base = {
      parent = "layer1",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(14, 16.5)
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
      parent = "layer2",
      res = "UI/alpha/1080P/common/frame/equip_frame_green.png",
      name = "icon_guild",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-35, -1)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(90, 45)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_search",
      z = 0,
      parent = "layer3",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(5, 10, 67.5, 17)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250, 119)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 341.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer2",
      res = "UI/alpha/1080P/guild/setup_rename_bg.png",
      name = "bg_input",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84.5, 101)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1.30000007},
      flip = "",
      opacity = 255,
      fix_wh = {w = 267.150014385, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer3",
      res = "UI/alpha/1080P/package/bg_compose.png",
      name = "bg_title_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 195)
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
      parent = "layer2",
      name = "layer_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 247, 237),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title_3",
      z = 1,
      parent = "layer3",
      text = T("\230\159\165\230\137\190\229\133\172\228\188\154"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 195)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1.30000007},
      flip = "",
      opacity = 255,
      fix_wh = {w = 267.150014385, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer4",
      res = "UI/alpha/1080P/package/bg_compose.png",
      name = "bg_title_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 195)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line7",
      z = 0,
      parent = "layer3",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      capInsets = CCRectMake(33, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205, 192.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 247, 237),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title_3",
      z = 1,
      parent = "layer4",
      text = T("\230\139\155\229\139\159\229\164\167\229\142\133"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 195)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line8",
      z = 0,
      parent = "layer3",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      capInsets = CCRectMake(33, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-205, 192.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line7",
      z = 0,
      parent = "layer4",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      capInsets = CCRectMake(33, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205, 192.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(674, 75)
    },
    t = "Scale9Sprite",
    base = {
      name = "search_item",
      z = 0,
      parent = "layer3",
      res = "UI/alpha/1080P/crusade/bg_replay_item.png",
      capInsets = CCRectMake(5, 5, 543, 77)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0.5, 51)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line8",
      z = 0,
      parent = "layer4",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      capInsets = CCRectMake(33, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-205, 192.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer4",
      res = "UI/alpha/1080P/common/button_mini_sys.png",
      name = "btn_up",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-123, -166)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer4",
      res = "UI/alpha/1080P/common/button_mini_sys.png",
      name = "btn_down",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.5, -168)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(137, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_cancel",
      z = 0,
      parent = "layer4",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(25, 0, 51.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(255.5, -168)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(660, 377)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_bj",
      z = 0,
      parent = "layer4",
      res = "UI/alpha/1080P/common/mail_bj9.png",
      capInsets = CCRectMake(12.5, 31, 49.5, 250)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -15.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_ttile_str",
      z = 0,
      parent = "layer4",
      text = T("\231\153\187\232\174\176\231\154\132\229\134\146\233\153\169\232\128\133\228\188\154\232\162\171\230\142\168\232\141\144\231\187\153\229\156\168\230\139\155\228\186\186\231\154\132\229\133\172\228\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 153.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.6, h = 57.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer4",
      res = "UI/alpha/1080P/main/main_icon_bg.png",
      name = "recruitBtn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-279, -155.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(140, 40)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_pages",
      z = 0,
      parent = "layer4",
      res = "UI/alpha/1080P/goback/goods/goback_goods_sold_out.png",
      capInsets = CCRectMake(10, 10, 20, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -166)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 265)
    },
    t = "Layer",
    base = {
      parent = "layer4",
      name = "Panel_443",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-324.5, -123)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "layer4",
      name = "Panel_shield",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(241, 193)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(166, 154, 141),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_124434",
      z = 0,
      parent = "bg_input1",
      text = T("\229\156\168\230\173\164\232\190\147\229\133\165\229\133\172\228\188\154ID"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18.25, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(98, 41)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_change_icon",
      z = 0,
      parent = "label_icon",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(5, 10, 67.5, 17)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(475, 18.5)
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
      name = "label_find",
      z = 0,
      parent = "btn_search",
      text = T("\230\159\165\230\137\190"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(166, 154, 141),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_12441",
      z = 0,
      parent = "bg_input",
      text = T("\229\156\168\230\173\164\232\190\147\229\133\165\229\133\172\228\188\154\229\144\141\231\167\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18.25, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(645, 5)
    },
    t = "Scale9Sprite",
    base = {
      name = "sperator_line",
      z = 0,
      parent = "layer_bottom",
      res = "UI/alpha/1080P/campaign/campaign_detail_line_1.png",
      capInsets = CCRectMake(100, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -87.5)
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
      parent = "layer_bottom",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "icon_diamond",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-15, -114.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.5, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_bottom",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_create",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -161)
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
      name = "label_diamondnum",
      z = 0,
      parent = "layer_bottom",
      text = "500",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, -114.5)
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
      name = "name_3",
      z = 0,
      parent = "search_item",
      text = T("\229\133\172\228\188\154\229\144\141\229\173\151\229\135\160\228\184\170\229\173\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124.5, 37.5)
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
      name = "Label_12442",
      z = 0,
      parent = "btn_up",
      text = T("\228\184\138\228\184\128\233\161\181"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21.5)
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
      name = "member_3",
      z = 0,
      parent = "search_item",
      text = "5/50",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207.5, 37.5)
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
      name = "slogan_3",
      z = 0,
      parent = "search_item",
      text = T("\230\139\155\229\139\159\229\174\163\232\168\128"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(314, 37.5)
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
      name = "cond_3",
      z = 0,
      parent = "search_item",
      text = T("\231\173\137\231\186\167>32\231\186\167"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(427.5, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "search_item",
      res = "UI/alpha/1080P/common/frame/equip_frame_green.png",
      name = "icon_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.5, 37.5)
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
      name = "Label_12442",
      z = 0,
      parent = "btn_down",
      text = T("\228\184\139\228\184\128\233\161\181"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 243, 223),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "vitality_3",
      z = 0,
      parent = "search_item",
      text = T("\230\180\187\232\183\131"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(520, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(147, 255, 126),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "vitality_num_3",
      z = 0,
      parent = "search_item",
      text = "99999",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(520.5, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 92.5, h = 39},
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
      normal = "UI/alpha/1080P/package/btn_package2.png",
      name = "btn_apply_3",
      z = 0,
      parent = "search_item",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(614, 37.5)
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
      name = "btn_cancel_str",
      z = 0,
      parent = "btn_cancel",
      text = T("\229\143\150\230\182\136\231\153\187\232\174\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_cancel",
      res = "UI/alpha/1080P/guild/guild_enlist/icon_deleteentry.png",
      name = "ImageView_442",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.5, 21)
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
      name = "label_changeIcon",
      z = 0,
      parent = "btn_change_icon",
      text = T("\228\191\174\230\148\185\229\155\190\230\160\135"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.399997576, h = 43.199997408},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "recruitBtn",
      res = "UI/alpha/1080P/guild/guild_enlist/icon_enlistservice.png",
      name = "ImageView_435_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, 24)
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
      name = "Label_437",
      z = 0,
      parent = "recruitBtn",
      text = T("\230\139\155\229\139\159\230\156\141\229\138\161"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.5, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "recruitBtn",
      res = "UI/alpha/1080P/guild/guild_enlist/icon_enlistservice_on.png",
      name = "recruitImg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "recruitBtn",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "recruitBtnRed",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(107, 97, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_page_right",
      z = 0,
      parent = "ImageView_pages",
      text = "/99",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(68.5, 20)
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
      name = "label_page_left",
      z = 0,
      parent = "ImageView_pages",
      text = "99",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(68, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.82, x = 0.82},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.18, h = 41.41},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_shield",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_3.png",
      name = "ImageView_shield",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
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
      name = "Label_488",
      z = 0,
      parent = "Panel_shield",
      text = T("\229\177\143\232\148\189\229\133\172\228\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(54.5, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79.05, h = 15.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_shield",
      res = "UI/alpha/1080P/summon/item_num_bg.png",
      name = "ImageView_489",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.5, -7)
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
      name = "label_create_btn",
      z = 0,
      parent = "btn_create",
      text = T("\229\136\155\229\187\186\229\133\172\228\188\154"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_apply_3",
      z = 0,
      parent = "btn_apply_3",
      text = T("\231\148\179\232\175\183\229\138\160\229\133\165"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.5, h = 11},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "recruitImg",
      res = "UI/alpha/1080P/guild/guild_enlist/icon_enlistservice_off.png",
      name = "recruitImg_off",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(8.75, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_shield",
      res = "UI/alpha/1080P/toparena/toparena_team_invisible.png",
      name = "ImageView_487",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 26.25)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.crusadeMainScene = {
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
      name = "dragContainer",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 984.5, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dragContainer",
      res = "UI/alpha/1080P/crusade/cursade_bg1.jpg",
      name = "bg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1023.5, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dragContainer",
      res = "UI/alpha/1080P/crusade/cursade_bg2.jpg",
      name = "bg2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1480.5, 270)
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
    base = {name = "layer_ui", z = 0},
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
      fix_wh = {w = 471, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dragContainer",
      res = "UI/alpha/1080P/crusade/cursade_bg3.jpg",
      name = "bg3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(2226, 270)
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
      parent = "dragContainer",
      name = "layer_battle",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 25.5)
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
      position = ccp(200.5, 510.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(900, 75)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_btn",
      z = 0,
      parent = "layer_ui",
      res = "UI/alpha/1080P/crusade/bg_mainpage_btn.png",
      capInsets = CCRectMake(25, 0, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 160.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level1_selected.png",
      name = "battle1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(130.5, 342)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(130, 50),
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
      normal = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(10, 10, 0.5, 0.5),
      name = "btn_shop",
      z = 0,
      parent = "bg_btn",
      text = "",
      press = "UI/alpha/1080P/common/button_com_big.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 132},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level2.png",
      name = "battle2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(196, 163)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(130, 50),
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
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      capInsets = CCRectMake(10, 10, 0.5, 10),
      name = "btn_replay",
      z = 0,
      parent = "bg_btn",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(227, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 132},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level3.png",
      name = "battle3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(389.5, 242)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_hot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 109)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 137.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level4.png",
      name = "battle4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(589.5, 389)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(130, 50)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_restart",
      z = 1,
      parent = "bg_btn",
      res = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(10, 10, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(821, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 157, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/crusade/title_crusade.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100.75, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 148.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level5.png",
      name = "battle5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(659, 170)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(130, 50)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_restart_none",
      z = 0,
      parent = "bg_btn",
      res = "UI/alpha/1080P/common/button_grey.png",
      capInsets = CCRectMake(10, 10, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(821, 37.5)
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
      name = "label_shop",
      z = 0,
      parent = "btn_shop",
      text = T("\229\149\134 \229\186\151"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop",
      res = "UI/alpha/1080P/icon/money_crusadepoint_new.png",
      name = "icon_crusadepoint",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 160.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level6.png",
      name = "battle6",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(958.5, 240)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(130, 50)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_rush",
      z = 0,
      parent = "bg_btn",
      res = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(10, 10, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(227, 37.5)
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
      parent = "bg_title",
      name = "layer_buff",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-84.75, -486.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 120},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level7.png",
      name = "battle7",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1221, 156.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 251.5, h = 73},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn",
      res = "UI/alpha/1080P/crusade/bg_weekly.png",
      name = "bg_weekly_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(626, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_replay",
      z = 0,
      parent = "btn_replay",
      text = T("\229\189\149 \229\131\143"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_replay",
      res = "UI/alpha/1080P/crusade/btn_replay.png",
      name = "icon_replay",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 160.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level8.png",
      name = "battle8",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1149.5, 333.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(130, 50)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_rush_none",
      z = 0,
      parent = "bg_btn",
      res = "UI/alpha/1080P/common/button_grey.png",
      capInsets = CCRectMake(10, 10, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(227, 37.5)
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
      position = ccp(200.25, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 116},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level9.png",
      name = "battle9",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1377, 328)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 48, h = 47.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_hot",
      res = "UI/alpha/1080P/crusade/icon_hot.png",
      name = "icon_hot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 40)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.5, h = 8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_hot",
      res = "UI/alpha/1080P/dreamland/dream3_img.png",
      name = "ImageView_9475",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 160.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level10.png",
      name = "battle10",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1507.5, 184.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 126},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level11.png",
      name = "battle11",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1650.5, 356.5)
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
      name = "label_restart",
      z = 0,
      parent = "btn_restart",
      text = T("\233\135\141\230\150\176\229\188\128\229\167\139"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 136},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level12.png",
      name = "battle12",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1748.5, 166)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 120},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level13.png",
      name = "battle13",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1921.5, 272.5)
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
      name = "label_restart",
      z = 0,
      parent = "btn_restart_none",
      text = T("\233\135\141\230\150\176\229\188\128\229\167\139"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 136},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level14.png",
      name = "battle14",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(2132, 380.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 164, h = 132},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/level15.png",
      name = "battle15",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(2100.5, 195.5)
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
      name = "label_rush",
      z = 0,
      parent = "btn_rush",
      text = T("\229\133\136\233\129\163\233\152\159"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.5, x = 1.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66.75, h = 63},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_bronze_closed.png",
      name = "box1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136.5, 228)
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
      name = "label_hot",
      z = 0,
      parent = "ImageView_9475",
      text = T("\231\131\173\233\151\168"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.75, 11.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66.75000534, h = 63.00000504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_bronze_closed.png",
      name = "box2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379, 143)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.4, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_buff",
      res = "UI/alpha/1080P/common/milestone_loot_raise.png",
      name = "buff1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(352.5, 503.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63, h = 62.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_weekly_reward",
      res = "UI/alpha/1080P/common/frame/fragment_frame_purple.png",
      name = "weekly_reward_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(214.75, 36.5)
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
      name = "weekly_progress",
      z = 1,
      parent = "bg_weekly_reward",
      text = T("/99\229\144\142\232\142\183\229\190\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(106.75, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5000054, h = 63.00000504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_silver_closed.png",
      name = "box3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(375, 386.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.4, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_buff",
      res = "UI/alpha/1080P/common/crusade_buff_energe.png",
      name = "buff2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(390, 503.5)
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
      name = "Label_8599",
      z = 0,
      parent = "bg_weekly_reward",
      text = T("\229\145\168\229\165\150\229\138\177"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.75, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(141, 244, 118),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "cur_progress",
      z = 1,
      parent = "bg_weekly_reward",
      text = T("\233\128\154\229\133\17969"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(106.75, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66.75000534, h = 63.00000504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_bronze_closed.png",
      name = "box4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(612, 274)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.4, h = 32.4},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_buff",
      res = "UI/alpha/1080P/common/crusade_buff_double.png",
      name = "buff3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(427.5, 504)
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
      name = "label_rush_none",
      z = 0,
      parent = "btn_rush_none",
      text = T("\229\133\136\233\129\163\233\152\159"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66.75000534, h = 63.00000504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_bronze_closed.png",
      name = "box5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(798, 216.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.4, h = 33},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_buff",
      res = "UI/alpha/1080P/common/crusade_buff_energe.png",
      name = "buff4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(465, 504)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5000054, h = 63.00000504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_silver_closed.png",
      name = "box6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1056.5, 146)
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
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66.75000534, h = 63.00000504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_bronze_closed.png",
      name = "box7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1176.5, 229)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66.75000534, h = 63.00000504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_bronze_closed.png",
      name = "box8",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1231.5, 377)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5000054, h = 63.00000504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_silver_closed.png",
      name = "box9",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1362, 217.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66.75000534, h = 63.00000504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_bronze_closed.png",
      name = "box10",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1577, 246.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66.75000534, h = 63.00000504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_bronze_closed.png",
      name = "box11",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1764.5, 294.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5000054, h = 63.00000504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_silver_closed.png",
      name = "box12",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1888.5, 160)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66.75000534, h = 63.00000504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_bronze_closed.png",
      name = "box13",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1937, 382.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66.75000534, h = 63.00000504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_bronze_closed.png",
      name = "box14",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(2153, 287)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5000054, h = 63.00000504},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/crusade_box_gold_closed.png",
      name = "box15",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(2244, 178.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40, h = 39.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_battle",
      res = "UI/alpha/1080P/crusade/arrow.png",
      name = "currentStageHint",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(157, 442)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(180, 105)
    },
    t = "Scale9Sprite",
    base = {
      name = "rewardInfo",
      z = 10,
      parent = "layer_battle",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(10, 10, 19, 201.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.6, h = 33.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "rewardInfo",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "moneyIcon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 75)
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
      name = "money",
      z = 0,
      parent = "rewardInfo",
      text = "x188888",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114, 71)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 45},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "rewardInfo",
      res = "UI/alpha/1080P/common/frame/fragment_frame_orange.png",
      name = "heroStone",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, -11.5)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "stoneNum",
      z = 0,
      parent = "rewardInfo",
      text = "x1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(163, -12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.7, h = 38.7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "rewardInfo",
      res = "UI/alpha/1080P/common/handbook_icon_lock.png",
      name = "randomReward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 32)
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
      name = "randomText",
      z = 0,
      parent = "rewardInfo",
      text = T("\231\165\158\231\167\152\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.5, 33)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "stoneText",
      z = 0,
      parent = "rewardInfo",
      text = T("\233\128\154\229\133\179\229\143\175\232\142\183\229\190\151:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108, -12.5)
    }
  }
}

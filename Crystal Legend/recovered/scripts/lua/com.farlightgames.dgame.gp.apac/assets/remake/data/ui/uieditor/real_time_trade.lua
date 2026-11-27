ed.uieditor = ed.uieditor or {}
ed.uieditor.real_time_trade = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(536.72, 340.63)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15.63, 15.63, 15.63, 15.63),
      res = "UI/alpha/1080P/common/main_vit_tips.png",
      name = "img_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(404.69, 239.06)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(248.44, 113.28)
    },
    t = "Scale9Sprite",
    base = {
      name = "trade_content_1",
      z = 0,
      parent = "img_bg",
      res = "UI/alpha/1080P/common/tip_detail_bg.png",
      capInsets = CCRectMake(39.06, 15.63, 23.44, 15.63)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134.77, 203.91)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(93.75, 46.88),
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/HVGA/stageselect_difficulty_button_normal.png",
      capInsets = CCRectMake(15.63, 15.63, 15.63, 15.63),
      name = "trade_btn",
      z = 0,
      parent = "img_bg",
      text = "",
      press = "UI/alpha/HVGA/stageselect_difficulty_button_normal_pressed.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(181.64, 36.72)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(248.44, 113.28)
    },
    t = "Scale9Sprite",
    base = {
      name = "trade_content_2",
      z = 0,
      parent = "img_bg",
      res = "UI/alpha/1080P/common/tip_detail_bg.png",
      capInsets = CCRectMake(39.06, 15.63, 23.44, 15.63)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(401.17, 204.69)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(328.91, 26.56)
    },
    t = "Scale9Sprite",
    base = {
      name = "player2_name",
      z = 0,
      parent = "img_bg",
      res = "UI/alpha/HVGA/recharge_list_title_bg.png",
      capInsets = CCRectMake(78.13, 13.28, 0.78, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(542.58, 300)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(328.91, 26.56)
    },
    t = "Scale9Sprite",
    base = {
      name = "player1_name",
      z = 0,
      parent = "img_bg",
      res = "UI/alpha/HVGA/recharge_list_title_bg.png",
      capInsets = CCRectMake(78.13, 13.28, 0.78, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(276.17, 297.66)
    }
  },
  {
    config = {
      rotation = 90,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(311.72, 2.34)
    },
    t = "Scale9Sprite",
    base = {
      name = "splite",
      z = 0,
      parent = "img_bg",
      res = "UI/alpha/HVGA/herodetail_delimiter.png",
      capInsets = CCRectMake(173.44, 1.56, 57.03, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(266.02, 174.22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_trade",
      z = 0,
      parent = "trade_btn",
      text = T("\228\186\164\230\152\147"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.88, 25)
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
      name = "lab_player2_name",
      z = 0,
      parent = "player2_name",
      text = T("\231\142\169\229\174\1822\229\144\141\229\173\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.58, 13.28)
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
      name = "lab_player1_name",
      z = 0,
      parent = "player1_name",
      text = T("\231\142\169\229\174\1821\229\144\141\229\173\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(12.89, 14.06)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(43.75, 34.38)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_player1_level",
      z = 0,
      parent = "img_bg",
      res = "UI/alpha/HVGA/main_head_bg_gold.png",
      capInsets = CCRectMake(15.63, 0, 15.63, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.17, 298.44)
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
      name = "lab_player1_level",
      z = 4,
      parent = "img_bg",
      text = "100",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.17, 298.44)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(44.53, 34.38)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_player2_level",
      z = 0,
      parent = "img_bg",
      res = "UI/alpha/HVGA/main_head_bg_gold.png",
      capInsets = CCRectMake(15.63, 0.78, 15.63, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(368.36, 300)
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
      name = "lab_player2_level",
      z = 3,
      parent = "img_bg",
      text = "100",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(368.36, 300)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(133.59, 42.97)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_payment_1",
      z = 0,
      parent = "img_bg",
      res = "UI/alpha/1080P/common/tip_detail_bg.png",
      capInsets = CCRectMake(39.06, 15.63, 23.44, 15.63)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(169.92, 117.97)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(168.75, 42.97)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_payment_2",
      z = 0,
      parent = "img_bg",
      res = "UI/alpha/1080P/common/tip_detail_bg.png",
      capInsets = CCRectMake(39.06, 15.63, 23.44, 15.63)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(406.64, 118.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(238, 88, 8),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_player2_state",
      z = 0,
      parent = "img_bg",
      text = T("\229\175\185\230\150\185\230\173\163\229\156\168\233\128\137\230\139\169\228\186\164\230\152\147\231\137\169\229\147\129"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(398.83, 39.84)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.125, h = 28.125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg",
      res = "UI/alpha/HVGA/chef/chef_trade_confirm_light.png",
      name = "btn_lock",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.77, 38.28)
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
      name = "lab_confirm",
      z = 0,
      parent = "img_bg",
      text = T("\233\148\129\229\174\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.92, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(93.75, 46.88)
    },
    t = "Scale9Sprite",
    base = {
      name = "disabled_trade_btn",
      z = 0,
      parent = "img_bg",
      res = "installer/herodetail-upgrade-disabled.png",
      capInsets = CCRectMake(15.63, 15.63, 15.63, 15.63)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183.2, 36.72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 49.21875, h = 52.34375},
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
      normal = "UI/alpha/1080P/common/common_tips_button_close_1.png",
      name = "close_btn",
      z = 7,
      parent = "img_bg",
      text = "",
      press = "UI/alpha/1080P/common/common_tips_button_close_2.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(533.98, 323.44)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(78.13, 78.13)
    },
    t = "Scale9Sprite",
    base = {
      name = "hero_icon_1",
      z = 2,
      parent = "img_bg",
      res = "UI/alpha/HVGA/bgmask.png",
      capInsets = CCRectMake(7.81, 7.81, 7.81, 7.81)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.67, 296.09)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(78.13, 78.13)
    },
    t = "Scale9Sprite",
    base = {
      name = "hero_icon_2",
      z = 2,
      parent = "img_bg",
      res = "UI/alpha/HVGA/bgmask.png",
      capInsets = CCRectMake(7.81, 7.81, 7.81, 7.81)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(304.3, 296.09)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(232.03, 0.78)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_splite_Copy0",
      z = 0,
      parent = "img_bg",
      res = "UI/alpha/HVGA/herodetail_delimiter.png",
      capInsets = CCRectMake(50.78, 0.78, 142.97, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.89, 60.16)
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
      name = "lab_value",
      z = 0,
      parent = "img_bg",
      text = "x5",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180.08, 78.13)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.703125, h = 24.609375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg",
      res = "UI/alpha/1080P/common/rmbicon.png",
      name = "ImageView_5851",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(152.73, 77.34)
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
      name = "Label_5850_Copy0",
      z = 0,
      parent = "img_bg",
      text = T("\230\137\139\231\187\173\232\180\185:"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(112.11, 78.91)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(239.84, 100)
    },
    t = "Layer",
    base = {
      parent = "trade_content_1",
      name = "trade_content_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(2.34, 6.64)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(261.72, 247.66)
    },
    t = "Scale9Sprite",
    base = {
      name = "lock_bg_1",
      z = 7,
      parent = "img_bg",
      res = "UI/alpha/HVGA/cdmask.png",
      capInsets = CCRectMake(15.63, 15.63, 15.63, 15.63)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133.98, 212.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(264.84, 254.69)
    },
    t = "Scale9Sprite",
    base = {
      name = "lock_bg_2",
      z = 6,
      parent = "img_bg",
      res = "UI/alpha/HVGA/cdmask.png",
      capInsets = CCRectMake(15.63, 15.63, 15.63, 15.63)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(399.61, 209.38)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(238.28, 100.78)
    },
    t = "Layer",
    base = {
      parent = "trade_content_2",
      name = "trade_content_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7.03, 6.64)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(49.22, 52.34),
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
      capInsets = CCRectMake(24.22, 25.78, 12.5, 21.09),
      name = "btn_del",
      z = 0,
      parent = "img_payment_1",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.67, 21.48)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(49.22, 52.34),
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
      capInsets = CCRectMake(24.22, 25.78, 12.5, 21.09),
      name = "btn_add",
      z = 0,
      parent = "img_payment_1",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120.7, 20.7)
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
      name = "lab_num_1",
      z = 0,
      parent = "img_payment_1",
      text = "0",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.45, 21.48)
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
      name = "lab_num_2",
      z = 0,
      parent = "img_payment_2",
      text = "0",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(125.78, 19.92)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.046875, h = 41.484375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_payment_1",
      res = "UI/alpha/HVGA/phil_stone_elite_icon.png",
      name = "img_phil_stone",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-44.14, 23.05)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.046875, h = 41.484375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_payment_2",
      res = "UI/alpha/HVGA/phil_stone_elite_icon.png",
      name = "img_phil_stone_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-1.56, 22.27)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.609375, h = 23.828125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_lock",
      res = "UI/alpha/HVGA/playerinfo_res_select.png",
      name = "img_confirm_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.63, 14.84)
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
      name = "Label_6165",
      z = 0,
      parent = "img_payment_2",
      text = T("\232\180\164\232\128\133\228\185\139\231\159\179\231\178\190\229\141\142x"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71.88, 19.92)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_trade_2",
      z = 0,
      parent = "disabled_trade_btn",
      text = T("\228\186\164\230\152\147"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.88, 26.56)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(54.69, 54.69)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_add_content_bg",
      z = 0,
      parent = "trade_content_1",
      res = "UI/alpha/HVGA/gocha.png",
      capInsets = CCRectMake(19.53, 24.22, 30.47, 25.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.69, 70.31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 2, x = 2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.8125, h = 68.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "lock_bg_1",
      res = "UI/alpha/1080P/common/pvp_battle_lock.png",
      name = "locak_icon_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.42, 112.89)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 2, x = 2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.8125, h = 68.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "lock_bg_2",
      res = "UI/alpha/1080P/common/pvp_battle_lock.png",
      name = "locak_icon_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133.98, 116.41)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 190, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_del",
      z = 0,
      parent = "btn_del",
      text = "-",
      size = 36
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.39, 27.73)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 190, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "lab_add",
      z = 0,
      parent = "btn_add",
      text = "+",
      size = 28
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.61, 27.73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 31.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_add_content_bg",
      res = "UI/alpha/1080P/common/purchasebtn.png",
      name = "img_add_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.34, 28.13)
    }
  }
}

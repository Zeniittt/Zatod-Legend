ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaBattlePrepareScene = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(667, 540)
    },
    t = "Layer",
    base = {name = "panel_left", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(600, 536)
    },
    t = "Scale9Sprite",
    base = {
      name = "lay9BJ",
      z = 2,
      parent = "panel_left",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_big.png",
      capInsets = CCRectMake(245, 265, 1, 2.5)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(65, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(587.5, 70)
    },
    t = "Scale9Sprite",
    base = {
      name = "layEmeHeros",
      z = 1,
      parent = "panel_left",
      res = "UI/alpha/1080P/toparena/toparena_prepare_bg.png",
      capInsets = CCRectMake(150, 0.5, 17.5, 0.5)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(71, 459.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(207.5, 540)
    },
    t = "Layer",
    base = {
      name = "panel_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(731, -1.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(590, 100)
    },
    t = "Layer",
    base = {
      parent = "panel_left",
      name = "layUp_ButOrBg",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(70, 100.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 60)
    },
    t = "Layer",
    base = {
      parent = "layEmeHeros",
      name = "panel_enemy",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(124, 5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(160, 70)
    },
    t = "Layer",
    base = {
      parent = "layEmeHeros",
      name = "enemyFitLay",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(590, 140)
    },
    t = "Layer",
    base = {
      parent = "panel_left",
      name = "layMyTeams",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(70, 3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_enemy",
      res = "UI/alpha/1080P/battle/battle_prepare_fx_2.png",
      name = "battlePrepare_fx_L",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-23.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 25, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_enemy",
      res = "UI/alpha/1080P/battle/battle_prepare_fx_2.png",
      name = "battlePrepare_fx_R",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(370, 30)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(597.5, 535)
    },
    t = "Scale9Sprite",
    base = {
      name = "layBgs",
      z = 0,
      parent = "panel_left",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_1.png",
      capInsets = CCRectMake(17, 17, 11, 11)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(66, -2.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(206, 532.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_rig",
      z = 0,
      parent = "panel_right",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_2.png",
      capInsets = CCRectMake(10, 10, 3.5, 3.5)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 2.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(590, 59)
    },
    t = "Scale9Sprite",
    base = {
      name = "isbg",
      z = 0,
      parent = "layUp_ButOrBg",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan.png",
      capInsets = CCRectMake(19.5, 12, 11, 12)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-0.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 123.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "enemyFitLay",
      res = "UI/alpha/1080P/battle/battle_prepare_enemy_f_2.png",
      name = "enemy_layFitNum",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.5, h = 59.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "battlePrepare_fx_L",
      res = "UI/alpha/1080P/battle/battle_prepare_fx_1.png",
      name = "btn_enemy_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 127.5, h = 38},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "enemyFitLay",
      res = "UI/alpha/1080P/toparena/toparena_prepare_teamname.png",
      name = "bg_enemy_team",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.5, 48)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layUp_ButOrBg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "lin_L",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.5, 48)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 37.5, h = 59.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "battlePrepare_fx_R",
      res = "UI/alpha/1080P/battle/battle_prepare_fx_1.png",
      name = "btn_enemy_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(575, 277)
    },
    t = "Layer",
    base = {
      parent = "panel_left",
      name = "panel_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(78, 181.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204, h = 156},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_right",
      res = "UI/alpha/1080P/battle/battle_prepare_fa_3.png",
      name = "bg_rig2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103.5, 458)
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
      parent = "layUp_ButOrBg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "lin_R",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(491, 48)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(310, 55)
    },
    t = "Layer",
    base = {
      parent = "layUp_ButOrBg",
      name = "panel_classify",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(139.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "enemy_layFitNum",
      res = "UI/alpha/1080P/battle/battle_prepare_fit_img.png",
      name = "img_enemy_gs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_3.png",
      name = "btn_preset_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(629, 147.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(207.5, 540)
    },
    t = "Layer",
    base = {
      parent = "panel_right",
      name = "panel_pages",
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
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layUp_ButOrBg",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_3.png",
      name = "btn_preset",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(558.5, 47)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(293.5, 40)
    },
    t = "Scale9Sprite",
    base = {
      name = "myTeam9Img_3",
      z = 1,
      parent = "layMyTeams",
      res = "UI/alpha/1080P/battle/battle_prepare_my_team_r_bg.png",
      capInsets = CCRectMake(10, 10, 100, 10)
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(589, 112)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 195, 40),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_enemy_team",
      z = 0,
      parent = "bg_enemy_team",
      text = T("\229\175\185\230\150\1851\233\152\159"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.75, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(587.5, 61.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "myTeam9Img_4",
      z = 0,
      parent = "layMyTeams",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_3.png",
      capInsets = CCRectMake(15, 0, 150, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(294.5, 84.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 8.5, h = 8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/battle/battle_prepare_fa_1.png",
      name = "starImg_1",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(365, 532)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(188.5, 15.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "myTeam9Img_2",
      z = 0,
      parent = "layMyTeams",
      res = "UI/alpha/1080P/battle/battle_prepare_my_team_l_bg.png",
      capInsets = CCRectMake(15, 0, 150, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(106.5, 121.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.5, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layMyTeams",
      res = "UI/alpha/1080P/battle/battle_prepare_my_team_l_img.png",
      name = "myTeam9Img_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(6.5, 116.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 4, h = 4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/battle/battle_prepare_fa_2.png",
      name = "starImg_3",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, 267.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(108, 23)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_my_gs",
      z = 2,
      parent = "layMyTeams",
      res = "UI/alpha/1080P/battle/battle_prepare_my_fitbg.png",
      capInsets = CCRectMake(13.5, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.5, 119)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(502.5, 96.5)
    },
    t = "Layer",
    base = {
      parent = "layMyTeams",
      name = "panel_my_team",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(44, 9)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 4, h = 4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/battle/battle_prepare_fa_2.png",
      name = "starImg_4",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(661.5, 267.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 8.5, h = 8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_left",
      res = "UI/alpha/1080P/battle/battle_prepare_fa_1.png",
      name = "starImg_2",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(365, 3.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(180, 49)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_next",
      z = 1,
      parent = "panel_pages",
      res = "UI/alpha/1080P/common/buttion_big.png",
      capInsets = CCRectMake(15, 15, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103.5, 42.5)
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
      name = "label_preset",
      z = 0,
      parent = "btn_preset",
      text = T("\233\162\132\232\174\190"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "panel_pages",
      name = "panel_attack",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 61)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(130, 375)
    },
    t = "Layer",
    base = {
      parent = "panel_left",
      name = "panel_team",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-48, 66)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(180, 49)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_delete",
      z = 1,
      parent = "panel_pages",
      res = "UI/alpha/1080P/common/buttion_big.png",
      capInsets = CCRectMake(15, 15, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103, 102)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "panel_pages",
      name = "panel_defend",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 61)
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
      name = "yshe",
      z = 0,
      parent = "btn_preset_back",
      text = T("\232\191\148\229\155\158"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(180, 49)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_go",
      z = 1,
      parent = "panel_pages",
      res = "UI/alpha/1080P/common/buttion_big.png",
      capInsets = CCRectMake(15, 15, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_gs",
      res = "UI/alpha/1080P/battle/battle_prepare_fit_img.png",
      name = "mayFitImg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 11.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 207, 81),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_my_gs",
      z = 0,
      parent = "bg_my_gs",
      text = "111",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(40, 11.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 503, h = 99.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_my_team",
      res = "UI/alpha/1080P/battle/battle_prepare_my_team_head.png",
      name = "teamItemBg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(251, 48)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 228, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_next",
      z = 0,
      parent = "btn_next",
      text = T("\228\184\139\228\184\128\233\152\159"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.5, x = 1.5},
      flip = "",
      opacity = 0,
      fix_wh = {w = 129, h = 132},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_my_team",
      res = "UI/alpha/1080P/battle/herobucket-halo.png",
      name = "img_my_team_light_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.5, x = 1.5},
      flip = "",
      opacity = 0,
      fix_wh = {w = 129, h = 132},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_my_team",
      res = "UI/alpha/1080P/battle/herobucket-halo.png",
      name = "img_my_team_light_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148.5, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.5, x = 1.5},
      flip = "",
      opacity = 0,
      fix_wh = {w = 129, h = 132},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_my_team",
      res = "UI/alpha/1080P/battle/herobucket-halo.png",
      name = "img_my_team_light_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250.5, 47)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.5, x = 1.5},
      flip = "",
      opacity = 0,
      fix_wh = {w = 129, h = 132},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_my_team",
      res = "UI/alpha/1080P/battle/herobucket-halo.png",
      name = "img_my_team_light_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(352.5, 47)
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
      name = "label_title",
      z = 0,
      parent = "panel_attack",
      text = T("\230\181\183\233\128\137\232\181\155\229\175\185\230\137\139"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104, 452.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.5, x = 1.5},
      flip = "",
      opacity = 0,
      fix_wh = {w = 129, h = 132},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_my_team",
      res = "UI/alpha/1080P/battle/herobucket-halo.png",
      name = "img_my_team_light_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(454.5, 47)
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
      name = "label_grade_des",
      z = 0,
      parent = "panel_attack",
      text = T("\230\174\181       \228\189\141:"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 254)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 147.99999112, h = 22.399998656},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_attack",
      res = "UI/alpha/1080P/battle/battle_prepare_name_bg.png",
      name = "bg_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 287)
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
      name = "label_server_des",
      z = 0,
      parent = "panel_attack",
      text = T("\229\140\186       \230\156\141:"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 229.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 228, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_delete",
      z = 0,
      parent = "btn_delete",
      text = T("\230\184\133\231\169\186"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91, 24.5)
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
      name = "label_server_name",
      z = 0,
      parent = "panel_attack",
      text = T("\229\183\168\233\190\153\229\174\136\230\138\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(116, 229.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "panel_attack",
      name = "panel_head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(103, 343.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 185, h = 69.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_attack",
      res = "UI/alpha/1080P/toparena/toparena_team_score.png",
      name = "ImageView_497",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(99.5, 147.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 25)
    },
    t = "Layer",
    base = {
      parent = "panel_attack",
      name = "panel_grade",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(115, 241.5)
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
      name = "label_gs_des",
      z = 0,
      parent = "panel_attack",
      text = T("\230\136\152       \229\138\155:"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 205)
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
      name = "label_defend_title",
      z = 0,
      parent = "panel_defend",
      text = T("\232\174\190\231\189\174\233\152\178\229\174\136\233\152\181\229\174\185"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103.5, 451.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(75, 25)
    },
    t = "Layer",
    base = {
      parent = "panel_attack",
      name = "panel_gs",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(115, 192)
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
      name = "label_defend_des",
      z = 0,
      parent = "panel_defend",
      text = T("\232\175\183\232\174\190\231\189\174\230\130\168\231\154\132\229\165\179\231\165\158\228\185\139\230\136\152\233\152\178\229\174\136\233\152\181\229\174\185"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(19.5, 271)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "Label_495_Copy0",
      z = 0,
      parent = "panel_defend",
      text = T("\231\171\158\230\138\128\229\156\186\233\152\178\229\174\136\233\152\181\229\174\185\229\147\166\239\188\129"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(19.5, 253.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_attack",
      res = "UI/alpha/1080P/package/bg_all_select.png",
      name = "bg_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 103)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 228, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_go",
      z = 0,
      parent = "btn_go",
      text = T("\230\136\152\230\150\151"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91, 24.5)
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
      name = "label_select_des",
      z = 0,
      parent = "panel_attack",
      text = T("\232\183\179\232\191\135\230\136\152\230\150\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117, 102.5)
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
      name = "txt_name",
      z = 0,
      parent = "bg_name",
      text = T("\231\148\187\233\163\142\229\144\131\233\135\142\228\186\186"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92.5, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_497",
      res = "UI/alpha/1080P/toparena/toparena_score_icon_tf.png",
      name = "ImageView_3223",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93.5, 53.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 40)
    },
    t = "Layer",
    base = {
      parent = "ImageView_497",
      name = "panel_score",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(44, 2.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32.09999465, h = 28.1999953},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_select",
      res = "UI/alpha/1080P/package/selected.png",
      name = "img_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.5, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 166),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_des",
      z = 0,
      parent = "ImageView_3223",
      text = T("\231\167\175\229\136\134"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 207, 81),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_enemy_gs",
      z = 0,
      parent = "enemy_layFitNum",
      text = "111",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(37.75, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.95, h = 36.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layUp_ButOrBg",
      res = "UI/alpha/1080P/fireforge/others/Switch_off.png",
      name = "switch_equip_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70, 52)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_attack",
      res = "UI/alpha/1080P/cuparena/cuparena_rank_medal_1_name.png",
      name = "img_grade_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149, 254.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 74.5, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_equip_bg",
      res = "UI/alpha/1080P/fireforge/others/Switch_on.png",
      name = "close_equip_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.25, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_equip_bg",
      res = "UI/alpha/1080P/fireforge/others/Switch_circle.png",
      name = "btn_equip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56.75, 18.5)
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
      name = "label_equip",
      z = 0,
      parent = "switch_equip_bg",
      text = T("\229\177\149\231\164\186"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(13.75, 18.5)
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
      name = "label_equip_des",
      z = 0,
      parent = "switch_equip_bg",
      text = T("\228\188\160\229\165\135\232\163\133\229\164\135"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(74.75, 19)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "label_equip_enable",
      z = 0,
      parent = "switch_equip_bg",
      text = T("\228\184\141\230\152\190\231\164\186"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(26.25, 17)
    }
  }
}

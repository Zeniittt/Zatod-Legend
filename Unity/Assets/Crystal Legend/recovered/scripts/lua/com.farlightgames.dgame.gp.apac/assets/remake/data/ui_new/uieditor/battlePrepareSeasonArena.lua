ed.uieditor = ed.uieditor or {}
ed.uieditor.battlePrepareSeasonArena = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(667, 540)
    },
    t = "Layer",
    base = {name = "Panel_left", z = 1},
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
      parent = "Panel_left",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_big.png",
      capInsets = CCRectMake(245, 265, 1, 2.5)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(64.5, 0)
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
      parent = "Panel_left",
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
      name = "Panel_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(709, 0)
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
      parent = "Panel_left",
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
      name = "eneTeamItem",
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
      parent = "Panel_left",
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
      parent = "eneTeamItem",
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
      parent = "eneTeamItem",
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
      parent = "Panel_left",
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
      name = "bgRig",
      z = 0,
      parent = "Panel_right",
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
      name = "battlePrepare_fx_L_1",
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
      name = "enemyTeamBg",
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
      name = "battlePrepare_fx_R_1",
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
      parent = "Panel_left",
      name = "heros_items",
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
      parent = "Panel_right",
      res = "UI/alpha/1080P/battle/battle_prepare_fa_3.png",
      name = "bgRig2",
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
      name = "butts_list",
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
      name = "fitImgs",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15, 15)
    },
    t = "Layer",
    base = {
      parent = "enemy_layFitNum",
      name = "enemy_fit_num",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(36.75, 13.25)
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
      name = "gs_eme",
      z = 0,
      parent = "enemy_layFitNum",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(37.75, 13.75)
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
      parent = "Panel_left",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_3.png",
      name = "preset_back",
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
      parent = "Panel_right",
      name = "Panel_Pages",
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
      name = "preset",
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
      name = "enemyTeamTit",
      z = 0,
      parent = "enemyTeamBg",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "enemyTeamBg",
      res = "UI/alpha/1080P/toparena/toparena_team_enemy1.png",
      name = "enemyimg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.25, 20)
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
      parent = "Panel_left",
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
      parent = "Panel_left",
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
      name = "mayFitBg",
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
      name = "layTeamitems",
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
      parent = "Panel_left",
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
      parent = "Panel_left",
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
      name = "go_next",
      z = 1,
      parent = "Panel_Pages",
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
      name = "yshe",
      z = 0,
      parent = "preset",
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
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
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
      scaleSize = CCSizeMake(100, 600)
    },
    t = "Layer",
    base = {
      parent = "Panel_left",
      name = "layLeftButs",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-35.5, 0)
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
      name = "go_dele",
      z = 1,
      parent = "Panel_Pages",
      res = "UI/alpha/1080P/common/buttion_big.png",
      capInsets = CCRectMake(15, 15, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103.5, 102)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(206, 475)
    },
    t = "Layer",
    base = {
      parent = "Panel_Pages",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(587, 36.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "defendTopImg",
      z = 1,
      parent = "Panel_left",
      res = "UI/alpha/1080P/toparena/toparena_star_prepare_bg.png",
      capInsets = CCRectMake(11, 0, 650, 1)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(364, 510.5)
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
      parent = "preset_back",
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
      name = "go",
      z = 1,
      parent = "Panel_Pages",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "mayFitBg",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(5, 5)
    },
    t = "Layer",
    base = {
      parent = "mayFitBg",
      name = "fitTxtPosMy",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(42.5, 11)
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
      name = "gs",
      z = 0,
      parent = "mayFitBg",
      text = "",
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
      parent = "layTeamitems",
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
      name = "label_go_next",
      z = 0,
      parent = "go_next",
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
      parent = "layTeamitems",
      res = "UI/alpha/1080P/battle/herobucket-halo.png",
      name = "member_light_1",
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
      parent = "layTeamitems",
      res = "UI/alpha/1080P/battle/herobucket-halo.png",
      name = "member_light_2",
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
      parent = "layTeamitems",
      res = "UI/alpha/1080P/battle/herobucket-halo.png",
      name = "member_light_3",
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
      parent = "layTeamitems",
      res = "UI/alpha/1080P/battle/herobucket-halo.png",
      name = "member_light_4",
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
      name = "Label_title",
      z = 0,
      parent = "panel_attack",
      text = T("\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\229\175\185\230\137\139"),
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
      parent = "layTeamitems",
      res = "UI/alpha/1080P/battle/herobucket-halo.png",
      name = "member_light_5",
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
      name = "duanwei_txt",
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
      name = "name_bg",
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
      name = "qufu_txt",
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
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "qufu",
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
      name = "label_go_dele",
      z = 0,
      parent = "go_dele",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "panel_attack",
      name = "Panel_headPos",
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
      name = "panel_duanwei",
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
      name = "label_gs",
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
      name = "Label_title_Copy0",
      z = 0,
      parent = "panel_defend",
      text = T("\229\183\133\229\179\176\231\171\158\230\138\128\229\156\186\233\152\178\229\174\136"),
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
      name = "Label_495",
      z = 0,
      parent = "panel_defend",
      text = T("\228\188\160\229\165\135\230\174\181\228\189\141\229\143\138\228\187\165\228\184\138\232\162\171\230\140\145\230\136\152\230\151\182\239\188\140\229\176\134\229\144\175\231\148\168\233\162\132\229\164\135\233\152\159\228\188\141"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(19.5, 271)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 185.2, h = 64.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_attack",
      res = "UI/alpha/1080P/toparena/toparena_rank_bg.png",
      name = "image_rank_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103, 415.5)
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
      name = "Image_select_bg",
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
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_select_str",
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
      color = ccc3(247, 228, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_go",
      z = 0,
      parent = "go",
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
      name = "txt_name",
      z = 0,
      parent = "name_bg",
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
      fix_wh = {w = 125.5, h = 87},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layLeftButs",
      res = "UI/alpha/1080P/toparena/toparena_team_battle4.png",
      name = "teamBtn_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 420)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125.5, h = 87},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layLeftButs",
      res = "UI/alpha/1080P/toparena/toparena_team_battle4.png",
      name = "teamBtn_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 333)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125.5, h = 87},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layLeftButs",
      res = "UI/alpha/1080P/toparena/toparena_team_battle4.png",
      name = "teamBtn_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 246)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125.5, h = 87},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layLeftButs",
      res = "UI/alpha/1080P/toparena/toparena_team_battle4.png",
      name = "teamBtn_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 159)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125.5, h = 87},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layLeftButs",
      res = "UI/alpha/1080P/toparena/toparena_team_battle4.png",
      name = "teamBtn_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "defendTopImg",
      res = "UI/alpha/1080P/toparena/toparena_star_icon_2.png",
      name = "toparena_star_icon_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(221.5, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(236, 220, 191),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "defendTopStr",
      z = 0,
      parent = "defendTopImg",
      text = T("\230\156\172\229\145\168\230\149\136\230\158\156\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(243.5, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 13.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_rank_bg",
      res = "UI/alpha/1080P/toparena/text_no.png",
      name = "image_rank_no",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75.25, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 151),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank_des",
      z = 0,
      parent = "image_rank_bg",
      text = T("\229\133\168\230\156\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.75, 53)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 208, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "defendTopName",
      z = 0,
      parent = "defendTopImg",
      text = T("\229\138\155\229\164\167\231\160\150\233\163\158"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(323.5, 18.25)
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
      parent = "Image_select_bg",
      res = "UI/alpha/1080P/package/selected.png",
      name = "Image_select",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "defendTopImg",
      res = "UI/alpha/1080P/guild/seach_1.png",
      name = "search",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(405.5, 18.25)
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
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "teamBtnStr_1",
      z = 1,
      parent = "teamBtn_1",
      text = T("1\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.75, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125.5, h = 87},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "teamBtn_1",
      res = "UI/alpha/1080P/toparena/toparena_team_battle1_tf.png",
      name = "teamBtnPass_1",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.75, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 243, 226),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "teamBtnStr_2",
      z = 1,
      parent = "teamBtn_2",
      text = T("2\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.75, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125.5, h = 87},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "teamBtn_2",
      res = "UI/alpha/1080P/toparena/toparena_team_battle2_tf.png",
      name = "teamBtnPass_2",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.75, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 243, 226),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "teamBtnStr_3",
      z = 1,
      parent = "teamBtn_3",
      text = T("3\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.75, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125.5, h = 87},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "teamBtn_3",
      res = "UI/alpha/1080P/toparena/toparena_team_battle3_tf.png",
      name = "teamBtnPass_3",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.75, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 243, 226),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "teamBtnStr_4",
      z = 1,
      parent = "teamBtn_4",
      text = T("4\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.75, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.14, x = 1.07},
      flip = "",
      opacity = 255,
      fix_wh = {w = 123.05, h = 92.34},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "teamBtn_4",
      res = "UI/alpha/1080P/toparena/toparena_team_battle4_tf.png",
      name = "teamBtnPass_4",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.75, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "teamBtn_4",
      res = "UI/alpha/1080P/toparena/toparena_team_defense_bench4.png",
      name = "defense_bench_4",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.75, 74)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 243, 226),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "teamBtnStr_5",
      z = 1,
      parent = "teamBtn_5",
      text = T("5\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.75, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.14, x = 1.07},
      flip = "",
      opacity = 255,
      fix_wh = {w = 123.05, h = 92.34},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "teamBtn_5",
      res = "UI/alpha/1080P/toparena/toparena_team_battle5_tf.png",
      name = "teamBtnPass_5",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.75, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "teamBtn_5",
      res = "UI/alpha/1080P/toparena/toparena_team_defense_bench5.png",
      name = "defense_bench_5",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.75, 74)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 249, 161),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "teamBtnPassStr_1",
      z = 0,
      parent = "teamBtnPass_1",
      text = T("1\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.75, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(171, 247, 246),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "teamBtnPassStr_2",
      z = 0,
      parent = "teamBtnPass_2",
      text = T("2\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.75, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 214, 186),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "teamBtnPassStr_3",
      z = 0,
      parent = "teamBtnPass_3",
      text = T("3\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.75, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(239, 195, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "teamBtnPassStr_4",
      z = 0,
      parent = "teamBtnPass_4",
      text = T("4\233\152\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 243, 226),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "defense_bench_str_4",
      z = 1,
      parent = "defense_bench_4",
      text = T("\233\162\132\229\164\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(150, 234, 217),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "teamBtnPassStr_5",
      z = 0,
      parent = "teamBtnPass_5",
      text = T("5\233\152\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 243, 226),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "defense_bench_str_5",
      z = 1,
      parent = "defense_bench_5",
      text = T("\233\162\132\229\164\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.95, h = 36.3},
      visible = false
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
      position = ccp(50.5, 51.5)
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
      position = ccp(27.25, 17.5)
    }
  }
}

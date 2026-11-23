ed.uieditor = ed.uieditor or {}
ed.uieditor.battlePrepareLong = {
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
      z = 20,
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
      res = "UI/alpha/1080P/battle/battle_prepare_enemy_bg.png",
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
      scaleSize = CCSizeMake(75, 275)
    },
    t = "Layer",
    base = {
      parent = "Panel_left",
      name = "layLeftButs",
      z = 23
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 200)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 60)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55.5, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "eneTeamItem",
      res = "UI/alpha/1080P/battle/battle_prepare_enemy_head.png",
      name = "oppo_member_bg_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55.5, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "eneTeamItem",
      res = "UI/alpha/1080P/battle/battle_prepare_enemy_head.png",
      name = "oppo_member_bg_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55.5, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "eneTeamItem",
      res = "UI/alpha/1080P/battle/battle_prepare_enemy_head.png",
      name = "oppo_member_bg_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(170, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55.5, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "eneTeamItem",
      res = "UI/alpha/1080P/battle/battle_prepare_enemy_head.png",
      name = "oppo_member_bg_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(238.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 54, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "butt_off",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72, 501)
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
      z = 15
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(70, 3)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layLeftButs",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "but1_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 217)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55.5, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "eneTeamItem",
      res = "UI/alpha/1080P/battle/battle_prepare_enemy_head.png",
      name = "oppo_member_bg_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(307, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 123.5, h = 26.5},
      visible = false
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
      position = ccp(62, 283.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55.5, h = 55},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "eneTeamItem",
      res = "UI/alpha/1080P/battle/battle_prepare_enemy_head.png",
      name = "oppo_member_bg_6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(376, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(248, 82, 60),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "enemyTeamTit",
      z = 0,
      parent = "enemyFitLay",
      text = T("\233\152\181\229\174\1851/1"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(42.5, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 77},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layLeftButs",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
      name = "but1_2",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.5, 217)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 45},
      visible = false
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(238, 87, 57),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "enemyLabel",
      z = 0,
      parent = "enemyFitLay",
      text = T("\230\149\140"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 25, h = 45},
      visible = false
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
      fix_wh = {w = 64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layLeftButs",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "but2_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 133)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 77},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layLeftButs",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
      name = "but2_2",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.5, 133)
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
      fix_wh = {w = 197.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/common/battle_prepare_lins_2.png",
      name = "lin",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103, 486)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layLeftButs",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "but3_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 49.5)
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
      name = "label1_1",
      z = 0,
      parent = "but1_1",
      text = T("\230\136\152\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "but1_1",
      res = "UI/alpha/1080P/battle/battle_prepare_team_2.png",
      name = "ImageView_6234_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 45.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 77},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layLeftButs",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
      name = "but3_2",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.5, 49.5)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 192, h = 56.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "go",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104, 43)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 77},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layLeftButs",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
      name = "but4_2",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.5, 133)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "but1_2",
      res = "UI/alpha/1080P/battle/battle_prepare_team_1.png",
      name = "ImageView_6234",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 47.5)
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label1_2",
      z = 0,
      parent = "but1_2",
      text = T("\230\136\152\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layLeftButs",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "but4_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 133)
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
      z = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(365, 532)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 192, h = 56.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "go_disable",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "butt_off",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "Imageoff",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.5, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "but2_1",
      res = "UI/alpha/1080P/battle/battle_prepare_friend_2.png",
      name = "ImageView_6234_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 45.75)
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
      name = "label2_1",
      z = 0,
      parent = "but2_1",
      text = T("\228\189\163\229\133\181"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 21.75)
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
      position = ccp(293.5, -13.5)
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
      z = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, 267.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 192, h = 56.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "go_next",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104, 43)
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label2_2",
      z = 0,
      parent = "but2_2",
      text = T("\228\189\163\229\133\181"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "but2_2",
      res = "UI/alpha/1080P/battle/battle_prepare_friend_1.png",
      name = "ImageView_6234_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 47.5)
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
      name = "starImg_4",
      z = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(661.5, 267.5)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "but3_1",
      res = "UI/alpha/1080P/battle/battle_prepare_hot_2.png",
      name = "ImageView_6234_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 46.25)
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
      name = "label3_1",
      z = 0,
      parent = "but3_1",
      text = T("\230\142\168\232\141\144"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(502.5, 115)
    },
    t = "Layer",
    base = {
      parent = "layMyTeams",
      name = "layTeamitems",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(44, 0)
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
      z = 23
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
      scaleSize = CCSizeMake(108, 23)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_total_add_bg",
      z = 2,
      parent = "layMyTeams",
      res = "UI/alpha/1080P/battle/battle_prepare_my_fitbg.png",
      capInsets = CCRectMake(13.5, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(520.5, 119)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label3_2",
      z = 0,
      parent = "but3_2",
      text = T("\230\142\168\232\141\144"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "but3_2",
      res = "UI/alpha/1080P/battle/battle_prepare_hot_1.png",
      name = "ImageView_6234_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 47.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "go",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "fitImg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label4_2",
      z = 0,
      parent = "but4_2",
      text = T("\229\165\135\231\143\141"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "but4_2",
      res = "UI/alpha/1080P/hades/hades_pre_echo_2.png",
      name = "image_firework_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 47.5)
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
      name = "conform",
      z = 0,
      parent = "go",
      text = T("\230\136\152\230\150\151"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.5, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "but4_1",
      res = "UI/alpha/1080P/hades/hades_pre_echo_1.png",
      name = "image_firework_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 46.25)
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
      name = "label4_1",
      z = 0,
      parent = "but4_1",
      text = T("\229\165\135\231\143\141"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 20.75)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "go_disable",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "fitImg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(133, 126, 98),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "fitStr",
      z = 0,
      parent = "go_disable",
      text = T("\230\136\152\230\150\151"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.5, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "go_next",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "fitImg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59, 26.75)
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
      color = ccc3(247, 228, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "fitStr",
      z = 0,
      parent = "go_next",
      text = T("\228\184\139\228\184\128\230\173\165"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.5, 28.25)
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
      position = ccp(68, 51)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 57.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layMyTeams",
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "team_left_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71.5, 63)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layMyTeams",
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "team_right_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(518.5, 63)
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
      position = ccp(27.75, 18.5)
    }
  }
}

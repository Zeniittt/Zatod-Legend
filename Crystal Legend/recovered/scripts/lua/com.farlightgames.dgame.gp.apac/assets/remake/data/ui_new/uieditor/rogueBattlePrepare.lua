ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueBattlePrepare = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_prepare_bg.jpg",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 269.5)
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
      name = "image_left_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_1.png",
      capInsets = CCRectMake(17, 17, 11, 11)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(502.5, 360)
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
      name = "image_frame",
      z = 2,
      parent = "image_left_bg",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_big.png",
      capInsets = CCRectMake(245, 265, 1, 2.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(298.25, 268)
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
      name = "image_enemy_heros_bg",
      z = 1,
      parent = "image_left_bg",
      res = "UI/alpha/1080P/battle/battle_prepare_enemy_bg.png",
      capInsets = CCRectMake(150, 0.5, 17.5, 0.5)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5.75, 458)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(265, 535)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_bg_right",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_2.png",
      capInsets = CCRectMake(10, 10, 3.5, 3.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(935, 360)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(75, 263.5)
    },
    t = "Layer",
    base = {
      parent = "image_left_bg",
      name = "panel_left_btn",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-70.75, 194)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(340, 60)
    },
    t = "Layer",
    base = {
      parent = "image_enemy_heros_bg",
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
      parent = "image_enemy_heros_bg",
      text = T("\233\152\181\229\174\1851/1"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71.5, 36)
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
      name = "image_btn_filter_bg",
      z = 0,
      parent = "image_left_bg",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan.png",
      capInsets = CCRectMake(19.5, 12, 11, 12)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(3.75, 119.5)
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
      parent = "image_enemy_heros_bg",
      text = T("\230\149\140"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20, 36)
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(590, 140)
    },
    t = "Layer",
    base = {
      parent = "image_left_bg",
      name = "layer_my_teams",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4.25, 2)
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
      parent = "image_bg_right",
      res = "UI/alpha/1080P/battle/battle_prepare_fa_3.png",
      name = "bgRig2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.5, 455)
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
      parent = "panel_left_btn",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "btn_team",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 221)
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
      scaleSize = CCSizeMake(575, 277)
    },
    t = "Layer",
    base = {
      parent = "image_left_bg",
      name = "panel_heros_items",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12.75, 180.5)
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
      parent = "image_bg_right",
      res = "UI/alpha/1080P/common/battle_prepare_lins_2.png",
      name = "line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.5, 483.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 604.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_left_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_prepare_info.png",
      name = "image_title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(298.75, 511)
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
      parent = "image_bg_right",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_fight",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133, 40.5)
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
      parent = "image_btn_filter_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "lin_L",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100, 27)
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
      name = "label_team",
      z = 0,
      parent = "btn_team",
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
      parent = "btn_team",
      res = "UI/alpha/1080P/battle/battle_prepare_team_2.png",
      name = "icon_team",
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
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_btn_filter_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "lin_R",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(491, 27)
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
      parent = "btn_team",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
      name = "btn_team_select",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 36.75)
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
      fix_wh = {w = 192, h = 56.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg_right",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_go",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133, 40.5)
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
      parent = "image_btn_filter_bg",
      name = "butts_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(140, 1.5)
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
      name = "label_stage_name",
      z = 0,
      parent = "image_bg_right",
      text = T("\229\185\189\230\154\151\232\175\133\229\146\146\228\185\139\229\156\176"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 507.5)
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
      parent = "layer_my_teams",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(587.5, 61.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "myTeam9Img_4",
      z = 0,
      parent = "layer_my_teams",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(242, 174, 85),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_stage_diff",
      z = 0,
      parent = "image_bg_right",
      text = T("\233\154\190\229\186\166"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(214.5, 507.5)
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
      parent = "layer_my_teams",
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
      fix_wh = {w = 50, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_team_select",
      res = "UI/alpha/1080P/battle/battle_prepare_team_1.png",
      name = "icon_team_select",
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
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_team_select",
      z = 0,
      parent = "btn_team_select",
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
      fix_wh = {w = 11.5, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_my_teams",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 76.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg_right",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(32.5, 398)
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
      parent = "layer_my_teams",
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
      fix_wh = {w = 32, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_fight",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "icon_fight",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(575, 99.5)
    },
    t = "Layer",
    base = {
      parent = "layer_my_teams",
      name = "panel_my_hero_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(6.5, 9)
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
      name = "label_fight",
      z = 0,
      parent = "btn_fight",
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
      fix_wh = {w = 183, h = 183},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg_right",
      res = "UI/alpha/1080P/rogue/instance/instance_prepare_echo_lock.png",
      name = "revelation_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133.5, 305)
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
      parent = "layer_my_teams",
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "team_right_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(565, 65)
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
      parent = "butts_list",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "btn_all",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56.5, 25.5)
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
      parent = "butts_list",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "btn_front",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(121.5, 25.5)
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
      parent = "layer_my_teams",
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "team_left_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25, 65)
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
      parent = "butts_list",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "btn_middle",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(186.5, 25.5)
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
      parent = "butts_list",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(251.5, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 263.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg_right",
      res = "UI/alpha/1080P/rogue/instance/instance_prepare_echo_name.png",
      name = "revelation_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132, 200.5)
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
      name = "label_title_tips",
      z = 0,
      parent = "image_title_bg",
      text = T("\232\175\183\233\128\137\230\139\169\232\135\179\229\164\1547\229\144\141\232\139\177\233\155\132\229\135\186\229\190\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(302.25, 18.25)
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
      text = T("\229\188\128\229\167\139\229\134\146\233\153\169"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 123, 27),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_select_amount",
      z = 0,
      parent = "image_title_bg",
      text = "\239\188\1360/0\239\188\137",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(397.25, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(240.5, 84.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "suggest_bg",
      z = 0,
      parent = "image_bg_right",
      res = "UI/alpha/1080P/rogue/instance/instance_prepare_suggest_gs.png",
      capInsets = CCRectMake(80, 28, 80, 28)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132, 113)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 2, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg_right",
      res = "UI/alpha/1080P/rogue/main/main_title_line.png",
      name = "line2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(181, 507.5)
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
      parent = "btn_all",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "btn_all_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_all",
      z = 0,
      parent = "btn_all",
      text = T("\229\133\168\233\131\168"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
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
      parent = "btn_front",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "btn_front_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_front",
      z = 0,
      parent = "btn_front",
      text = T("\229\137\141\230\142\146"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_middle",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "btn_middle_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_middle",
      z = 0,
      parent = "btn_middle",
      text = T("\228\184\173\230\142\146"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
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
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "btn_back_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_back",
      z = 0,
      parent = "btn_back",
      text = T("\229\144\142\230\142\146"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 183, h = 183},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "revelation_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_battle_echo_bg.png",
      name = "revelation_lock_mask",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.5, 91.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 155.2, h = 112.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "revelation_bg",
      res = "UI/alpha/1080P/rogue/bless/bless_the_magician_simple.png",
      name = "revelation_icon",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 95.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(183, 135)
    },
    t = "Layer",
    base = {
      parent = "revelation_bg",
      name = "revelation_bar_clip",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 24)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 183, h = 183},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "revelation_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_prepare_echo_lock_frame.png",
      name = "revelation_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.5, 91.5)
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
      name = "label_revelation_name",
      z = 0,
      parent = "revelation_name_bg",
      text = T("\229\144\175\231\164\186\229\144\141\231\167\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131.75, 15)
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
      name = "label_suggest_tips",
      z = 0,
      parent = "suggest_bg",
      text = T("\230\142\168\232\141\144\229\185\179\229\157\135\230\136\152\229\138\155\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(142.75, 57.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 238, 125),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_suggest_gs",
      z = 0,
      parent = "suggest_bg",
      text = "1234567",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(142.75, 57.25)
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
      name = "label_average_tips",
      z = 0,
      parent = "suggest_bg",
      text = T("\229\189\147\229\137\141\229\185\179\229\157\135\230\136\152\229\138\155\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(142.75, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_average_gs",
      z = 0,
      parent = "suggest_bg",
      text = "123456",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(142.75, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 73.5, h = 74.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "revelation_lock_mask",
      res = "UI/alpha/1080P/rogue/bless/destiny_lock.png",
      name = "ImageView_48030",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.5, 91.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 183, h = 183},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "revelation_bar_clip",
      res = "UI/alpha/1080P/rogue/instance/instance_prepare_echo_actcharge.png",
      name = "revelation_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.5, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(578, 300)
    },
    t = "Layer",
    base = {
      parent = "image_left_bg",
      name = "panel_charm_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(10.25, 142.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(588, 88)
    },
    t = "Layer",
    base = {
      parent = "image_left_bg",
      name = "panel_charm_bag",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4.75, 447)
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
      parent = "panel_left_btn",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "btn_charm",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 134)
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
      parent = "image_btn_filter_bg",
      res = "UI/alpha/1080P/fireforge/others/Switch_off.png",
      name = "switch_equip_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68.5, 31.5)
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
      name = "label_charm",
      z = 0,
      parent = "btn_charm",
      text = T("\230\138\164\231\172\166"),
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
      fix_wh = {w = 24.5, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_charm",
      res = "UI/alpha/1080P/rogue/charm/charm_tab_1.png",
      name = "icon_charm",
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
      parent = "btn_charm",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_2.png",
      name = "btn_charm_select",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 37.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(587.5, 88)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_charm_bag",
      z = 0,
      parent = "panel_charm_bag",
      res = "UI/alpha/1080P/rogue/charm/charm_battle_weight_bg.png",
      capInsets = CCRectMake(350, 0.5, 100, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(294.5, 41)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 25)
    },
    t = "Layer",
    base = {
      parent = "panel_charm_bag",
      name = "panel_charm_weight",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(16, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(478, 110)
    },
    t = "Layer",
    base = {
      parent = "panel_charm_bag",
      name = "panel_charm_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(107.5, -12.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(160, 151, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_charm_bag_tip",
      z = 0,
      parent = "panel_charm_bag",
      text = T("\232\175\183\228\187\142\228\184\139\230\150\185\233\128\137\230\139\169\230\138\164\231\172\166\229\161\171\229\133\165\231\154\174\232\162\139"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(306, 41)
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
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_charm_select",
      res = "UI/alpha/1080P/rogue/charm/charm_tab_2.png",
      name = "icon_charm_select",
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
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_charm_select",
      z = 0,
      parent = "btn_charm_select",
      text = T("\230\138\164\231\172\166"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 23)
    }
  }
}

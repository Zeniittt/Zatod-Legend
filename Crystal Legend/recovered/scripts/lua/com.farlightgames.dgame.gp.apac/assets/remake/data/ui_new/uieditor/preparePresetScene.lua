ed.uieditor = ed.uieditor or {}
ed.uieditor.preparePresetScene = {
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
      position = ccp(65, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(586, 58)
    },
    t = "Scale9Sprite",
    base = {
      name = "layEmeHeros",
      z = 1,
      parent = "Panel_left",
      res = "UI/alpha/1080P/shard/shard_lv_bg.png",
      capInsets = CCRectMake(62.5, 0.5, 27, 0.5)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(71.5, 472.5)
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
      scaleSize = CCSizeMake(301, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_6285",
      z = 0,
      parent = "layEmeHeros",
      res = "UI/alpha/1080P/battle/preset/preset_name_bg.png",
      capInsets = CCRectMake(20, 0, 11.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(293, 28.5)
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
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.6, h = 30.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_6285",
      res = "UI/alpha/1080P/shard/view_bg.png",
      name = "img_btn_setting",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(283, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(275, 32)
    },
    t = "Layer",
    base = {
      parent = "ImageView_6285",
      name = "panel_input",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(15, 1.25)
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
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.65, h = 24.65},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_btn_setting",
      res = "UI/alpha/1080P/setting/setting_edit_icon.png",
      name = "ImageView_6287",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 17)
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(575, 290)
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
      fix_wh = {w = 197.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/common/battle_prepare_lins_2.png",
      name = "ImageView_line",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103, 486.5)
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(241, 239, 218),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_title",
      z = 0,
      parent = "Panel_right",
      text = T("\229\136\134\231\187\132\232\174\190\231\189\174"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102, 510)
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
      fix_wh = {w = 197.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/common/battle_prepare_lins_2.png",
      name = "ImageView_line2",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103, 110)
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(204, 375.5)
    },
    t = "Layer",
    base = {
      parent = "Panel_right",
      name = "panel_btn_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1.5, 109.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/common/button_mini_red.png",
      name = "img_btn_delete",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 58)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_right",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "img_btn_set",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(153.5, 58)
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
      color = ccc3(255, 255, 234),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6280",
      z = 99,
      parent = "img_btn_delete",
      text = T("\229\136\160\233\153\164\233\152\181\229\174\185"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(0, 0, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6280_Copy0",
      z = 0,
      parent = "img_btn_delete",
      text = T("\229\136\160\233\153\164\233\152\181\229\174\185"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 241, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6280",
      z = 99,
      parent = "img_btn_set",
      text = T("\228\191\157\229\173\152\233\152\181\229\174\185"),
      size = 16
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
      color = ccc3(0, 0, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6280_Copy0",
      z = 0,
      parent = "img_btn_set",
      text = T("\228\191\157\229\173\152\233\152\181\229\174\185"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 20.5)
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
      position = ccp(58, 53)
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
      position = ccp(27.75, 18.5)
    }
  }
}

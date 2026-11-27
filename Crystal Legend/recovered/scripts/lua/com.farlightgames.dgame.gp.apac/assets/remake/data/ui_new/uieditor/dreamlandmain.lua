ed.uieditor = ed.uieditor or {}
ed.uieditor.dreamlandmain = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "layer_frame",
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
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "layer_frame",
      name = "layer_boss_fca",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(229, 165)
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
      parent = "layer_frame",
      name = "layer_fog_front",
      z = 6
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(243, 271.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "layer_interaction",
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
      scaleSize = CCSizeMake(515, 125)
    },
    t = "Layer",
    base = {
      parent = "layer_frame",
      name = "Panel_title_lay",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 415)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "layer_frame_dream",
      z = 5
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
      opacity = 200,
      visible = true,
      scaleSize = CCSizeMake(875, 90)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_interaction_bg",
      z = 0,
      parent = "layer_interaction",
      res = "UI/alpha/1080P/scale9/dream_str_bj.png",
      capInsets = CCRectMake(10, 10, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 55.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 268.5, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_title_lay",
      res = "UI/alpha/1080P/campaign/worldmap/worldmap_title_bg.png",
      name = "image_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207, 88)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 100)
    },
    t = "Layer",
    base = {
      parent = "layer_interaction",
      name = "layer_chance",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(583.5, 10)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(137, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(22.5, 0, 3, 0.5),
      res = "UI/alpha/1080P/activity/activity_str_bg.png",
      name = "btn_announced",
      z = 6
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(856, 501)
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
      parent = "layer_interaction",
      name = "buttLay",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45, 165)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 126.5, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_title_bg",
      res = "UI/alpha/1080P/dreamland/dream_title_img.png",
      name = "image_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97.25, 19.75)
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
      parent = "image_title_bg",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(188.75, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(690, 78)
    },
    t = "Layer",
    base = {
      parent = "layer_interaction",
      name = "Panel_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(53.5, 17)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(475, 250)
    },
    t = "Layer",
    base = {
      parent = "layer_frame_dream",
      name = "layer_boss_detail",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(453, 245.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 194.6, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_chance",
      res = "UI/alpha/1080P/pvp/battlenum_bg.png",
      name = "label_left_chance_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(228.5, 69)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_chance",
      res = "UI/alpha/1080P/main/main_status_plus_icon_1.png",
      name = "chance_add_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(310.5, 69)
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
      name = "ImageView_5844",
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
      fix_wh = {w = 64, h = 61.5},
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
      normal = "GUI/button.png",
      name = "btn_battle",
      z = 5,
      parent = "layer_frame_dream",
      text = "",
      press = "null",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(817, 43)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(151, 224, 79),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_chance_title",
      z = 5,
      parent = "layer_chance",
      text = T("\228\187\138\230\151\165\229\137\169\228\189\153\230\172\161\230\149\176\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212.5, 69)
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
      parent = "layer_chance",
      name = "label_left_chance",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(264.5, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 150)
    },
    t = "Layer",
    base = {
      parent = "layer_frame_dream",
      name = "layer_status",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(46.5, 14)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(48, 48)
    },
    t = "Layer",
    base = {
      parent = "buttLay",
      name = "btn_rank_list_lay",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 215.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(48, 48)
    },
    t = "Layer",
    base = {
      parent = "buttLay",
      name = "btn_hot_lay",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 73)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(600, 125)
    },
    t = "Layer",
    base = {
      parent = "layer_frame_dream",
      name = "image_no_status_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(46.5, 14)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(48, 48)
    },
    t = "Layer",
    base = {
      parent = "buttLay",
      name = "btn_shop_lay",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 143)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(48, 48)
    },
    t = "Layer",
    base = {
      parent = "buttLay",
      name = "btn_rewards_lay",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 65)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_announced",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "ImageView_38",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 16.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(48, 48)
    },
    t = "Layer",
    base = {
      parent = "buttLay",
      name = "btn_playback_lay",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, -15)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(656, 74)
    },
    t = "Scale9Sprite",
    base = {
      name = "intteraction_bg",
      z = 0,
      parent = "Panel_bg",
      res = "UI/alpha/1080P/dreamland/dream_reward_bg_2.png",
      capInsets = CCRectMake(75, 0, 5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(326.5, 39)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "layer_boss_detail",
      name = "layer_boss_name",
      z = 10
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(239, 222.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 251, h = 74},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_bg",
      res = "UI/alpha/1080P/dreamland/dream_rank_bg.png",
      name = "ImageView_6266_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134, 38.5)
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
      parent = "layer_boss_detail",
      name = "layer_time_info",
      z = 10
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(239, 190)
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
      name = "Label_39",
      z = 0,
      parent = "btn_announced",
      text = T("\230\156\170\230\157\165\233\162\132\232\168\128"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "layer_boss_detail",
      name = "node_stage_skill",
      z = 15
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(191.5, 277)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_boss_detail",
      res = "UI/alpha/1080P/dreamland/dream1_img_2.png",
      name = "image_bossName",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(165, 221.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 39, h = 7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_boss_detail",
      res = "UI/alpha/1080P/dreamland/dream1_img_2.png",
      name = "image_title_bg_Copy0",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(312.5, 221.5)
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
      name = "label_title_boss_desc",
      z = 3,
      parent = "layer_boss_detail",
      text = T("BOSS\228\187\139\231\187\141"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(105, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 54, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rank_list_lay",
      res = "UI/alpha/1080P/dreamland/dream_paihan_img.png",
      name = "btn_rank_list",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.5, h = 8},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_rank_list_lay",
      res = "UI/alpha/1080P/dreamland/dream3_img.png",
      name = "ImageView_5741",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, -7)
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
      name = "label_boss_desc",
      z = 1,
      parent = "layer_boss_detail",
      text = "",
      size = 14
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(107, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rank_list_lay",
      res = "UI/alpha/1080P/dreamland/dream_button_bg.png",
      name = "ImageView_6270",
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
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title_boss_skill",
      z = 3,
      parent = "layer_boss_detail",
      text = T("\230\138\128\232\131\189"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(105, 154.5)
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
      parent = "btn_hot_lay",
      res = "UI/alpha/1080P/dreamland/dream_remen_imgss.png",
      name = "btn_hot",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.5, h = 8},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_hot_lay",
      res = "UI/alpha/1080P/dreamland/dream3_img.png",
      name = "ImageView_5741",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, -6.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 50)
    },
    t = "Layer",
    base = {
      parent = "layer_boss_detail",
      name = "layer_boss_skill",
      z = 99
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(99, 92.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_hot_lay",
      res = "UI/alpha/1080P/dreamland/dream_button_bg.png",
      name = "ImageView_6270_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 24)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(135, 20)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_5976",
      z = 1,
      parent = "layer_boss_detail",
      res = "UI/alpha/1080P/dreamland/dream_suggest_bg.png",
      capInsets = CCRectMake(15, 0, 50, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132, 25)
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
      name = "label_damage_title",
      z = 0,
      parent = "layer_status",
      text = T("\233\128\160\230\136\144\228\188\164\229\174\179\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(69.5, 24)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.5, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_lay",
      res = "UI/alpha/1080P/dreamland/dream_duihuan_img.png",
      name = "btn_shop",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, 24)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.5, h = 8},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_lay",
      res = "UI/alpha/1080P/dreamland/dream3_img.png",
      name = "ImageView_5741",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, -6.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_boss_detail",
      res = "UI/alpha/1080P/dreamland/dream2_img.png",
      name = "ImageView_5976_Copy0",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91, 154)
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
      name = "label_rank_title",
      z = 0,
      parent = "layer_status",
      text = T("\229\189\147\229\137\141\230\142\146\229\144\141\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(69.5, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_shop_lay",
      res = "UI/alpha/1080P/dreamland/dream_button_bg.png",
      name = "ImageView_6270_Copy0",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 372, h = 509},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_boss_detail",
      res = "UI/alpha/1080P/dreamland/dream_tit_bj.png",
      name = "boss_desc_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(239.5, 9)
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
      name = "label_rank",
      z = 0,
      parent = "layer_status",
      text = "101",
      size = 11
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(240.5, 51.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rewards_lay",
      res = "UI/alpha/1080P/dreamland/dream_rewards_img.png",
      name = "btn_rewards",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, 24)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.5, h = 8},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_rewards_lay",
      res = "UI/alpha/1080P/dreamland/dream3_img.png",
      name = "ImageView_574132",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, -6.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 259.5, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_boss_detail",
      res = "UI/alpha/1080P/dreamland/dream_title_bj.png",
      name = "ImageView_6259",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(241.5, 219.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "layer_status",
      name = "layer_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(146, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rewards_lay",
      res = "UI/alpha/1080P/dreamland/dream_button_bg.png",
      name = "ImageView_62706343",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 359.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_boss_detail",
      res = "UI/alpha/1080P/dreamland/dream_time_img.png",
      name = "ImageView_6259_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(240.5, 191)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 233, 210),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reward_title",
      z = 0,
      parent = "layer_status",
      text = T("\231\187\147\231\174\151\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(348, 43)
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
      name = "str1",
      z = 5,
      parent = "image_no_status_bg",
      text = T("\229\189\147\229\137\141\230\142\146\229\144\141\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(69.5, 58)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_38",
      res = "UI/alpha/1080P/dreamland/dream_announce_enter_icon.png",
      name = "ImageView_176",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.75, 16.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_playback_lay",
      res = "UI/alpha/1080P/dreamland/dream_record_img.png",
      name = "btn_playback",
      z = 3
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
      color = ccc3(0, 0, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_rank_bj",
      z = 0,
      parent = "btn_rank_list",
      text = T("\230\142\146\232\161\140\230\166\156"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, -5.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(209, 244, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_rank",
      z = 1,
      parent = "btn_rank_list",
      text = T("\230\142\146\232\161\140\230\166\156"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, -5.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.5, h = 8},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_playback_lay",
      res = "UI/alpha/1080P/dreamland/dream3_img.png",
      name = "ImageView_574132",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, -6.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_boss_detail",
      res = "UI/alpha/1080P/dreamland/dream2_img.png",
      name = "ImageView_5976_Copy1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91, 25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 60)
    },
    t = "Layer",
    base = {
      parent = "layer_status",
      name = "layer_reward_items",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(353, 13)
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
      name = "label_no_status",
      z = 5,
      parent = "image_no_status_bg",
      text = T("\232\191\153\230\152\175\228\189\160\228\187\138\229\164\169\231\172\172\228\184\128\230\172\161\230\140\145\230\136\152\230\176\184\231\148\159\230\162\166\229\162\131\231\154\132BOSS\227\128\130"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(322.5, 41)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_playback_lay",
      res = "UI/alpha/1080P/dreamland/dream_button_bg.png",
      name = "ImageView_62706343",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(95, 20)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_5976_Copy2",
      z = 1,
      parent = "layer_boss_detail",
      res = "UI/alpha/1080P/dreamland/dream_suggest_bg.png",
      capInsets = CCRectMake(15, 0, 50, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 154)
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
      parent = "layer_status",
      name = "label_damage",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(150, 25)
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
      name = "str1_Copy0",
      z = 5,
      parent = "image_no_status_bg",
      text = T("\233\128\160\230\136\144\228\188\164\229\174\179\239\188\154"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(69.5, 24)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 301, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_boss_detail",
      res = "UI/alpha/1080P/dreamland/dream_info_line.png",
      name = "ImageView_6263",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(237.5, 54.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.5, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_status",
      res = "UI/alpha/1080P/common/nextbtnmask.png",
      name = "ImageView_6269",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(494, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "image_no_status_bg",
      name = "layer_rank_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(137, 88.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(209, 244, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_hot",
      z = 1,
      parent = "btn_hot",
      text = T("\231\131\173\233\151\168"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, -5.75)
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
      name = "Label_hot_bj",
      z = 0,
      parent = "btn_hot",
      text = T("\231\131\173\233\151\168"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24, -5.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 77, 75),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage_txt",
      z = 0,
      parent = "layer_status",
      text = "0",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(149.5, 24.5)
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
      parent = "image_no_status_bg",
      name = "label_damage_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(146.5, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(122, 195, 250),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "layer_rank_txt",
      z = 0,
      parent = "layer_status",
      text = "0",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(148, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "image_no_status_bg",
      name = "layer_rank_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(142.5, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(122, 195, 250),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "layer_rank_txt_Copy0",
      z = 0,
      parent = "image_no_status_bg",
      text = "0",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(148, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(209, 244, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_shop",
      z = 1,
      parent = "btn_shop",
      text = T("\229\133\145\230\141\162"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.75, -6.25)
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
      name = "Label_shop_bj",
      z = 0,
      parent = "btn_shop",
      text = T("\229\133\145\230\141\162"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.75, -6.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 77, 75),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage_txt_Copy0",
      z = 0,
      parent = "image_no_status_bg",
      text = "0",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(149.5, 24.5)
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
      name = "Label_rewards_bj",
      z = 0,
      parent = "btn_rewards",
      text = T("\229\165\150\229\138\177"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.5, -11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(209, 244, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_rewards",
      z = 1,
      parent = "btn_rewards",
      text = T("\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.5, -11)
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
      name = "Label_playback_bj",
      z = 0,
      parent = "btn_playback",
      text = T("\232\174\176\229\189\149"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, -10.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(209, 244, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_playback",
      z = 1,
      parent = "btn_playback",
      text = T("\232\174\176\229\189\149"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, -10.75)
    }
  }
}

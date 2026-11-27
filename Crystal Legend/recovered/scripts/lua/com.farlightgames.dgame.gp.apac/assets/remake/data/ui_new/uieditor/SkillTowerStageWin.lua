ed.uieditor = ed.uieditor or {}
ed.uieditor.SkillTowerStageWin = {
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
      position = ccp(186, 509.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 109, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skilltower/bg_btn_reward.png",
      name = "btn_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(742.5, 509.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(89.5, 20)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(14.5, 10.5, 15, 30.5),
      res = "UI/alpha/1080P/package/bg_soldout.png",
      name = "bg_btn_power",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(883.5, 510)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 109, h = 34},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skilltower/bg_btn_reward.png",
      name = "btn_buff",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(742.5, 508.5)
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
    base = {name = "layer_main", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 127, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_title",
      res = "UI/alpha/1080P/skilltower/title_tower1.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 17.75)
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
      position = ccp(186.75, 17.75)
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
      name = "Label_4587",
      z = 0,
      parent = "btn_reward",
      text = T("\233\155\134\230\152\159\229\165\150\229\138\177"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 19)
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
      parent = "bg_btn_power",
      res = "UI/alpha/1080P/main/main_status_plus_icon_1.png",
      name = "icon_add_power",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-2.75, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn_power",
      res = "UI/alpha/1080P/icon/fancytower_candle.png",
      name = "icon_power",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 13)
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
      name = "label_power",
      z = 0,
      parent = "bg_btn_power",
      text = "56/80",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.75, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18, h = 17.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_buff",
      res = "UI/alpha/1080P/skilltower/icon_star.png",
      name = "icon_buff",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 19)
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
      name = "label_buff",
      z = 0,
      parent = "btn_buff",
      text = T("\229\185\187\229\162\131\232\181\144\231\166\143"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(703.5, 457)
    },
    t = "Scale9Sprite",
    base = {
      name = "frame_main",
      z = 1,
      parent = "layer_main",
      res = "UI/alpha/1080P/skilltower/frame_stage.png",
      capInsets = CCRectMake(150, 150, 150, 150)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(112, -28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 960, h = 540},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_main",
      res = "UI/alpha/1080P/battle_bg/bbg_arena.jpg",
      name = "bg_stage",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(112, -28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.1999973, h = 16.1999973},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reward",
      res = "UI/alpha/1080P/skilltower/detail_star.png",
      name = "icon_star",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20, 19)
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
      parent = "btn_reward",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "icon_redLight",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100.5, 29)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame_main",
      res = "UI/alpha/1080P/skilltower/icon_arrow.png",
      name = "icon_arrow",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.75, 229.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(703.5, 457)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_stage_lock",
      z = 2,
      parent = "frame_main",
      res = "UI/alpha/1080P/skilltower/bg_unstage_tower1.png",
      capInsets = CCRectMake(150, 150, 150, 150)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(351.75, 228.5)
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
      parent = "frame_main",
      name = "layer_battle",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(351.75, 228.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(662.5, 416)
    },
    t = "Layer",
    base = {
      parent = "frame_main",
      name = "layer_enemy",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(20.75, 20.5)
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
      name = "label_task",
      z = 0,
      parent = "layer_battle",
      text = T("\233\155\134\230\152\159\230\157\161\228\187\182"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-309.5, -79.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 247, 152),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4672",
      z = 0,
      parent = "bg_stage_lock",
      text = T("\229\189\147\229\137\141\229\177\130\231\186\167"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(351.75, 247.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 247, 152),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_unlock_contition",
      z = 0,
      parent = "bg_stage_lock",
      text = T("\230\136\152\233\152\159\232\190\190\229\136\176\231\173\137\231\186\16746\231\186\167\229\144\142\229\188\128\230\148\190\230\140\145\230\136\152"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(351.75, 209)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 189.5, h = 108},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "icon_arrow",
      res = "UI/alpha/1080P/skilltower/light_selected.png",
      name = "light",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-99, 23.75)
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
      parent = "layer_battle",
      name = "layer_right",
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
      parent = "layer_battle",
      name = "layer_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(11.5, 179)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 300.5, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "label_task",
      res = "UI/alpha/1080P/skilltower/bg_step.png",
      name = "bg_task1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, -24.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 300.5, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "label_task",
      res = "UI/alpha/1080P/skilltower/bg_step.png",
      name = "bg_task2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, -56.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 300.5, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "label_task",
      res = "UI/alpha/1080P/skilltower/bg_step.png",
      name = "bg_task3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, -87.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(62, 40, 25),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_floor",
      z = 0,
      parent = "layer_title",
      text = T("\231\172\172\228\184\128\229\177\130"),
      size = 20
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
      fix_wh = {w = 13.5, h = 13.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_title",
      res = "UI/alpha/1080P/skilltower/title_point.png",
      name = "ImageView_4632",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, -3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 13.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_title",
      res = "UI/alpha/1080P/skilltower/title_point.png",
      name = "ImageView_4633",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-50.5, -3)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 40)
    },
    t = "Layer",
    base = {
      parent = "layer_right",
      name = "layer_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(117, -133)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(137.5, 45),
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
      capInsets = CCRectMake(10, 22, 0.5, 19.5),
      name = "btn_start",
      z = 0,
      parent = "layer_right",
      text = "",
      press = "UI/alpha/1080P/common/button_com_big.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(248.5, -178.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(87.5, 45),
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
      name = "btn_rush",
      z = 0,
      parent = "layer_right",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133, -178.5)
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
      name = "label_cost",
      z = 0,
      parent = "layer_right",
      text = T("\230\140\145\230\136\152\230\182\136\232\128\151"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(282.5, -145.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4, x = 0.4},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_right",
      res = "UI/alpha/1080P/icon/fancytower_candle.png",
      name = "ImageView_4666",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(296, -144.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18, h = 17.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_task1",
      res = "UI/alpha/1080P/skilltower/icon_condition.png",
      name = "icon_star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, 12.5)
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
      name = "label_task1",
      z = 0,
      parent = "bg_task1",
      text = T("90\231\167\146\229\134\133\233\128\154\229\133\179"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.5, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18, h = 17.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_task2",
      res = "UI/alpha/1080P/skilltower/icon_condition.png",
      name = "icon_star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, 12.5)
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
      name = "label_task2",
      z = 0,
      parent = "bg_task2",
      text = T("\230\136\145\230\150\185\232\139\177\233\155\132\229\133\168\233\131\168\229\173\152\230\180\187"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.5, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18, h = 17.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_task3",
      res = "UI/alpha/1080P/skilltower/icon_condition.png",
      name = "icon_star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, 12.5)
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
      name = "label_task3",
      z = 0,
      parent = "bg_task3",
      text = T("\228\184\141\228\189\191\231\148\168\229\137\141\230\142\146\232\139\177\233\155\132\233\128\154\229\133\179\230\156\172\229\177\130"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.5, 12.5)
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
      name = "label_reward",
      z = 0,
      parent = "layer_reward",
      text = T("\233\128\154\229\133\179\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(198, 53.5)
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
      parent = "btn_start",
      text = T("\230\140\145 \230\136\152"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91.75, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.599998464, h = 26.399998416},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_start",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "icon_battle",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.25, 22.5)
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
      parent = "btn_rush",
      text = T("\230\137\171\232\141\161"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43.75, 23.5)
    }
  }
}

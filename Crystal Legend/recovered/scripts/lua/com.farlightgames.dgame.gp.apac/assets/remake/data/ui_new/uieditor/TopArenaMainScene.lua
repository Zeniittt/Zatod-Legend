ed.uieditor = ed.uieditor or {}
ed.uieditor.TopArenaMainScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 278, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pvp/battlenum_bg.png",
      name = "bg_times",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(652, 490)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(154.5, 34)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_switch",
      z = 1,
      parent = "bg_times",
      res = "UI/alpha/1080P/skilltower/bg_btn_reward.png",
      capInsets = CCRectMake(10, 10, 78.5, 14)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(398, 13.75)
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
      name = "label_switch",
      z = 0,
      parent = "btn_switch",
      text = T("\229\136\183\230\150\176  8/10"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.25, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_switch",
      res = "UI/alpha/1080P/pvp/refresh.png",
      name = "icon_switch",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29.75, 18.5)
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
      name = "label_times",
      z = 0,
      parent = "bg_times",
      text = T("\228\187\138\230\151\165\229\137\169\228\189\153\230\140\145\230\136\152\230\172\161\230\149\176\239\188\1545/5"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139, 15.25)
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
      parent = "btn_switch",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "icon_redLight",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.25, 29)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 50)
    },
    t = "Layer",
    base = {name = "layer_btn", z = 2},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-75, 266.5)
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
      parent = "bg_times",
      res = "UI/alpha/1080P/main/main_status_plus_icon_1.png",
      name = "btn_addtimes",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(256, 15.75)
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
      parent = "bg_times",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "refresh_tip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(495, 15.75)
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
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.5, 504)
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
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, -105)
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
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1170, 540)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(250, 260, 670, 20),
      res = "UI/alpha/1080P/toparena/toparena_frame_1.png",
      name = "bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
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
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 15)
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
      parent = "refresh_tip",
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
      fix_wh = {w = 50.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn5",
      res = "UI/alpha/1080P/toparena/toparena_shop_icon.png",
      name = "icon_btn5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
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
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 135)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 507, h = 44.5},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/toparena_promotion_countdown.png",
      name = "bg_evolve_info",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(753.5, 498)
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
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, -45)
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
      position = ccp(207.75, 17.75)
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
      parent = "bg_btn2",
      res = "UI/alpha/1080P/pvp/reward.png",
      name = "icon_btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
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
      name = "label_btn5",
      z = 0,
      parent = "icon_btn5",
      text = T("\229\133\145\230\141\162"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.25, 8.75)
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
      parent = "bg_btn2",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "img_reward_red_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 47)
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
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, -165)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 638, h = 237.5},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/toparena_total_end.png",
      name = "offSeason_img",
      z = 9999
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(640.5, 276.5)
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
      parent = "layer_btn",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "bg_btn7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, -225)
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
      parent = "bg_btn3",
      res = "UI/alpha/1080P/pvp/record.png",
      name = "icon_btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
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
      parent = "bg_btn3",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "recordTag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 47)
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
      name = "label_btn2",
      z = 0,
      parent = "icon_btn2",
      text = T("\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, 2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 397.5, h = 591},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/toparena_player_info_bg.png",
      name = "bg_banner",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(258, 262.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn1",
      res = "UI/alpha/1080P/pvp/ranking.png",
      name = "icon_btn1",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 540)
    },
    t = "Scale9Sprite",
    base = {
      name = "deco_mid",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/toparena/toparena_frame_2.png",
      capInsets = CCRectMake(150, 250, 200, 40)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(587, 267.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/toparena_bg_1.png",
      name = "bg_enemy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(539.5, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 43.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn4",
      res = "UI/alpha/1080P/toparena/toparena_history_icon.png",
      name = "icon_btn4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
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
      name = "label_btn3",
      z = 0,
      parent = "icon_btn3",
      text = T("\232\174\176\229\189\149"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 2.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/toparena_bg_1.png",
      name = "bg_enemy2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(772, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/toparena_bg_1.png",
      name = "bg_enemy3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1002.5, 5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(236, 252, 254),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_limit_time",
      z = 0,
      parent = "bg_evolve_info",
      text = T("\230\153\139\231\186\167\232\181\155\229\137\169\228\189\153\230\151\182\233\151\180\239\188\15423:10"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(135, 22.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46.5, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn6",
      res = "UI/alpha/1080P/toparena/toparena_report_icon.png",
      name = "icon_btn6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 33)
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
      parent = "bg",
      name = "layer_main",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(585, 270)
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
      parent = "bg_evolve_info",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_evolve_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(372, 22.25)
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
      name = "label_btn1",
      z = 0,
      parent = "icon_btn1",
      text = T("\230\142\146\232\161\140\230\166\156"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.5, 8)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(700, 391)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_history",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/com_new_2.png",
      capInsets = CCRectMake(20, 20, 50, 351)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(419, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.29999983, x = 1.29999983},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29.89999609, h = 30.549996005},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_evolve_info",
      res = "UI/alpha/1080P/activityadventure/adventure_clock_1.png",
      name = "ImageView_2104",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115, 22.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_btn7",
      res = "UI/alpha/1080P/toparena/toparena_star_icon.png",
      name = "icon_btn7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117, h = 122},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/toparena/rank/toparena_rank_icon_1.png",
      name = "icon_grade",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(199.75, 380)
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
      parent = "bg_btn7",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "img_ban_hero_red_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52, 47)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(191, 57),
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
      capInsets = CCRectMake(20, 15.5, 90, 32.5),
      name = "btn_change",
      z = 2,
      parent = "bg_banner",
      text = "",
      press = "UI/alpha/1080P/common/button_com_big.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 93.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 114.75, h = 53.125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/toparena/rank/toparena_rankname_2.png",
      name = "name_grade",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200.75, 333.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 184, 142),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_season",
      z = 1,
      parent = "bg_banner",
      text = "Text Label",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 452.5)
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
      name = "Label_108",
      z = 0,
      parent = "offSeason_img",
      text = T("\229\189\147\229\137\141\229\164\132\228\186\142\228\188\145\232\181\155\228\184\173"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(319, 130.25)
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
      name = "score",
      z = 1,
      parent = "bg_banner",
      text = "Text Label",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 157)
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
      name = "label_btn4",
      z = 0,
      parent = "icon_btn4",
      text = T("\230\136\152\231\187\169"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.5, 5.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 303, h = 269.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/toparena/toparena_promotion_frozen.png",
      name = "ImageView_929",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 361.5)
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
      name = "Label_108_Copy0",
      z = 0,
      parent = "offSeason_img",
      text = T("\230\150\176\232\181\155\229\173\163\229\141\179\229\176\134\229\188\128\229\144\175\239\188\140\230\149\172\232\175\183\230\156\159\229\190\133"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(319, 101.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 256, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/toparena/toparena_player_info.png",
      name = "bg_zone",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 289.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 256, h = 25.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/toparena/toparena_player_info.png",
      name = "bg_medal",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 246.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 256, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/toparena/toparena_player_info.png",
      name = "bg_defendgs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 236.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 283, h = 117},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/toparena/toparena_score_bg.png",
      name = "bg_score",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 155)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 303, h = 269.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/toparena/toparena_promotion_frozen.png",
      name = "bg_score_fronze",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 147)
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
      name = "label_btn6",
      z = 0,
      parent = "icon_btn6",
      text = T("\230\177\135\230\128\187"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.25, 8.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 83.5, h = 39.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/toparena/toparena_warning.png",
      name = "bg_punishi",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(284.25, 156.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 249.5, h = 129},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/toparena/toparena_total_rank_bg2.png",
      name = "bg_selfrank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 519.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 46},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/toparena/toparena_player_title_bg.png",
      name = "banner_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 491.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 256, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_banner",
      res = "UI/alpha/1080P/toparena/toparena_player_info.png",
      name = "bg_zone_rank",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 263)
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
      name = "label_change",
      z = 0,
      parent = "btn_change",
      text = T("\233\152\181\229\174\185\232\176\131\230\149\180"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.2, h = 25.85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_change",
      res = "UI/alpha/1080P/pvp/lineup.png",
      name = "icon_change",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.5, 28.5)
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
      parent = "btn_evolve_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "icon_rule1",
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
      name = "label_btn7",
      z = 0,
      parent = "icon_btn7",
      text = T("\229\134\179\230\150\151\228\185\139\230\152\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.5, 8)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(219, 255, 254),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_frozen",
      z = 0,
      parent = "ImageView_929",
      text = T("\231\167\175\229\136\134\229\134\187\231\187\147\228\184\173..."),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(157, 182.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 629, h = 302},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_history",
      res = "UI/alpha/1080P/toparena/toparena_summary_title_bg.png",
      name = "ImageView_2687",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 448)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_zone_title",
      z = 1,
      parent = "bg_zone",
      text = T("\232\181\155    \229\140\186\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(31.5, 12.75)
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
      name = "label_zone",
      z = 0,
      parent = "bg_zone",
      text = T("\231\172\172123\232\181\155\229\140\186"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(122.5, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(675, 312)
    },
    t = "Layer",
    base = {
      parent = "bg_history",
      name = "Panel_2809",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_history",
      res = "UI/alpha/1080P/toparena/toparena_summary_bg.png",
      name = "ImageView_2810",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 352.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_medal_title",
      z = 1,
      parent = "bg_medal",
      text = T("\229\139\139    \231\171\160\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(31.5, 13.25)
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
      name = "label_medal",
      z = 0,
      parent = "bg_medal",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(122.5, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_medal",
      res = "UI/alpha/1080P/icon/money_top_pvp_big.png",
      name = "ImageView_3560",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(128, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_defend_gs_title",
      z = 1,
      parent = "bg_defendgs",
      text = T("\233\152\178\229\174\136\230\136\152\229\138\155\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(31.5, 14.25)
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
      name = "label_defend_gs",
      z = 0,
      parent = "bg_defendgs",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(122.5, 13.25)
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
      parent = "bg_score",
      res = "UI/alpha/1080P/toparena/toparena_score_icon.png",
      name = "icon_score1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141.5, 96)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(219, 255, 254),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_frozen",
      z = 0,
      parent = "bg_score_fronze",
      text = T("\231\167\175\229\136\134\229\134\187\231\187\147\228\184\173..."),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(157, 182.25)
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
      name = "Label_2118",
      z = 0,
      parent = "bg_punishi",
      text = "-75",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.25, 19.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(39, 221.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "punishi_info",
      z = 0,
      parent = "bg_punishi",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(10, 10, 19, 201.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.75, 71.75)
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
      parent = "bg_selfrank",
      res = "UI/alpha/1080P/toparena/text_no.png",
      name = "noself",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124.75, 39)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 247, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_banner_title",
      z = 1,
      parent = "banner_title",
      text = T("\230\136\145\231\154\132\228\191\161\230\129\175"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "banner_title",
      res = "",
      name = "ImageView_74949",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.5, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 154, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_zonerank_title",
      z = 1,
      parent = "bg_zone_rank",
      text = T("\232\181\155\229\140\186\230\142\146\229\144\141\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(31.5, 12.75)
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
      name = "label_zonerank",
      z = 0,
      parent = "bg_zone_rank",
      text = "",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(122.5, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 33.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_2687",
      res = "UI/alpha/1080P/toparena/toparena_summary_title.png",
      name = "ImageView_2808",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(314.5, 90.5)
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
      name = "label_icon_score1",
      z = 0,
      parent = "icon_score1",
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
      color = ccc3(255, 244, 211),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_2811",
      z = 0,
      parent = "ImageView_2810",
      text = T("S1\232\181\155\229\173\163\229\183\178\231\187\147\230\157\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(112, 13)
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
      name = "label_self_des",
      z = 0,
      parent = "bg_selfrank",
      text = T("\229\133\168\230\156\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92.75, 40.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.kingsMainScene = {
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
      name = "image_title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88, 507.5)
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
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(220.25, 17.75)
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
      name = "ImageView_27775",
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
      fix_wh = {w = 275, h = 338},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/main/normal_bg.png",
      name = "btn_room_mode",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(186.5, 294)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 275, h = 338},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/main/normal_bg.png",
      name = "btn_normal_match",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(759.5, 294)
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
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_battle_record",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-42.5, 350)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 335, h = 460},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/main/high_bg.png",
      name = "btn_rank_match",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 303.5)
    }
  },
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
      res = "UI/alpha/1080P/newkingspvp/main/main_bg.jpg",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(560, 90)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(300, 30, 5, 30),
      res = "UI/alpha/1080P/newkingspvp/main/free_bg.png",
      name = "image_free_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(199, 56.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.6, h = 41.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_battle_record",
      res = "UI/alpha/1080P/pvp/record.png",
      name = "icon_battle_record",
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
      name = "label_battle_record",
      z = 0,
      parent = "btn_battle_record",
      text = T("\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 3.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(402.5, 80)
    },
    t = "Layer",
    base = {
      parent = "image_free_bg",
      name = "panel_free",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(147.5, 5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 129),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_date",
      z = 0,
      parent = "image_free_bg",
      text = "8.15-8.22",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 27)
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
      parent = "image_free_bg",
      name = "panel_free_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(14, 44)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 220, h = 75.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rank_match",
      res = "UI/alpha/1080P/newkingspvp/main/rank_bg.png",
      name = "image_rank_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168.5, 181)
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
      name = "label_my_rank",
      z = 0,
      parent = "image_rank_bg",
      text = T("\228\184\135\229\143\164\230\181\129\232\138\179"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 33.25)
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
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_rank",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-42.5, 425)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 66},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_history",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-42.5, 275)
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
      parent = "btn_room_mode",
      name = "panel_room_mode_name",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(143, 93)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 132, h = 132},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_room_mode",
      res = "UI/alpha/1080P/newkingspvp/main/room_mode.png",
      name = "room_mode_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141.5, 204)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 120, h = 120},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_normal_match",
      res = "UI/alpha/1080P/newkingspvp/main/normal_match.png",
      name = "narmal_match_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142.5, 204.5)
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
      parent = "btn_normal_match",
      name = "panel_narmal_match_name",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(142.5, 94.5)
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
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_reward",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-42, 275)
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
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_grade",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-42, 200)
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
      parent = "btn_rank_match",
      name = "panel_season_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(168.5, 380.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 210, h = 170},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rank_match",
      res = "UI/alpha/1080P/newkingspvp/main/high_match.png",
      name = "rank_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168.5, 273)
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
      parent = "btn_rank_match",
      name = "panel_rank_match_name",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(168.5, 118.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 402.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/main/punish_bg.png",
      name = "image_punish_tips_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 497)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 228, 101),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_my_rank_score",
      z = 0,
      parent = "image_rank_bg",
      text = T("\231\167\175\229\136\134\239\188\154123456"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(72, 11.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.05, x = 1.05},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.75, h = 51.45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rank",
      res = "UI/alpha/1080P/pvp/ranking.png",
      name = "icon_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 38.5)
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
      name = "label_rank",
      z = 0,
      parent = "btn_rank",
      text = T("\230\142\146\232\161\140\230\166\156"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 3.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_rank_bg",
      res = "UI/alpha/1080P/newkingspvp/rank/rank_1_s.png",
      name = "image_my_rank_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 24.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42.9, h = 47.85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_history",
      res = "UI/alpha/1080P/toparena/toparena_history_icon.png",
      name = "icon_history",
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
      name = "label_history",
      z = 0,
      parent = "btn_history",
      text = T("\229\142\134\229\143\178\230\136\152\231\187\169"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 3.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.3, h = 40.7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reward",
      res = "UI/alpha/1080P/pvp/reward.png",
      name = "icon_reward",
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
      name = "label_reward",
      z = 0,
      parent = "btn_reward",
      text = T("\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 3.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58.3, h = 58.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_grade",
      res = "UI/alpha/1080P/newkingspvp/main/rank_desc.png",
      name = "icon_grade",
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
      name = "label_grade",
      z = 0,
      parent = "btn_grade",
      text = T("\230\174\181\228\189\141\232\175\180\230\152\142"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 3.5)
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
      name = "image_reward_red_dot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 49.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 108, 108),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_punish_tips",
      z = 0,
      parent = "image_punish_tips_bg",
      text = T("\230\151\160\230\179\149\232\191\155\232\161\140\229\140\185\233\133\141\239\188\140\231\166\129\232\181\155\230\151\182\233\151\180\229\137\169\228\189\153\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207.75, 49.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 227),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_punish_left_time",
      z = 0,
      parent = "image_punish_tips_bg",
      text = "00:00",
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(201.25, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 172.5, h = 142},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/legendactivity/main_bufficon.png",
      name = "image_buff_icon",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 93.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 176.5, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rank_match",
      res = "UI/alpha/1080P/activity/legendactivity/main_opentime.png",
      name = "image_rank_match_time_limit",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(167.5, 77.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_buff_icon",
      res = "UI/alpha/1080P/activity/legendactivity/buff_board4.png",
      name = "ImageView_23973",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86.25, 7.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rank_math_time_limit",
      z = 0,
      parent = "image_rank_match_time_limit",
      text = T("\230\175\143\230\151\16518-22\231\130\185\229\188\128\230\148\190"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.25, 13)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.5, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_23973",
      res = "UI/alpha/1080P/activity/legendactivity/buff_time.png",
      name = "ImageView_24003",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 15)
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
      name = "label_buff_left_time",
      z = 0,
      parent = "ImageView_23973",
      text = T("\229\137\169\228\189\1533\229\164\16910\229\176\143\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.5, 15)
    }
  }
}

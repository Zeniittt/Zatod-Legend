ed.uieditor = ed.uieditor or {}
ed.uieditor.DragonBoatMainScene = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "layer_BG", z = 0},
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
      fix_wh = {w = 333, h = 59},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/stage_reward/bg_db_title.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(128.5, 508.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(251, 62)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(100, 0, 51, 0.5),
      res = "UI/alpha/1080P/dragonboat/db_race/db_overhead_banner_new.png",
      name = "notice_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(486, 471)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 139.5, h = 63},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_race/db_speed.png",
      name = "current_speed_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(923.5, 482)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 163.2, h = 116.4},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_race/db_zongzi.png",
      name = "btn_use_zongzi",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(968.5, 102.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 78},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_race/db_ranking_icon.png",
      name = "btn_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-23.5, 441)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 78},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_race/db_reward_icon.png",
      name = "btn_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-23.5, 355.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 78},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_race/db_boat_icon.png",
      name = "btn_boat",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-23.5, 270.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 78},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_race/db_pass_icon.png",
      name = "btn_pass",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-23.5, 185)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 78},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_race/db_record_icon.png",
      name = "btn_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-23.5, 100)
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
      parent = "title_bg",
      res = "UI/alpha/1080P/summon/rule_btn.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(259, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 221, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_bg",
      res = "UI/alpha/1080P/dragonboat/stage_reward/bg_db_target.png",
      name = "left_time_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(185, -13)
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
      parent = "title_bg",
      name = "label_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(21.5, 29.5)
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
      parent = "current_speed_bg",
      name = "label_next_stage",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(73.75, -10)
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
      parent = "current_speed_bg",
      name = "label_current_speed",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(73.75, 13)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(103, 76, 42),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_zongzi_num",
      z = 0,
      parent = "btn_use_zongzi",
      text = T("\230\149\176\233\135\143:0"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102, 33.75)
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
      name = "label_rank",
      z = 0,
      parent = "btn_rank",
      text = T("\230\142\146\229\144\141"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 6)
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
      name = "label_reward",
      z = 0,
      parent = "btn_reward",
      text = T("\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 6)
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
      name = "label_boat",
      z = 0,
      parent = "btn_boat",
      text = T("\233\190\153\232\136\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 6)
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
      name = "label_pass",
      z = 0,
      parent = "btn_pass",
      text = T("\233\128\154\232\161\140\232\175\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 6)
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
      name = "label_record",
      z = 0,
      parent = "btn_record",
      text = T("\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 6)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 153.5, h = 41.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_use_zongzi",
      res = "UI/alpha/1080P/dragonboat/db_race/db_clicktoeat.png",
      name = "can_eat_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102, -12.25)
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
      parent = "btn_use_zongzi",
      name = "reqi_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(107.5, 87.75)
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
      name = "rule_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.75, 16.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 255, 224),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time",
      z = 0,
      parent = "left_time_bg",
      text = T("\229\137\169\228\189\153 12\229\164\1696\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(72.5, 17.5)
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
      parent = "left_time_bg",
      res = "UI/alpha/1080P/dragonboat/stage_reward/db_countdown.png",
      name = "img_left_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -45, h = 2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "can_eat_bg",
      res = "UI/alpha/1080P/dragonboat/db_race/db_clicktoeat_decoration.png",
      name = "can_eat_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.75, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45, h = 2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "can_eat_bg",
      res = "UI/alpha/1080P/dragonboat/db_race/db_clicktoeat_decoration.png",
      name = "can_eat_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131.75, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(149, 255, 55),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_can_eat",
      z = 0,
      parent = "can_eat_bg",
      text = T("\231\130\185\229\135\187\228\189\191\231\148\168"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76.75, 20.75)
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
      name = "image_reward_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 59)
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
      parent = "btn_pass",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_pass_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 59)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 121, h = 53},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_use_zongzi",
      res = "UI/alpha/1080P/dragonboat/db_race/db_get_zongzi.png",
      name = "get_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102, 140.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 200.5, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "current_speed_bg",
      res = "UI/alpha/1080P/dragonboat/db_race/db_feet.png",
      name = "ImageView_24382",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.25, -11)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 114),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_get",
      z = 0,
      parent = "get_bg",
      text = T("\229\142\187\232\142\183\229\143\150"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.5, 26.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.DragonBoatRewardScene = {
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 287.5, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/stage_reward/bg_db_distance.png",
      name = "left_distance_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 206.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 330, h = 135},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/stage_reward/bg_db_cloud.png",
      name = "next_stage_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(850, 433)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(800, 145)
    },
    t = "Layer",
    base = {
      name = "layer_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(90, 38.5)
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
      res = "UI/alpha/1080P/dragonboat/stage_reward/db_bg_stage_reward/db_sky.png",
      name = "bg_sky",
      z = 0
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
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "left_distance_bg",
      name = "label_left_distance",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(143.75, 19.5)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 266, h = 112.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "next_stage_bg",
      res = "UI/alpha/1080P/dragonboat/stage_reward/bg_speed_diaplay.png",
      name = "current_speed_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(225, 113.5)
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
      parent = "next_stage_bg",
      name = "label_current_speed",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(233, 102.5)
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
      parent = "next_stage_bg",
      name = "label_next_stage",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(233, 74)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 292, h = 292},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_sky",
      res = "UI/alpha/1080P/dragonboat/stage_reward/db_bg_stage_reward/db_sun.png",
      name = "bg_sun",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(588, 472)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 426.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_sky",
      res = "UI/alpha/1080P/dragonboat/stage_reward/db_bg_stage_reward/db_distanthill.png",
      name = "bg_far_mountain",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(583.5, 502)
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
      parent = "bg_sky",
      res = "UI/alpha/1080P/dragonboat/stage_reward/db_bg_stage_reward/db_floor.png",
      name = "bg_ground",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 360)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 434.5, h = 404.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_sky",
      res = "UI/alpha/1080P/dragonboat/stage_reward/db_bg_stage_reward/db_left_mountain1.png",
      name = "bg_left_mountain",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(217, 517)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 520.5, h = 366},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_sky",
      res = "UI/alpha/1080P/dragonboat/stage_reward/db_bg_stage_reward/db_right_mountain2.png",
      name = "bg_right_mountain2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(910, 536)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 412.5, h = 671.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_sky",
      res = "UI/alpha/1080P/dragonboat/stage_reward/db_bg_stage_reward/db_right_mountain1.png",
      name = "bg_right_mountain1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(964, 385)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 247.5, h = 105},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_sky",
      res = "UI/alpha/1080P/dragonboat/stage_reward/db_bg_stage_reward/db_right_stone2.png",
      name = "bg_right_rock2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(847, 340.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 244, h = 508},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_sky",
      res = "UI/alpha/1080P/dragonboat/stage_reward/db_bg_stage_reward/db_left_stone2.png",
      name = "bg_left_rock2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.5, 424)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 198, h = 237},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_sky",
      res = "UI/alpha/1080P/dragonboat/stage_reward/db_bg_stage_reward/db_left_stone1.png",
      name = "bg_left_rock1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(98.5, 318)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 251, h = 187.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_sky",
      res = "UI/alpha/1080P/dragonboat/stage_reward/db_bg_stage_reward/db_right_stone1.png",
      name = "bg_right_rock1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1044.5, 330.5)
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
      parent = "bg_sky",
      name = "panel_boat",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(585, 360)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(137, 63)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_dialog",
      z = 0,
      parent = "bg_sky",
      res = "UI/alpha/1080P/dragonboat/stage_reward/bg_db_dialog.png",
      capInsets = CCRectMake(15, 30, 50, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(423.5, 494)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 175)
    },
    t = "Layer",
    base = {
      parent = "bg_sky",
      name = "talk_touch",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(335, 318.5)
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
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.timeCorridorScene = {
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
      res = "UI/alpha/1080P/timecorridor/timecorridor_bg.jpg",
      name = "bg_img",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 348.5, h = 271},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_img",
      res = "UI/alpha/1080P/timecorridor/timecorridor_bg_moon.png",
      name = "bg_moon",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(932, 585)
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
    base = {name = "bg", z = 0},
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
      fix_wh = {w = 1170, h = 437},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_img",
      res = "UI/alpha/1080P/timecorridor/timecorridor_bg_cloud.png",
      name = "bg_cloud",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 366)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 84.5, h = 40},
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
      normal = "UI/alpha/1080P/summon/skip_btn.png",
      name = "btn_skip",
      z = 999,
      text = "",
      press = "UI/alpha/1080P/summon/skip_btn.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(873, 503)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 569, h = 403},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_img",
      res = "UI/alpha/1080P/timecorridor/2/timecorridor_skin_pic.png",
      name = "season_card_fig",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(286.5, 412.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 71, h = 69},
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
      normal = "UI/alpha/1080P/timecorridor/timecorridor_button_bg.png",
      name = "btn_record",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/timecorridor/timecorridor_button_bg.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-1.5, 74.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 352, h = 204.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_img",
      res = "UI/alpha/1080P/timecorridor/timecorridor_skin_name_pink.png",
      name = "legend_card_bg",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(339.5, 235.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 71, h = 69},
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
      normal = "UI/alpha/1080P/timecorridor/timecorridor_button_bg.png",
      name = "btn_reward_pool",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/timecorridor/timecorridor_button_bg.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-1.5, 165)
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
      parent = "bg_img",
      name = "legend_card_pos",
      z = 6
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(548.5, 399.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 246.5, h = 64},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_button.png",
      name = "btn_one",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(304.5, 74)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.5, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_record",
      res = "UI/alpha/1080P/summon/record/summon_record_icon.png",
      name = "ImageView_2091",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 34.5)
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
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 6)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 281, h = 98.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_img",
      res = "UI/alpha/1080P/timecorridor/timecorridor_skin_name_prismatic.png",
      name = "prismatic_card_bg",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(902, 253)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 246.5, h = 64},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_button.png",
      name = "btn_ten",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(665.5, 74)
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
      parent = "bg_img",
      name = "prismatic_card_pos",
      z = 7
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(800.5, 385.5)
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
      parent = "bg",
      name = "panel_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(932.5, 9)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 222, 184),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_skip",
      z = 0,
      parent = "btn_skip",
      text = T("\232\183\179\232\191\135"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(49.75, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.5, h = 54.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reward_pool",
      res = "UI/alpha/1080P/timecorridor/timecorridor_pool.png",
      name = "ImageView_2091",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 38)
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
      name = "label_reward_pool",
      z = 0,
      parent = "btn_reward_pool",
      text = T("\229\165\150\230\177\160"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.5, 6)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156, h = 20.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_text_bg.png",
      name = "use_ticket_tip_one",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(304.5, 27)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 524},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_img",
      res = "UI/alpha/1080P/timecorridor/timecorridor_bg_lake.png",
      name = "bg_lake",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 262)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156, h = 20.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_text_bg.png",
      name = "use_ticket_tip_ten",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(657.5, 27)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 226),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "legend_color_label",
      z = 0,
      parent = "legend_card_bg",
      text = T("\231\165\158\232\175\157"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93, 107.75)
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
      parent = "btn_one",
      res = "UI/alpha/1080P/timecorridor/timecorridor_moon_1.png",
      name = "one_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(156.25, 29)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(0.5, 0.5)
    },
    t = "Layer",
    base = {
      parent = "btn_one",
      name = "label_discount_pos_one",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(211.25, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(470, 40)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "resource_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(582.5, 484.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 188.5, h = 27},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_text_bg_2.png",
      name = "free_times_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(301.5, 109.5)
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
      parent = "btn_ten",
      res = "UI/alpha/1080P/timecorridor/timecorridor_moon_1.png",
      name = "ten_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(160.25, 29)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(0.5, 0.5)
    },
    t = "Layer",
    base = {
      parent = "btn_ten",
      name = "label_discount_pos_ten",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(211.25, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(67.5, 56)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-83.5, 477)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167, h = 105},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_shop.png",
      name = "btn_shop",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(951.5, 442.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 226),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "prismatic_color_label",
      z = 0,
      parent = "prismatic_card_bg",
      text = T("\229\133\184\232\151\143"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 49.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 82, h = 99.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_reward",
      res = "UI/alpha/1080P/timecorridor/timecorridor_line_reward_1.png",
      name = "btn_reward_open",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 50.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(82.5, 131.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "layer_reward",
      z = 0,
      parent = "panel_reward",
      res = "UI/alpha/1080P/timecorridor/timecorridor_line_reward_2.png",
      capInsets = CCRectMake(10, 50, 0.5, 257)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(41, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(0.5, 0.5)
    },
    t = "Layer",
    base = {
      parent = "panel_reward",
      name = "label_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(39.5, 17)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(68, 276)
    },
    t = "Layer",
    base = {
      parent = "panel_reward",
      name = "reward_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5.5, 84)
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
      parent = "panel_reward",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "red_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.5, 69.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "use_ticket_tip_one",
      res = "UI/alpha/1080P/timecorridor/1/timecorridor_discount_ticket_2.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 228, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_use",
      z = 0,
      parent = "use_ticket_tip_one",
      text = T("\228\189\191\231\148\168"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(47, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 228, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_use_cnt_one",
      z = 0,
      parent = "use_ticket_tip_one",
      text = "1/5",
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(103, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "use_ticket_tip_ten",
      res = "UI/alpha/1080P/timecorridor/1/timecorridor_discount_ticket_2.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 228, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_use",
      z = 0,
      parent = "use_ticket_tip_ten",
      text = T("\228\189\191\231\148\168"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(47, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 228, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_use_cnt_ten",
      z = 0,
      parent = "use_ticket_tip_ten",
      text = "1/5",
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(103, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(99, 29)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_403",
      z = 0,
      parent = "resource_bar",
      res = "UI/alpha/1080P/main/main_status_number_bg.png",
      capInsets = CCRectMake(5, 5, 2.5, 7.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119, 20)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 29)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_403_Copy0",
      z = 0,
      parent = "resource_bar",
      res = "UI/alpha/1080P/main/main_status_number_bg.png",
      capInsets = CCRectMake(5, 5, 2.5, 7.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(235.5, 20)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(140, 29)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_403_Copy1",
      z = 0,
      parent = "resource_bar",
      res = "UI/alpha/1080P/main/main_status_number_bg.png",
      capInsets = CCRectMake(5, 5, 2.5, 7.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(368.5, 20)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 25)
    },
    t = "Layer",
    base = {
      parent = "layer_reward",
      name = "btn_reward_close",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5.25, 100.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(82, 80)
    },
    t = "Layer",
    base = {
      parent = "layer_reward",
      name = "btn_reward_close2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.25, 3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 331.5, h = 169},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_title",
      res = "UI/alpha/1080P/timecorridor/2/timecorridor_title_theme.png",
      name = "theme_img",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(234, -53)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 253, 211),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_free_times",
      z = 0,
      parent = "free_times_bg",
      text = T("\229\137\1413\230\172\161\229\141\149\230\172\161\232\191\189\229\175\187\229\133\141\232\180\1853/3"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.25, 15)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(68, 276)
    },
    t = "Layer",
    base = {
      parent = "reward_list",
      name = "reward_list_cut",
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
      fix_wh = {w = 143.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_title",
      res = "UI/alpha/1080P/timecorridor/timecorridor_time_bg.png",
      name = "btn_rule_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(315, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_title",
      res = "UI/alpha/1080P/timecorridor/timecorridor_button_back.png",
      name = "btn_back",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 27)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 343, h = 120},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_title",
      res = "UI/alpha/1080P/timecorridor/timecorridor_title.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(164, 15.5)
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
      parent = "btn_shop",
      name = "label_shop_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(104, 51.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reward_close",
      res = "UI/alpha/1080P/timecorridor/timecorridor_line_reward_3.png",
      name = "close_fig",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.6, h = 27.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_403",
      res = "UI/alpha/1080P/timecorridor/1/timecorridor_token_1.png",
      name = "token_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74.5, 16)
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
      name = "token_num",
      z = 0,
      parent = "ImageView_403",
      text = "999",
      size = 19
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(55.5, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.65, x = 0.65},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.45, h = 24.375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_403_Copy0",
      res = "UI/alpha/1080P/timecorridor/1/timecorridor_discount_ticket_2.png",
      name = "ticket_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79.5, 16)
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
      name = "ticket_num",
      z = 0,
      parent = "ImageView_403_Copy0",
      text = "999",
      size = 19
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(56, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.6, h = 27.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_403_Copy1",
      res = "UI/alpha/1080P/timecorridor/timecorridor_moon_1.png",
      name = "moon_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124, 15)
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
      parent = "ImageView_403_Copy1",
      res = "UI/alpha/1080P/main/main_status_plus_icon_1.png",
      name = "moon_add",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 15.5)
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
      name = "moon_num",
      z = 0,
      parent = "ImageView_403_Copy1",
      text = "999",
      size = 19
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(105, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rule_bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_button_rule.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(2.75, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 254),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "left_time_label",
      z = 0,
      parent = "btn_rule_bg",
      text = T("\229\137\169\228\189\15312\229\164\1694\230\151\182"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(22.75, 14.25)
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
      parent = "bg_img",
      name = "bg_water_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(585, 152.5)
    }
  }
}

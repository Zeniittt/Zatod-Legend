ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueBookWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 991.5, h = 493.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/main/main_book_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(524, 264.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(101.5, 312.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_btn_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(21.75, 140.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 294, h = 238.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/main/main_book_choose_map2.png",
      name = "image_map",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(307.25, 341.75)
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
      name = "image_title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56, 509)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(260, 51.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(175.25, 233.75)
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
      name = "label_reward_score_tips",
      z = 0,
      parent = "image_bg",
      text = T("\233\128\154\229\133\179\229\143\175\232\142\183\229\190\151\231\167\175\229\136\1341000"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(660.25, 382.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.2, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-47, 507.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97.5, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/main/main_book_short.png",
      name = "image_first_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(505.75, 353.75)
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
      position = ccp(191.75, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(296, 70)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_first_reward_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(505.75, 270.25)
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(74, 56, 30),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_recommend",
      z = 0,
      parent = "image_bg",
      text = T("\230\142\168\232\141\144\229\185\179\229\157\135\230\136\152\229\138\15580000"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(660.25, 152.75)
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
      parent = "btn_back",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "ImageView_48964",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 196),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_fitst_title",
      z = 0,
      parent = "image_first_title_bg",
      text = T("\233\166\150\233\128\154\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(6, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 153.599990784, h = 45.199997288},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_big_common.png",
      name = "btn_challenge",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(663.25, 117.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 123.3, h = 54},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/main/main_tech_icon.png",
      name = "btn_tech",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.25, 64.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 291.5, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/main/main_book_title.png",
      name = "image_chapter_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(656.75, 413.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 293.5, h = 125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/main/main_book_info.png",
      name = "image_boss_detail_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(302.25, 161.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(74, 56, 30),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time_tips",
      z = 0,
      parent = "image_bg",
      text = T("\229\137\169\228\189\153\230\151\182\233\151\180"),
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(661.25, 152.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(183, 52, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time",
      z = 0,
      parent = "image_bg",
      text = "00:00:00",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(663.75, 152.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 238, 166),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_challenge",
      z = 0,
      parent = "btn_challenge",
      text = T("\230\140\145\230\136\152"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tech",
      z = 0,
      parent = "btn_tech",
      text = T("\230\132\159\230\130\159\231\172\148\232\174\176"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.5, 30)
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
      parent = "btn_tech",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_tech_red",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(128.5, 45)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 222, 108),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_chapter_name",
      z = 0,
      parent = "image_chapter_name_bg",
      text = T("\229\185\189\230\154\151\232\175\133\229\146\146\228\185\139\229\156\176"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.75, 25.5)
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
      name = "label_diff",
      z = 0,
      parent = "image_chapter_name_bg",
      text = T("\233\154\190\229\186\166"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(214.75, 25.5)
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
      parent = "image_chapter_name_bg",
      res = "UI/alpha/1080P/rogue/main/main_title_line.png",
      name = "image_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184.25, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(90, 90)
    },
    t = "Layer",
    base = {
      parent = "image_boss_detail_bg",
      name = "panel_boss_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(16.25, 21.5)
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
      name = "label_boss_name",
      z = 0,
      parent = "image_boss_detail_bg",
      text = T("BOSS\229\144\141\229\173\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183.25, 81)
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
      z = 0,
      parent = "image_boss_detail_bg",
      text = T("BOSS\228\187\139\231\187\141"),
      size = 13
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(110.25, 64)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 14},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_detail_bg",
      res = "UI/alpha/1080P/rogue/main/main_book_boss_detail.png",
      name = "btn_boss_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(248.25, 80.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61.5, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_boss_detail_bg",
      res = "UI/alpha/1080P/campaign/campaign_detail_boss.png",
      name = "image_boss_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(89.25, 97.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 123.3, h = 54},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/main/main_record_icon.png",
      name = "btn_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56.75, 117.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 303, h = 97.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/main/main_crisis_heat_bg.png",
      name = "image_crisis_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(656.75, 215.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 123.3, h = 51.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/main/main_charm_icon.png",
      name = "btn_charm_bag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.25, 172.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_record",
      z = 0,
      parent = "btn_record",
      text = T("\232\182\133\231\186\167\232\174\176\229\189\149"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 222, 108),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_crisis_title",
      z = 0,
      parent = "image_crisis_bg",
      text = T("\229\141\177\230\156\186\230\151\182\229\136\187"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145, 71.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.199998728, h = 21.199998728},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_crisis_bg",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_crisis_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(203, 71.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_crisis_bg",
      res = "UI/alpha/1080P/rogue/main/main_crisis_heat_icon.png",
      name = "ImageView_3874",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(141, 34.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 92, 92),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_crisis_amount",
      z = 0,
      parent = "image_crisis_bg",
      text = "9",
      size = 35
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(163, 34.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_crisis_bg",
      res = "UI/alpha/1080P/rogue/main/main_book_heat_light.png",
      name = "btn_crisis_minus",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 32.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_crisis_bg",
      res = "UI/alpha/1080P/rogue/main/main_book_heat_light.png",
      name = "btn_crisis_add",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(271.5, 32.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 227, 117),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_charm_bag",
      z = 0,
      parent = "btn_charm_bag",
      text = T("\230\138\164\231\172\166\231\154\174\232\162\139"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.5, 24.75)
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
      parent = "btn_crisis_rule",
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
      fix_wh = {w = 24, h = 7},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_crisis_minus",
      res = "UI/alpha/1080P/rogue/main/main_minus_1.png",
      name = "img_crisis_minus",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_crisis_add",
      res = "UI/alpha/1080P/rogue/main/main_plus_1.png",
      name = "img_crisis_add",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 19.5)
    }
  }
}

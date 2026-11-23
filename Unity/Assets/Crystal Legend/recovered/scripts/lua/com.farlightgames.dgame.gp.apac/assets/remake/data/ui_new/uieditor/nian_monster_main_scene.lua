ed.uieditor = ed.uieditor or {}
ed.uieditor.nian_monster_main_scene = {
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
      res = "UI/alpha/1080P/nianmonster/nian_main_boss_bg.jpg",
      name = "image_bg",
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
      fix_wh = {w = 501, h = 64},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_main_boss_title.png",
      name = "image_title_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(561.5, 598)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 203),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_title_bg",
      text = T("\229\185\180\229\133\189\229\164\167\228\189\156\230\136\152"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(260, 33.5)
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
      position = ccp(348.5, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 200)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "layer_hero",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(175, 202.5)
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
      name = "ImageView_11152",
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
      fix_wh = {w = 308, h = 53},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_main_boss_name.png",
      name = "hero_name_bg",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(270, 149)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 300, h = 107},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_main_boss_history.png",
      name = "history_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(588, 129.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 219, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_option_title",
      z = 2,
      parent = "image_bg",
      text = T("\229\172\137\230\136\143\230\157\161\228\187\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(805, 534)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 236, 160),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_hero_name",
      z = 0,
      parent = "hero_name_bg",
      text = T("\229\164\167\229\185\180\229\133\189"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154, 26.5)
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
      parent = "hero_name_bg",
      res = "UI/alpha/1080P/hero/hero_info_detail_bg.png",
      name = "btn_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(276.5, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(475.5, 318.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "layer_item",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(566.5, 177)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_challenge",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(955.5, 145.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_total_heat",
      z = 0,
      parent = "history_bg",
      text = "123",
      size = 36
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(129.5, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56, h = 63.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "history_bg",
      res = "UI/alpha/1080P/nianmonster/nian_main_boss_heat.png",
      name = "image_total_hot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(202, 61)
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
      name = "label_history_heat",
      z = 0,
      parent = "history_bg",
      text = T("\229\142\134\229\143\178\230\156\128\233\171\152123"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(130.5, 75.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_detail",
      res = "UI/alpha/1080P/hero/hero_info_detail.png",
      name = "ImageView_11157",
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
      flip = "",
      opacity = 0,
      fix_wh = {w = 56, h = 63.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "history_bg",
      res = "UI/alpha/1080P/nianmonster/nian_main_boss_heat.png",
      name = "image_total_hot_highlight",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(202, 61)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(152, 56.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_clear",
      z = 2,
      parent = "image_bg",
      res = "UI/alpha/1080P/common/buttion_big.png",
      capInsets = CCRectMake(64, 19, 64, 19)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(768.5, 145.5)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_main_boss_bg1.png",
      name = "image_bg1",
      z = 1
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
      fix_wh = {w = 250.5, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/nianmonster/nian_time_bg.png",
      name = "image_time_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(270, 189.5)
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
      parent = "btn_challenge",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "image_challenge",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 240, 158),
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
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.5, 30.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175.5, 40.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_trace_tips",
      z = 2,
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_task_focus_bg.png",
      capInsets = CCRectMake(58.5, 13.5, 58.5, 13.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(994, 532)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 240, 158),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_clear",
      z = 0,
      parent = "btn_clear",
      text = T("\230\184\133\231\169\186\230\157\161\228\187\182"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76, 30.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_time_bg",
      res = "UI/alpha/1080P/nianmonster/nian_time_clock.png",
      name = "ImageView_23297",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.25, 14.75)
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
      name = "label_left_time",
      z = 0,
      parent = "image_time_bg",
      text = T("\229\137\169\228\189\153 12\229\164\1696\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(81.25, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(79, 55, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_trace_tips",
      z = 0,
      parent = "image_trace_tips",
      text = T("\230\173\163\229\156\168\232\191\189\232\184\170\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(94.75, 20.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(158, 21, 11),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_trace_task_name",
      z = 0,
      parent = "image_trace_tips",
      text = T("\228\187\187\229\138\161\229\144\141\231\167\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(96.75, 20.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_trace_tips",
      res = "UI/alpha/1080P/hades/hades_task_focus_arrow.png",
      name = "image_trace_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.75, -3.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 70.5, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/campaign/campaign_map_bg_1.png",
      name = "btn_firework_shop",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86, 415.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 70.5, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/campaign/campaign_map_bg_1.png",
      name = "btn_heat_rank",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86, 238.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 70.5, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/campaign/campaign_map_bg_1.png",
      name = "btn_heat_reward",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86, 327)
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
      parent = "btn_firework_shop",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_new_goods_reddot",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.75, 61.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61, h = 69},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_firework_shop",
      res = "UI/alpha/1080P/nianmonster/nian_shop_icon.png",
      name = "firework_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 98, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_firework_shop",
      res = "UI/alpha/1080P/campaign/campaign_map_bg.png",
      name = "firework_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 12)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 65, h = 51},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_heat_rank",
      res = "UI/alpha/1080P/nianmonster/nian_rank_icon.png",
      name = "heat_rank_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 98, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_heat_rank",
      res = "UI/alpha/1080P/campaign/campaign_map_bg.png",
      name = "heat_rank_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 12)
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
      parent = "btn_heat_reward",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_reward_reddot",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.75, 61.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 51},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_heat_reward",
      res = "UI/alpha/1080P/nianmonster/nian_task_icon.png",
      name = "heat_reward_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 98, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_heat_reward",
      res = "UI/alpha/1080P/campaign/campaign_map_bg.png",
      name = "heat_reward_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.25, 12)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_firework",
      z = 0,
      parent = "firework_name_bg",
      text = T("\231\136\134\231\171\185\233\147\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_heat_rank",
      z = 0,
      parent = "heat_rank_name_bg",
      text = T("\231\131\173\229\138\155\230\142\146\232\161\140"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_heat_reward",
      z = 0,
      parent = "heat_reward_name_bg",
      text = T("\232\138\130\229\186\134\228\187\187\229\138\161"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 10.75)
    }
  }
}

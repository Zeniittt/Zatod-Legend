ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeDungeonBossStageDetail = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 775.5, h = 461.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/boss/boss_frame_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(460.5, 252)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/boss/boss_esc.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(762.75, 436.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 400)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_difficulty",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7.25, 30.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 245.5, h = 47.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/boss/boss_name_bg.png",
      name = "boss_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(261.25, 70.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(75, 75)
    },
    t = "Layer",
    base = {
      parent = "panel_difficulty",
      name = "btn_difficulty_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1.5, 122.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(65, 65)
    },
    t = "Layer",
    base = {
      parent = "panel_difficulty",
      name = "btn_difficulty_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(10.5, 324.5)
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
      name = "panel_boss",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(250.75, 146.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(65, 65)
    },
    t = "Layer",
    base = {
      parent = "panel_difficulty",
      name = "btn_difficulty_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(34, 235.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 115, h = 115},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_difficulty_3",
      res = "UI/alpha/1080P/dungeon/boss/boss_light_unchoose_rank_3.png",
      name = "image_unselect_3",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 115, h = 115},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_difficulty_3",
      res = "UI/alpha/1080P/dungeon/boss/boss_light_choose_rank_3.png",
      name = "image_select_3",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(75, 75)
    },
    t = "Layer",
    base = {
      parent = "panel_difficulty",
      name = "btn_difficulty_4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 261, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/boss/boss_title_rank_3.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(582.75, 400.25)
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
      name = "label_boss_name",
      z = 0,
      parent = "boss_name_bg",
      text = T("\231\165\158\231\129\181\230\173\166\229\163\171"),
      size = 23
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(128.75, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 115, h = 115},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_difficulty_1",
      res = "UI/alpha/1080P/dungeon/boss/boss_light_unchoose_rank_1.png",
      name = "image_unselect_1",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(139, 80, 161),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_difficulty_3",
      z = 0,
      parent = "image_unselect_3",
      text = T("\230\162\166\233\173\135"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 57.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 115, h = 115},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_difficulty_1",
      res = "UI/alpha/1080P/dungeon/boss/boss_light_choose_rank_1.png",
      name = "image_select_1",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "boss_name_bg",
      res = "UI/alpha/1080P/dungeon/boss/boss_level_bg.png",
      name = "boss_level_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174.75, 23.75)
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
      name = "label_select_3",
      z = 0,
      parent = "image_select_3",
      text = T("\230\162\166\233\173\135"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 57.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 228.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/boss/boss_history_bg.png",
      name = "boss_history_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(545.25, 343.25)
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
      parent = "boss_name_bg",
      res = "UI/alpha/1080P/hero/hero_info_detail_bg.png",
      name = "btn_boss_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(241.25, 23.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 115, h = 115},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_difficulty_2",
      res = "UI/alpha/1080P/dungeon/boss/boss_light_unchoose_rank_2.png",
      name = "image_unselect_2",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 115, h = 115},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_difficulty_2",
      res = "UI/alpha/1080P/dungeon/boss/boss_light_choose_rank_2.png",
      name = "image_select_2",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(102, 131, 85),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_difficulty_1",
      z = 0,
      parent = "image_unselect_1",
      text = T("\230\153\174\233\128\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 57.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 261.5, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/boss/boss_next_bg.png",
      name = "next_reward_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(557.25, 302.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 115, h = 115},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_difficulty_4",
      res = "UI/alpha/1080P/dungeon/boss/boss_light_unchoose_rank_4.png",
      name = "image_unselect_4",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 37.5)
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
      name = "label_select_1",
      z = 0,
      parent = "image_select_1",
      text = T("\230\153\174\233\128\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 57.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 115, h = 115},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_difficulty_4",
      res = "UI/alpha/1080P/dungeon/boss/boss_light_choose_rank_4.png",
      name = "image_select_4",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(240, 60)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_next_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(443.75, 228.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_boss_level",
      z = 0,
      parent = "boss_level_bg",
      text = "Lv.90",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 11.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(70, 123, 188),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_difficulty_2",
      z = 0,
      parent = "image_unselect_2",
      text = T("\229\155\176\233\154\190"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 57.5)
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
      name = "label_select_2",
      z = 0,
      parent = "image_select_2",
      text = T("\229\155\176\233\154\190"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 57.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 261.5, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/boss/boss_next_bg.png",
      name = "single_reward_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(557.75, 212.75)
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
      name = "label_title",
      z = 0,
      parent = "title_bg",
      text = T("\231\165\158\231\129\181\230\173\166\229\163\171 \230\162\166\233\173\135"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(130.5, 17)
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
      parent = "btn_boss_detail",
      res = "UI/alpha/1080P/hero/hero_info_detail.png",
      name = "ImageView_184",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(147, 46, 46),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_difficulty_4",
      z = 0,
      parent = "image_unselect_4",
      text = T("\233\133\183\229\136\145"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 57.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(240, 60)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_single_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(443.75, 138.75)
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
      name = "label_select_4",
      z = 0,
      parent = "image_select_4",
      text = T("\233\133\183\229\136\145"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 57.5)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_challenge",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(582.25, 72.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 164),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "boss_history_text",
      z = 0,
      parent = "boss_history_bg",
      text = T("\229\142\134\229\143\178\230\156\128\233\171\152\230\140\145\230\136\152\232\191\155\229\186\166\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16.75, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(87, 236, 80),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_boss_history",
      z = 0,
      parent = "boss_history_bg",
      text = "75%",
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(164.25, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(224, 214, 130),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cost",
      z = 0,
      parent = "bg",
      text = "12",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(519.75, 117.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activityadventure/acttoken/adventure_token_icon_1.png",
      name = "image_cost_token",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(546.25, 118.25)
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
      name = "newx_reward_text",
      z = 0,
      parent = "next_reward_bg",
      text = T("\228\184\139\228\184\128\230\140\145\230\136\152\232\191\155\229\186\166\229\165\150\229\138\177\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(21.75, 14)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(235, 152, 48),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_next_reward",
      z = 0,
      parent = "next_reward_bg",
      text = T("\229\183\178\229\133\168\233\131\168\229\174\140\230\136\144"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(169.25, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 228.5, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/boss/boss_warning_bg.png",
      name = "image_warning_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(258.75, 371.75)
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
      parent = "next_reward_bg",
      res = "UI/alpha/1080P/hero/hero_info_detail_bg.png",
      name = "btn_reward_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(266.25, 14)
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
      name = "single_reward_text",
      z = 0,
      parent = "single_reward_bg",
      text = T("\229\141\149\230\172\161\230\140\145\230\136\152\229\165\150\229\138\177\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(21.75, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.78, x = 0.78},
      flip = "",
      opacity = 255,
      fix_wh = {w = 226.98, h = 35.88},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/dungeon_firstblood_frame.png",
      name = "image_first_blood",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(257.25, 405.25)
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
      position = ccp(65.5, 29.25)
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
      parent = "btn_reward_detail",
      res = "UI/alpha/1080P/hero/hero_info_detail.png",
      name = "ImageView_184",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 236, 155),
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
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118, 30.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107.6, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/stageinfo/buff_icon_bg.png",
      name = "image_buff_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(626.75, 118.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(136, 126, 108),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "none_first_blood",
      z = 0,
      parent = "bg",
      text = T("\230\154\130\230\151\160\233\166\150\233\128\154\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(257.25, 405.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 81, 101),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_warning_tips",
      z = 0,
      parent = "image_warning_bg",
      text = T("\229\189\147\229\137\141\233\154\190\229\186\166\232\190\131\233\171\152\239\188\140\232\175\183\230\133\142\233\135\141\230\140\145\230\136\152"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(37.75, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19, h = 17},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_warning_bg",
      res = "UI/alpha/1080P/dungeon/boss/boss_warning.png",
      name = "ImageView_2124",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.25, 13.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 191, 18),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_23491",
      z = 0,
      parent = "image_first_blood",
      text = T("\233\166\150\233\128\154\232\128\133\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(40, 40)
    },
    t = "Layer",
    base = {
      parent = "image_first_blood",
      name = "panel_head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(78.5, 3)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(125, 22)
    },
    t = "Layer",
    base = {
      parent = "image_first_blood",
      name = "panel_name",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(119.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 191, 18),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guild",
      z = 0,
      parent = "image_first_blood",
      text = T("\229\133\172\228\188\154\229\144\141\229\133\173\228\184\170\229\173\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(120, 13.5)
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
      parent = "image_first_blood",
      res = "UI/alpha/1080P/dungeon/dungeon_firstblood_detail.png",
      name = "btn_first_blood_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(267, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(243, 192, 92),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buff",
      z = 0,
      parent = "image_buff_bg",
      text = T("200%\229\188\186\229\140\150"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(36.75, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_buff_bg",
      res = "UI/alpha/1080P/dungeon/stageinfo/buff_icon.png",
      name = "ImageView_848",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9.75, 11.5)
    }
  }
}

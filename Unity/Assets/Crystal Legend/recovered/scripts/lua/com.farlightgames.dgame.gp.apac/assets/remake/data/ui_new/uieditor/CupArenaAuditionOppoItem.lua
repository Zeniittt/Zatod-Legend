ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaAuditionOppoItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 227.5, h = 396},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_enemy_bg.png",
      name = "img_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(91, 80, 98),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score",
      z = 0,
      parent = "img_bg",
      text = T("\231\167\175\229\136\134\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(32.5, 177)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 112),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_score_value",
      z = 0,
      parent = "img_bg",
      text = "1234",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.5, 177)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(152, 44)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_battle",
      z = 0,
      parent = "img_bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(10, 10, 81.5, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113, 7.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg",
      res = "UI/alpha/1080P/cuparena/cuparena_camp_symbol_min_1.png",
      name = "img_camp_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.5, 109)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(91, 80, 98),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_stage_title",
      z = 0,
      parent = "img_bg",
      text = T("\230\174\181\228\189\141\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(32, 202.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 163.5, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_enemy_camp_bg.png",
      name = "bg_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 234)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 163.5, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_enemy_camp_bg.png",
      name = "bg_camp",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 65)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(91, 80, 98),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_power",
      z = 0,
      parent = "img_bg",
      text = T("\230\136\152\229\138\155\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(32.5, 151)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 112),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_power_value",
      z = 0,
      parent = "img_bg",
      text = "1234",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.5, 151)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110, h = 110},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "head",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 294)
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
      name = "label_player_name",
      z = 0,
      parent = "bg_name",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\228\184\131\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(80.75, 15.25)
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
      name = "label_camp",
      z = 0,
      parent = "bg_camp",
      text = T("\229\190\183\233\178\129\228\188\138\233\152\181\229\174\185"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85.25, 15.75)
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
      name = "label_battle",
      z = 0,
      parent = "btn_battle",
      text = T("\230\140\145\230\136\152"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.5, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.6, h = 26.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_battle",
      res = "UI/alpha/1080P/battle/battle_prepare_butt_fit_img.png",
      name = "ImageView_1944",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(54, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_bg",
      res = "UI/alpha/1080P/cuparena/cuparena_rank_medal_1_name.png",
      name = "img_grade_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.5, 203.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 148.75, h = 79.45},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg",
      res = "UI/alpha/1080P/toparena/toparena_promotion_battle_lose.png",
      name = "bg_result_lose",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 8.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 148.75, h = 105.35},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_bg",
      res = "UI/alpha/1080P/toparena/toparena_promotion_battle_win.png",
      name = "bg_result_win",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(218, 235, 243),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_lose",
      z = 0,
      parent = "bg_result_lose",
      text = T("\229\183\178\229\164\177\232\180\165"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.75, 52.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 208),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_result_win",
      z = 0,
      parent = "bg_result_win",
      text = T("\229\183\178\232\131\156\229\136\169"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.75, 58.75)
    }
  }
}

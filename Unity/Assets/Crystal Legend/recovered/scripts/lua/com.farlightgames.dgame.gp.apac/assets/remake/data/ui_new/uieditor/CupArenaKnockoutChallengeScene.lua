ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaKnockoutChallengeScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 642.5, h = 387},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_bg_2.png",
      name = "bg_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(293, 186)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1170, 100)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(0, 55, 0.5, 5),
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_bg_1.png",
      name = "bg_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, -21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 366, h = 529},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_attack_myinfo.png",
      name = "bg_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(179, 252.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(788, 652)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(26, 24, 26, 24),
      res = "UI/alpha/1080P/cuparena/knockout/knockout_myteam_bg.png",
      name = "bg_team",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(672, 629.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(540, 270)
    },
    t = "Layer",
    base = {
      parent = "bg_team",
      name = "panel_team",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(153.5, 138)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 556.5, h = 57.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_team",
      res = "UI/alpha/1080P/cuparena/knockout/knockout_shade.png",
      name = "ImageView_27978",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(423.5, 136.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 556.5, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_team",
      res = "UI/alpha/1080P/cuparena/knockout/knockout_info_bg.png",
      name = "bg_team_des",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(423.5, 111.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 197, h = 134.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_detail",
      res = "UI/alpha/1080P/cuparena/knockout/knockout_senemy_bg.png",
      name = "bg_oppo",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180.5, 177.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(221.5, 30.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_race_des",
      z = 0,
      parent = "bg_detail",
      res = "UI/alpha/1080P/cuparena/knockout/knockout_race_info_bg.png",
      capInsets = CCRectMake(10, 10, 10, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 389)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 186),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_oppo_des",
      z = 0,
      parent = "bg_oppo",
      text = T("\230\175\148\232\181\155\229\175\185\230\137\139"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(98.5, 122.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 228, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_race_des",
      z = 0,
      parent = "bg_race_des",
      text = T("\229\189\147\229\137\141\232\181\155\228\186\139"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.75, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(221.5, 30.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_race_info",
      z = 0,
      parent = "bg_detail",
      res = "UI/alpha/1080P/cuparena/knockout/knockout_race_info_bg.png",
      capInsets = CCRectMake(10, 10, 10, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 354.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(221.5, 30.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_time_des",
      z = 0,
      parent = "bg_detail",
      res = "UI/alpha/1080P/cuparena/knockout/knockout_race_info_bg.png",
      capInsets = CCRectMake(10, 10, 10, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 307.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(221.5, 30.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_time_info",
      z = 0,
      parent = "bg_detail",
      res = "UI/alpha/1080P/cuparena/knockout/knockout_race_info_bg.png",
      capInsets = CCRectMake(10, 10, 10, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 273)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 115.2, h = 33.9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_team",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_adjust",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(630, 431.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 153.6, h = 45.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_team",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_schedule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(424.5, 59)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 153.6, h = 45.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_team",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_gamble",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(632.5, 58.5)
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
      name = "label_oppo_name",
      z = 0,
      parent = "bg_oppo",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\135\160\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.82, x = 0.82},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90.2, h = 90.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppo",
      res = "UI/alpha/1080P/mainhead/main_head_blackbb.png",
      name = "img_oppo_head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(98, 62.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 177.5, h = 259.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_detail",
      res = "UI/alpha/1080P/cuparena/knockout/knockout_out_bg.png",
      name = "bg_lose_info",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184.5, 305.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(30, 100)
    },
    t = "Layer",
    base = {
      parent = "bg_detail",
      name = "Panel_26406",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-4, 305.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1170, 270)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_cloud",
      z = 0,
      parent = "bg_2",
      res = "UI/alpha/1080P/cuparena/cuparena_dec.png",
      capInsets = CCRectMake(0, 130, 1170, 40)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(587.5, -23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.4, h = 59.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_team",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_summary",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(724.5, 517.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_race_info",
      z = 0,
      parent = "bg_race_info",
      text = T("A\231\187\132128\232\191\15564"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(107.25, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 228, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time_des",
      z = 0,
      parent = "bg_time_des",
      text = T("\230\175\148\232\181\155\230\151\182\233\151\180"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.75, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time_info",
      z = 0,
      parent = "bg_time_info",
      text = T("A\231\187\132128\232\191\15564"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(107.25, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.6, x = 1.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.2, h = 37.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_adjust",
      res = "UI/alpha/1080P/pvp/lineup.png",
      name = "icon_adjust",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.5, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.6, x = 1.6},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 228, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_adjust",
      z = 0,
      parent = "btn_adjust",
      text = T("\232\176\131\230\149\180"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117, 30.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.25, x = 1.25},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 228, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_schedule",
      z = 0,
      parent = "btn_schedule",
      text = T("\229\183\133\229\179\176\232\181\155\231\168\139"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 30.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.25, x = 1.25},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 228, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_gamble",
      z = 0,
      parent = "btn_gamble",
      text = T("\231\171\158\231\140\156"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 30.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 14.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_gamble",
      res = "UI/alpha/1080P/cuparena/cuparena_reward_redpoint.png",
      name = "img_gamble_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(182, 48.25)
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
      name = "label_self_name",
      z = 0,
      parent = "bg_lose_info",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\135\160\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.75, 120.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 99, h = 99},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_lose_info",
      res = "UI/alpha/1080P/mainhead/main_head_blackbb.png",
      name = "img_self_head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.75, 181.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(221.5, 30.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_self_camp",
      z = 0,
      parent = "bg_lose_info",
      res = "UI/alpha/1080P/cuparena/knockout/knockout_race_info_bg.png",
      capInsets = CCRectMake(10, 10, 10, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.75, 86.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(221.5, 30.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_self_rank",
      z = 0,
      parent = "bg_lose_info",
      res = "UI/alpha/1080P/cuparena/knockout/knockout_race_info_bg.png",
      capInsets = CCRectMake(10, 10, 10, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.75, 48.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.111, x = 1.111},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.44, h = 44.44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_summary",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_result_icon.png",
      name = "icon_summary",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 34)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.111, x = 1.111},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 231, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_summary",
      z = 0,
      parent = "btn_summary",
      text = T("\230\136\145\231\154\132\232\181\155\230\158\156"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 7)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 228, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_self_camp",
      z = 0,
      parent = "bg_self_camp",
      text = T("\233\152\181\232\144\165\239\188\154%s"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(107.25, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(247, 228, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_self_rank",
      z = 0,
      parent = "bg_self_rank",
      text = T("\230\156\128\231\187\136\229\144\141\230\172\161\239\188\154%s"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(107.25, 15.25)
    }
  }
}

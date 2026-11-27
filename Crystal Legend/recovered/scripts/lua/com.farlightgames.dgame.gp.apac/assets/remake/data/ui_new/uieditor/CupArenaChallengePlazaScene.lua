ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaChallengePlazaScene = {
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
      position = ccp(695.5, 508)
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
      name = "bg_my_info",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172, 261)
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
      name = "panel_oppos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(337, 78.5)
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
      position = ccp(357.5, 13.75)
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
      text = T("\229\137\169\228\189\153\230\140\145\230\136\152\230\172\161\230\149\176\239\188\1545/5"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(152.5, 14.75)
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
      name = "btn_refresh_tip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(468, 16.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 163.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_attack_detail.png",
      name = "bg_my_score",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 193)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 163.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_attack_detail.png",
      name = "bg_my_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 165.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 163.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_attack_detail.png",
      name = "bg_my_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 248)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125, h = 125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_info",
      res = "UI/alpha/1080P/cuparena/cuparena_rank_medal_1.png",
      name = "img_my_grade",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 335.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_info",
      res = "UI/alpha/1080P/cuparena/cuparena_rank_medal_1_name.png",
      name = "img_my_grade_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 281.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 163.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_attack_detail.png",
      name = "bg_my_camp",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 220.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.5, h = 71.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_info",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_task_bg1.png",
      name = "ImageView_27967",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 118)
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
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86.75, 19)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_refresh_tip",
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
      name = "label_my_score",
      z = 0,
      parent = "bg_my_score",
      text = T("\231\167\175\229\136\134\239\188\1541"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.25, 12.75)
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
      name = "label_my_medal",
      z = 0,
      parent = "bg_my_medal",
      text = T("\229\139\139\231\171\160\239\188\1541"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.25, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_my_medal",
      res = "UI/alpha/1080P/toparena/toparena_star_icon_2.png",
      name = "img_my_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(130.25, 12.25)
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
      parent = "bg_my_rank",
      text = T("\230\142\146\229\144\141\239\188\1541"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.25, 12.75)
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
      name = "label_my_camp",
      z = 0,
      parent = "bg_my_camp",
      text = T("\233\152\181\232\144\165\239\188\1541"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.25, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 48},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_27967",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_camp_task_icon.png",
      name = "btn_task",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35.75, 35.75)
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
      name = "label_task",
      z = 0,
      parent = "btn_task",
      text = T("\228\187\187\229\138\161"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.75, 9)
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
      parent = "btn_task",
      res = "UI/alpha/1080P/cuparena/cuparena_reward_redpoint.png",
      name = "img_task_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.25, 39)
    }
  }
}

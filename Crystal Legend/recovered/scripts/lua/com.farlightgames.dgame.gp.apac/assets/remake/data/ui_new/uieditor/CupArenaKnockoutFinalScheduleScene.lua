ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaKnockoutFinalScheduleScene = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 617, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/knockout/course/course_bg_1_head.png",
      name = "bg_head",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(480, 543)
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
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_summary",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(921, 497.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 0, 40, 35.5),
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(191, 502.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(253.5, 56)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 10),
      res = "UI/alpha/1080P/cuparena/knockout/course/course_progress_bg.png",
      name = "bg_progress_des",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 443.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(800, 450)
    },
    t = "Layer",
    base = {
      name = "panel_schedule",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(80, 24.5)
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_schedule",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_group_button_2.png",
      name = "btn_group_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 398.5)
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
      parent = "panel_schedule",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_gamble",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 400)
    },
    t = "Layer",
    base = {name = "panel_left", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(39, 75.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_schedule",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_group_button_2.png",
      name = "btn_group_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 295)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_schedule",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_group_button_2.png",
      name = "btn_group_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 205)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 80, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_schedule",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_group_button_2.png",
      name = "btn_group_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 108.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 80, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_schedule",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_group_button_2.png",
      name = "btn_group_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(759, 398.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 80, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_schedule",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_group_button_2.png",
      name = "btn_group_6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(759, 295)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 80, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_schedule",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_group_button_2.png",
      name = "btn_group_7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(759, 205)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 80, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_schedule",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_group_button_2.png",
      name = "btn_group_8",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(759, 108.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_2002",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(75.5, 170)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_2001",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(75.5, 363.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_2001",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(75.5, 260)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_2002",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(75.5, 73.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_2006",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(564.5, 315)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_2005",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(163, 122.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_2007",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(484.5, 227.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_final",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(364.5, 227.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_2007",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(244, 227.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_2003",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(653.5, 363.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_2003",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(653.5, 260)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_2004",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(653.5, 73.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_2005",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(163, 315)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_2006",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(564.5, 122.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_2004",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(653.5, 170)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 236, 104),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "bg_progress_des",
      text = "24:45:02",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.75, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.6, h = 16.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_progress_des",
      res = "UI/alpha/1080P/rogue/instance/instance_time_icon.png",
      name = "icon_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88.75, 16.5)
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
      name = "label_gamble",
      z = 0,
      parent = "btn_gamble",
      text = T("\231\171\158\231\140\156"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_gamble",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_gamble_icon.png",
      name = "ImageView_14126",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.5, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_group_1",
      z = 0,
      parent = "btn_group_1",
      text = T("A\231\187\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 17)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(225.5, 39)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_champion_des",
      z = 0,
      parent = "panel_schedule",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_champion_bg.png",
      capInsets = CCRectMake(10, 10, 10, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(399.5, 202.5)
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
      parent = "bg_title",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(258.5, 17.75)
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
      position = ccp(181, 46.25)
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
      parent = "panel_left",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_honor",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 364)
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
      parent = "panel_left",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 290.5)
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
      parent = "panel_left",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 217.5)
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
      parent = "panel_left",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 149)
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
      parent = "panel_left",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_grades",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 77.5)
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
      parent = "panel_left",
      res = "UI/alpha/1080P/crusade/btn_statics_tag.png",
      name = "btn_timeline",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 6)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_group_2",
      z = 0,
      parent = "btn_group_2",
      text = T("A\231\187\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 17)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_group_3",
      z = 0,
      parent = "btn_group_3",
      text = T("A\231\187\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 17)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_group_4",
      z = 0,
      parent = "btn_group_4",
      text = T("A\231\187\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 17)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_group_5",
      z = 0,
      parent = "btn_group_5",
      text = T("A\231\187\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 17)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_group_6",
      z = 0,
      parent = "btn_group_6",
      text = T("A\231\187\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 17)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_group_7",
      z = 0,
      parent = "btn_group_7",
      text = T("A\231\187\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 17)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_group_8",
      z = 0,
      parent = "btn_group_8",
      text = T("A\231\187\132"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 17)
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
      fix_scale = {y = 1.111, x = 1.111},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61.105, h = 50.5505},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_honor",
      res = "UI/alpha/1080P/cuparena/cuparena_honor_enter.png",
      name = "icon_honor",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.111, x = 1.111},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_honor",
      z = 0,
      parent = "btn_honor",
      text = T("\229\144\141\228\186\186\229\160\130"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.111, x = 1.111},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61.105, h = 54.439},
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
      position = ccp(33, 37)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.111, x = 1.111},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
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
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.111, x = 1.111},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.773, h = 41.107},
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
      scalexy = {y = 1.111, x = 1.111},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
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
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 6)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.111, x = 1.111},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.106, h = 41.6625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_record",
      res = "UI/alpha/1080P/pvp/record.png",
      name = "icon_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.111, x = 1.111},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
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
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.111, x = 1.111},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.329, h = 48.3285},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_grades",
      res = "UI/alpha/1080P/toparena/toparena_history_icon.png",
      name = "icon_grades",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 29)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.111, x = 1.111},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_grades",
      z = 0,
      parent = "btn_grades",
      text = T("\230\136\152\231\187\169"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33, 5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.111, x = 1.111},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.6615, h = 56.1055},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_timeline",
      res = "UI/alpha/1080P/cuparena/cuparena_schedule_enter.png",
      name = "icon_timeline",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 30.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1.111, x = 1.111},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_timeline",
      z = 0,
      parent = "btn_timeline",
      text = T("\230\151\182\233\151\180\232\161\168"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31, 5)
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
      parent = "btn_record",
      res = "UI/alpha/1080P/cuparena/cuparena_reward_redpoint.png",
      name = "img_record_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 51.5)
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
      parent = "btn_reward",
      res = "UI/alpha/1080P/cuparena/cuparena_reward_redpoint.png",
      name = "img_reward_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.5, 51.5)
    }
  }
}

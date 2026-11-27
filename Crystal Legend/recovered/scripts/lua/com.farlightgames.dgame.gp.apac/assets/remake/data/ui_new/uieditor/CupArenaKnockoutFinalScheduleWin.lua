ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaKnockoutFinalScheduleWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 960, h = 530},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/knockout/course/course_bg_2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482.5, 271.5)
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
      name = "bg_progress_des",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_progress_bg.png",
      capInsets = CCRectMake(10, 10, 10, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477.5, 191)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(800, 360)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_schedule",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(77, 73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55, h = 55},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/knockout/course/course_close_button.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(921.5, 485.5)
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
      position = ccp(40, 333)
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
      position = ccp(131.25, 15.5)
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
      position = ccp(84.75, 16.5)
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
      position = ccp(40, 229.5)
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
      position = ccp(40, 139.5)
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
      position = ccp(40, 43)
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
      position = ccp(759, 333)
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
      position = ccp(759, 229.5)
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
      position = ccp(759, 139.5)
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
      position = ccp(759, 43)
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
      position = ccp(75.5, 104.5)
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
      position = ccp(75.5, 298)
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
      position = ccp(75.5, 194.5)
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
      position = ccp(75.5, 8)
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
      position = ccp(564.5, 249.5)
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
      position = ccp(163, 57)
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
      position = ccp(484.5, 162)
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
      position = ccp(364.5, 162)
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
      position = ccp(244, 162)
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
      position = ccp(653.5, 298)
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
      position = ccp(653.5, 194.5)
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
      position = ccp(653.5, 8)
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
      position = ccp(163, 249.5)
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
      position = ccp(564.5, 57)
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
      position = ccp(653.5, 104.5)
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
  }
}

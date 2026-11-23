ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaKnockoutGroupScheduleWin = {
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
      scaleSize = CCSizeMake(820, 392)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_schedule",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(69, 65)
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
      name = "bg_group_des",
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
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 38, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/chess_tag_open.png",
      name = "btn_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(7.5, 271.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/chess_tag_open.png",
      name = "btn_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(948, 271.5)
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1009",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(54, 268.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1001",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(99, 330)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1002",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(281, 330)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1002",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(190, 330)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1001",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(8, 330)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1009",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(235.5, 268.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1013",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(144.5, 217)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1014",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(613, 217)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1010",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(703.5, 268.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1010",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(522.5, 268.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1004",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(658.5, 330)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1004",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(749.5, 330)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1003",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(567.5, 330)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1003",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(476.5, 330)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1013",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(144.5, 123)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1011",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(235.5, 66)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1011",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(54, 66)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1006",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(190, 2.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1006",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(281, 2.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1005",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(99, 2.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1005",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(8, 2)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1007",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(476.5, 2.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1007",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(567.5, 2.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1008",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(749.5, 2.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1008",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(658.5, 2.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1012",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(522.5, 66)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1012",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(703.5, 66)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1014",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(613, 123)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_host_1015",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(267, 172)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_guest_1015",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(489, 172)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "panel_schedule",
      name = "panel_player_final",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(378, 172)
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
      parent = "bg_group_des",
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
      parent = "bg_group_des",
      text = "24:45:02",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131.25, 15.5)
    }
  }
}

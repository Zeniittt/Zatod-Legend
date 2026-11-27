ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueEventScene = {
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
      res = "UI/alpha/1080P/rogue/instance/instance_event_bg.jpg",
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
      fix_wh = {w = 299, h = 353},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_event_bg_dec3.png",
      name = "event_bg_3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(393, 152)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 344.5, h = 397},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_event_bg_dec2.png",
      name = "event_bg_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.33, 0),
      position = ccp(146.5, 179)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 360, h = 461.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_event_bg_dec1.png",
      name = "event_bg_1",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(298.5, 335.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 150.5, h = 129.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/event/chest_icon.png",
      name = "image_event_type",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(299.5, 335)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_pearl_bg",
      z = 1,
      parent = "image_bg",
      res = "UI/alpha/1080P/lottery/lottery_meat_bg.png",
      capInsets = CCRectMake(25, 12.5, 25, 12.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1049.5, 605.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_retry_bg",
      z = 1,
      parent = "image_bg",
      res = "UI/alpha/1080P/lottery/lottery_meat_bg.png",
      capInsets = CCRectMake(25, 12.5, 25, 12.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(938.5, 605.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90.5, h = 90.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_function_icon_bg.png",
      name = "btn_team",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61, 165)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 752.5, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_event_info_bg.png",
      name = "image_right_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(793.5, 360)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 202, 143),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_right_bg",
      text = T("\230\137\147\233\157\182"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(407.75, 555)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(471, 312)
    },
    t = "Layer",
    base = {
      parent = "image_right_bg",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(172.75, 210.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(471, 425)
    },
    t = "Layer",
    base = {
      parent = "image_right_bg",
      name = "panel_option",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(172.75, 98.5)
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
      parent = "image_pearl_bg",
      res = "UI/alpha/1080P/icon/pearl.png",
      name = "pearl_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 18.25)
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
      name = "pearl_amount",
      z = 0,
      parent = "image_pearl_bg",
      text = "88888",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 17.75)
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
      parent = "image_retry_bg",
      res = "UI/alpha/1080P/rogue/instance/rogue_retry.png",
      name = "retry_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 18.25)
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
      name = "retry_amount",
      z = 0,
      parent = "image_retry_bg",
      text = "88888",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_team",
      res = "UI/alpha/1080P/rogue/instance/instance_function_team.png",
      name = "icon_team",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.25, 45.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84.5, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_team",
      res = "UI/alpha/1080P/rogue/instance/instance_function_name.png",
      name = "team_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.25, 11.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 46, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_right_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_event_title.png",
      name = "image_title_dec_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(507.75, 555)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_right_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_event_title.png",
      name = "image_title_dec_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(308.25, 555)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(471, 1)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_line",
      z = 0,
      parent = "panel_desc",
      res = "UI/alpha/1080P/rogue/instance/instance_event_line.png",
      capInsets = CCRectMake(150, 0.5, 150, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(235, -11.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 479, h = 76.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_desc",
      res = "UI/alpha/1080P/rogue/instance/instance_event_choice_button.png",
      name = "btn_continue",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(235, -62)
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
      name = "label_team",
      z = 0,
      parent = "team_name_bg",
      text = T("\233\152\159\228\188\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.25, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 208),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_continue",
      z = 0,
      parent = "btn_continue",
      text = T("\231\187\167\231\187\173"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(239.5, 44.25)
    }
  }
}

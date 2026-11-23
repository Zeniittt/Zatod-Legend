ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_allstar_page = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "page_lay", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
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
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_pass/bg.jpg",
      name = "ImageView_27",
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
      fix_wh = {w = 360.5, h = 111.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_pass/title.png",
      name = "ImageView_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(517, 467.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 690, h = 285.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_pass/task_bg1.png",
      name = "ImageView_list",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(553, 209.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 694.5, h = 67},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/allstar/allstar_pass/task.png",
      name = "ImageView_task",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(551, 385.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 119)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_btns",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(894, 225.5)
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
      name = "Label_time",
      z = 0,
      parent = "ImageView_title",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(224.75, 8.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(563, 273)
    },
    t = "Layer",
    base = {
      parent = "ImageView_list",
      name = "Panel_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(120.5, 5.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 701.5, h = 308},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_list",
      res = "UI/alpha/1080P/allstar/allstar_pass/frame.png",
      name = "ImageView_3414",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(343.5, 144.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 115.5, h = 275.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_list",
      res = "UI/alpha/1080P/allstar/allstar_pass/pass_icon.png",
      name = "ImageView_3415",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63, 142.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 119.5, h = 54.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_list",
      res = "UI/alpha/1080P/allstar/allstar_pass/buy_button.png",
      name = "ImageView_pay",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 1.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(676, 272)
    },
    t = "Layer",
    base = {
      parent = "ImageView_list",
      name = "Panel_task_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7.5, 6.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66.5, h = 66.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_task",
      res = "UI/alpha/1080P/allstar/allstar_pass/pass_exp.png",
      name = "ImageView_3421",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(54.25, 33.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 575, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_task",
      res = "UI/alpha/1080P/allstar/allstar_pass/bg1.png",
      name = "ImageView_3424",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(379.25, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 136),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3426",
      z = 0,
      parent = "ImageView_task",
      text = T("\230\142\162\231\167\152\231\187\143\233\170\140:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(128.25, 43)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(100, 58, 31),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_exp",
      z = 0,
      parent = "ImageView_task",
      text = "50/200",
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(173.75, 43)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 180, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_task",
      res = "UI/alpha/1080P/allstar/allstar_pass/time_bg.png",
      name = "ImageView_3428",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(575.25, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 60},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_btns",
      res = "UI/alpha/1080P/allstar/allstar_pass/passbutton2.png",
      name = "button_selected_1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_btns",
      res = "UI/alpha/1080P/allstar/allstar_pass/passbutton1.png",
      name = "button_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85, h = 57},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_btns",
      res = "UI/alpha/1080P/allstar/allstar_pass/passbutton1.png",
      name = "button_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20, 86)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_btns",
      res = "UI/alpha/1080P/allstar/allstar_pass/passbutton2.png",
      name = "button_selected_2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 87.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(143, 93, 63),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3416",
      z = 0,
      parent = "ImageView_3415",
      text = T("\232\135\170\231\132\182\228\185\139\232\183\175"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 256.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(120, 89, 19),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3416_Copy0",
      z = 0,
      parent = "ImageView_3415",
      text = T("\232\190\137\231\133\140\228\185\139\232\183\175"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.25, 107.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 102),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_pay",
      z = 9,
      parent = "ImageView_pay",
      text = T("30\229\133\131\232\167\163\233\148\129"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.75, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 249, 194),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3423",
      z = 0,
      parent = "ImageView_3421",
      text = "56",
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.25, 33.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(574.5, 11)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_progress",
      z = 0,
      parent = "ImageView_3424",
      res = "UI/alpha/1080P/taskModel/day_task/day_task_progress_7.png",
      capInsets = CCRectMake(10, 0, 375, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(1, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_3428",
      res = "UI/alpha/1080P/allstar/allstar_pass/time.png",
      name = "ImageView_3431",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_time",
      z = 0,
      parent = "ImageView_3428",
      text = T("\229\137\169\228\189\153 "),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(51, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(233, 126, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_button_selected_1",
      z = 0,
      parent = "button_selected_1",
      text = T("\228\187\187\229\138\161"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 235, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_button_1",
      z = 0,
      parent = "button_1",
      text = T("\228\187\187\229\138\161"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44, 31)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 235, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_button_2",
      z = 0,
      parent = "button_2",
      text = T("\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44, 31)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(233, 126, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_button_selected_2",
      z = 0,
      parent = "button_selected_2",
      text = T("\229\165\150\229\138\177"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.5, 30)
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
      parent = "button_1",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "red_button_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71, 47.5)
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
      parent = "button_2",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "red_button_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(71, 48)
    }
  }
}

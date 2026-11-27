ed.uieditor = ed.uieditor or {}
ed.uieditor.ranklistpop = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 190.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rankingscene/title.png",
      name = "img_title_bg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(162.5, 507.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "pan_window", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 214, 17),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "lab_title",
      z = 0,
      parent = "img_title_bg",
      text = "",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.75, 66.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(765, 350.5)
    },
    t = "Layer",
    base = {
      parent = "pan_window",
      name = "pan_top_clip",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(57.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(764, 372)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_2685",
      z = 1,
      parent = "pan_top_clip",
      res = "UI/alpha/1080P/common/com_img_9bg2.png",
      capInsets = CCRectMake(20, 20, 10, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(382, 186)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(757, 368.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_2687",
      z = 1,
      parent = "pan_window",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_1.png",
      capInsets = CCRectMake(25, 25, 30, 330)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(439.5, 203.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 751.5, h = 120},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_window",
      res = "UI/alpha/1080P/rankingscene/top_three.png",
      name = "img_top",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(439.5, 378.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 175)
    },
    t = "Layer",
    base = {
      parent = "pan_window",
      name = "pan_top",
      z = 6
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(95, 588.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_title_bg",
      res = "UI/alpha/1080P/rankingscene/ranking_text.png",
      name = "ImageView_2735",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.25, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(744, 337)
    },
    t = "Layer",
    base = {
      parent = "pan_window",
      name = "pan_list_pos",
      z = 7
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(68, 25.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(140.5, 372.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_2722",
      z = 0,
      parent = "pan_window",
      res = "UI/alpha/1080P/rankingscene/black_bg.png",
      capInsets = CCRectMake(15, 25, 25, 7.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(881.5, 223.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(130, 360)
    },
    t = "Layer",
    base = {
      parent = "pan_window",
      name = "pan_butt_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(817.5, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29.5, h = 144.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_window",
      res = "UI/alpha/1080P/rankingscene/post.png",
      name = "ImageView_3106",
      z = 11
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 378)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 29.5, h = 144.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pan_window",
      res = "UI/alpha/1080P/rankingscene/post.png",
      name = "ImageView_3106_Copy0",
      z = 11
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(814, 378.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(228, 170)
    },
    t = "Layer",
    base = {
      parent = "pan_top",
      name = "Panel_hand_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-8.5, -296)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(228, 170)
    },
    t = "Layer",
    base = {
      parent = "pan_top",
      name = "Panel_hand_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(220.5, -296)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(228, 170)
    },
    t = "Layer",
    base = {
      parent = "pan_top",
      name = "Panel_hand_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(462.5, -296)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_2",
      z = 9,
      parent = "Panel_hand_2",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136.5, 87)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 190.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_hand_2",
      res = "UI/alpha/1080P/rankingscene/2nd_nameframe.png",
      name = "ImageView_2698",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136.5, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 122, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_hand_2",
      res = "UI/alpha/1080P/rankingscene/2nd_base.png",
      name = "img_dizuo_2",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136.5, 95.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "Panel_hand_2",
      name = "pan_icon_pos_2",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(137.5, 151.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 187.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_hand_1",
      res = "UI/alpha/1080P/rankingscene/1st_nameframe.png",
      name = "ImageView_2698",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.5, 50)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 129.5, h = 63.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_hand_1",
      res = "UI/alpha/1080P/rankingscene/1st_base.png",
      name = "img_dizuo_1",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.5, 110)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "Panel_hand_1",
      name = "pan_icon_pos_1",
      z = 5
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(124.5, 176.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_1",
      z = 9,
      parent = "Panel_hand_1",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.5, 97.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 186, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_hand_3",
      res = "UI/alpha/1080P/rankingscene/3rd_nameframe.png",
      name = "ImageView_2698",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100.5, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 113, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_hand_3",
      res = "UI/alpha/1080P/rankingscene/3rd_base.png",
      name = "img_dizuo_3",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100.5, 90.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "Panel_hand_3",
      name = "pan_icon_pos_3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(101.5, 148)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_3",
      z = 9,
      parent = "Panel_hand_3",
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100.5, 87)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 250, h = 101.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_hand_1",
      res = "UI/alpha/1080P/rankingscene/1st_wings.png",
      name = "ImageView_3108",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.5, 142)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 70},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_hand_2",
      res = "UI/alpha/1080P/rankingscene/2nd_back.png",
      name = "ImageView_3201",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136.5, 123)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 145.5, h = 91.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_hand_1",
      res = "UI/alpha/1080P/rankingscene/1st_back.png",
      name = "ImageView_3201_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.5, 137)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 87, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_hand_3",
      res = "UI/alpha/1080P/rankingscene/3rd_back.png",
      name = "ImageView_3203",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(100.5, 121.5)
    }
  }
}

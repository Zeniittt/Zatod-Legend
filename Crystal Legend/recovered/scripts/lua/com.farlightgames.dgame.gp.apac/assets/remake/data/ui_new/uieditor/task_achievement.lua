ed.uieditor = ed.uieditor or {}
ed.uieditor.task_achievement = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "layer_container",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(833, 96)
    },
    t = "Layer",
    base = {
      parent = "layer_container",
      name = "Panel_title",
      z = 10
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(56.5, 420)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 50)
    },
    t = "Layer",
    base = {
      parent = "layer_container",
      name = "panel_btns",
      z = 11
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(233.5, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 812.5, h = 62},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_container",
      res = "UI/alpha/1080P/task/achievement_list_up.png",
      name = "ImageView_332",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 72.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(750, 360)
    },
    t = "Layer",
    base = {
      parent = "layer_container",
      name = "ach_task_List_pos",
      z = 8
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(102.5, 88.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 82, h = 79},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_title",
      res = "UI/alpha/1080P/task/achievement_log_bj.png",
      name = "ImageView_155",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(156.5, 60)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(833, 96)
    },
    t = "Scale9Sprite",
    base = {
      name = "title_bj",
      z = 0,
      parent = "Panel_title",
      res = "UI/alpha/1080P/task/daily_task_title_bj.png",
      capInsets = CCRectMake(250, 0, 250, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(416.5, 48)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 10.5, h = 18.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_title",
      res = "UI/alpha/1080P/task/achievement_cjd.png",
      name = "ImageView_257",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(224.5, 43)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_achievement_point_num",
      z = 0,
      parent = "Panel_title",
      text = "0",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(244.5, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_title",
      res = "UI/alpha/1080P/task/achievement_gift_box.png",
      name = "gift_box_1",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(315.5, 72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_title",
      res = "UI/alpha/1080P/task/achievement_gift_box.png",
      name = "gift_box_2",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(366.5, 72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_title",
      res = "UI/alpha/1080P/task/achievement_gift_box.png",
      name = "gift_box_3",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(418.5, 72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_title",
      res = "UI/alpha/1080P/task/achievement_gift_box.png",
      name = "gift_box_4",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(470, 72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "Panel_title",
      res = "UI/alpha/1080P/task/achievement_gift_box.png",
      name = "gift_box_5",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(517.5, 72)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(261, 17.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "progress_bj",
      z = 0,
      parent = "Panel_title",
      res = "UI/alpha/1080P/task/achievement_progress_bj.png",
      capInsets = CCRectMake(20, 0, 10, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(393, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 202, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_title",
      res = "UI/alpha/1080P/task/achievement_rig_bj.png",
      name = "ImageView_288",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(643, 59)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.599996784, h = 9.9999994},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_btns",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "img_lin_l",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.5, 18)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 53.599996784, h = 9.9999994},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_btns",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "img_lin_r",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(431, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(68.5, 34.5)
    },
    t = "Layer",
    base = {
      parent = "panel_btns",
      name = "bon_n1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(95.5, 6)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(68.5, 34.5)
    },
    t = "Layer",
    base = {
      parent = "panel_btns",
      name = "bon_n2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(171.5, 6)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(68.5, 34.5)
    },
    t = "Layer",
    base = {
      parent = "panel_btns",
      name = "bon_n3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(247.5, 6)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(68.5, 34.5)
    },
    t = "Layer",
    base = {
      parent = "panel_btns",
      name = "bon_n4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(324, 6)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56, h = 75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_155",
      res = "UI/alpha/1080P/task/achievement_log.png",
      name = "ImageView_256",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 43)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.725, h = 16.45},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "gift_box_1",
      res = "UI/alpha/1080P/package/selected.png",
      name = "gift_box_1_j",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.5, 13.5)
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
      name = "gift_box_1_s",
      z = 2,
      parent = "gift_box_1",
      text = "100",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, -4)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "gift_box_1",
      res = "UI/alpha/1080P/task/achievement_progress_star.png",
      name = "gift_box_1_star",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, -16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.725, h = 16.45},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "gift_box_2",
      res = "UI/alpha/1080P/package/selected.png",
      name = "gift_box_2_j",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.5, 13.5)
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
      name = "gift_box_2_s",
      z = 2,
      parent = "gift_box_2",
      text = "100",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, -4)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "gift_box_2",
      res = "UI/alpha/1080P/task/achievement_progress_star.png",
      name = "gift_box_2_star",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, -16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.725, h = 16.45},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "gift_box_3",
      res = "UI/alpha/1080P/package/selected.png",
      name = "gift_box_3_j",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.5, 13.5)
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
      name = "gift_box_3_s",
      z = 2,
      parent = "gift_box_3",
      text = "100",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, -4)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "gift_box_3",
      res = "UI/alpha/1080P/task/achievement_progress_star.png",
      name = "gift_box_3_star",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, -16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.725, h = 16.45},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "gift_box_4",
      res = "UI/alpha/1080P/package/selected.png",
      name = "gift_box_4_j",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.5, 13.5)
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
      name = "gift_box_4_s",
      z = 2,
      parent = "gift_box_4",
      text = "100",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, -4)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "gift_box_4",
      res = "UI/alpha/1080P/task/achievement_progress_star.png",
      name = "gift_box_4_star",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.5, -16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.725, h = 16.45},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "gift_box_5",
      res = "UI/alpha/1080P/package/selected.png",
      name = "gift_box_5_j",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.5, 13.5)
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
      name = "gift_box_5_s",
      z = 2,
      parent = "gift_box_5",
      text = "100",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, -4)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 15.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "gift_box_5",
      res = "UI/alpha/1080P/task/achievement_progress_star.png",
      name = "gift_box_5_star",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.5, -16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15, h = 17},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "progress_bj",
      res = "UI/alpha/1080P/task/achievement_progress_star_bj.png",
      name = "ImageView_283",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(54.5, 8.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15, h = 17},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "progress_bj",
      res = "UI/alpha/1080P/task/achievement_progress_star_bj.png",
      name = "ImageView_283_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 8.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15, h = 17},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "progress_bj",
      res = "UI/alpha/1080P/task/achievement_progress_star_bj.png",
      name = "ImageView_283_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(156.5, 8.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15, h = 17},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "progress_bj",
      res = "UI/alpha/1080P/task/achievement_progress_star_bj.png",
      name = "ImageView_283_Copy2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(209.5, 8.75)
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
      name = "label_ach_tit_rig",
      z = 0,
      parent = "ImageView_288",
      text = T("\229\174\140\230\136\144\229\186\166\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76.5, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_completeness_num",
      z = 0,
      parent = "ImageView_288",
      text = "0",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140.5, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68.5, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bon_n1",
      res = "UI/alpha/1080P/task/achievement_page_btn.png",
      name = "img_1_cancel",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 69.5, h = 35},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bon_n1",
      res = "UI/alpha/1080P/task/achievement_page_btn_up.png",
      name = "img_1_press",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68.5, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bon_n2",
      res = "UI/alpha/1080P/task/achievement_page_btn.png",
      name = "img_2_cancel",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 69.5, h = 35},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bon_n2",
      res = "UI/alpha/1080P/task/achievement_page_btn_up.png",
      name = "img_2_press",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68.5, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bon_n3",
      res = "UI/alpha/1080P/task/achievement_page_btn.png",
      name = "img_3_cancel",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 256, h = 7.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_title",
      res = "UI/alpha/1080P/task/achievement_progress.png",
      name = "img_progress_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(391.5, 41)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 69.5, h = 35},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bon_n3",
      res = "UI/alpha/1080P/task/achievement_page_btn_up.png",
      name = "img_3_press",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68.5, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bon_n4",
      res = "UI/alpha/1080P/task/achievement_page_btn.png",
      name = "img_4_cancel",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 69.5, h = 35},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bon_n4",
      res = "UI/alpha/1080P/task/achievement_page_btn_up.png",
      name = "img_4_press",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 17)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 59, 56),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_297_Copy0",
      z = 0,
      parent = "img_1_cancel",
      text = T("\232\139\177\233\155\132"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.25, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(113, 68, 38),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "img_1_press_str",
      z = 0,
      parent = "img_1_press",
      text = T("\232\139\177\233\155\132"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.75, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 59, 56),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_297_Copy0",
      z = 0,
      parent = "img_2_cancel",
      text = T("\228\184\170\228\186\186"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.25, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(113, 68, 38),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "img_2_press_str",
      z = 0,
      parent = "img_2_press",
      text = T("\228\184\170\228\186\186"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.75, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 59, 56),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_297_Copy0",
      z = 0,
      parent = "img_3_cancel",
      text = T("\229\133\172\228\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.25, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(113, 68, 38),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "img_3_press_str",
      z = 0,
      parent = "img_3_press",
      text = T("\229\133\172\228\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.75, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 59, 56),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_297_Copy0",
      z = 0,
      parent = "img_4_cancel",
      text = T("\229\137\175\230\156\172"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.25, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(113, 68, 38),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "img_4_press_str",
      z = 0,
      parent = "img_4_press",
      text = T("\229\137\175\230\156\172"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.75, 19)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.task_dailyTask = {
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 762, h = 96},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_container",
      res = "UI/alpha/1080P/task/daily_task_title_bj.png",
      name = "title_bj",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(437.5, 468)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 162, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_container",
      res = "UI/alpha/1080P/task/daily_task_rig_bj.png",
      name = "ImageView_166",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(775.5, 461.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46, h = 43},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_container",
      res = "UI/alpha/1080P/task/daily_task_box.png",
      name = "img_act_point_box",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(839, 468.5)
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
      res = "UI/alpha/1080P/task/task_list_up_img.png",
      name = "ImageView_169",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 73)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(750, 385)
    },
    t = "Layer",
    base = {
      parent = "layer_container",
      name = "daily_task_List_pos",
      z = 8
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(102.5, 81)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 39, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_bj",
      res = "UI/alpha/1080P/task/daily_task_fa.png",
      name = "ImageView_155",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148, 86.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_bj",
      res = "UI/alpha/1080P/task/daily_task_fa.png",
      name = "ImageView_155_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(612.5, 86.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 206, h = 54.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_bj",
      res = "UI/alpha/1080P/task/daily_task_title_img.png",
      name = "ImageView_157",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(402.5, 69.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49.5, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_bj",
      res = "UI/alpha/1080P/task/daily_task_title_lv_bj.png",
      name = "image_btn_lv",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(207, 64)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(330, 9.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_progress_bj",
      z = 0,
      parent = "title_bj",
      res = "UI/alpha/1080P/task/task_title_progress_bj.png",
      capInsets = CCRectMake(10, 0, 10, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(410, 42.5)
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
      name = "txt_award_progress",
      z = 9,
      parent = "title_bj",
      text = "",
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(410.5, 43.5)
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
      parent = "title_bj",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_award_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(638, 62)
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
      name = "label_task_num",
      z = 0,
      parent = "ImageView_166",
      text = "",
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 229, 143),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_lv",
      z = 0,
      parent = "image_btn_lv",
      text = "0",
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.75, 25.5)
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
      name = "label_lvname",
      z = 0,
      parent = "image_btn_lv",
      text = T("\231\173\137\231\186\167"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.25, 5.5)
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
      parent = "btn_award_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_165",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 771.5, h = 41.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_container",
      res = "UI/alpha/1080P/task/task_list_down_img.png",
      name = "ImageView_819",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(475, 459)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 327.5, h = 7.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_bj",
      res = "UI/alpha/1080P/task/task_title_progress.png",
      name = "img_progress_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(246.5, 47)
    }
  }
}

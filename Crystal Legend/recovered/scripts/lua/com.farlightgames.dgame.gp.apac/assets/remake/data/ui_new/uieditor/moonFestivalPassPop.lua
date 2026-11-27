ed.uieditor = ed.uieditor or {}
ed.uieditor.moonFestivalPassPop = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 869.5, h = 532},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/bunnyrace/br_pass/br_pass_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482.5, 279.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 569.5, h = 85},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_pass/db_bg_progressbar.png",
      name = "progress_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(483.5, 403)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "layer_panel",
      z = 0
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
      fix_wh = {w = 789.5, h = 330.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/bunnyrace/br_pass/br_pass_box_top.png",
      name = "bg_frame",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(443.5, 248)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 74, h = 56.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/bunnyrace/br_pass/br_pass_unselected.png",
      name = "btn_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(837.5, 340.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 74, h = 56.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/bunnyrace/br_pass/br_pass_unselected.png",
      name = "btn_task",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(837.5, 274.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 96, h = 60},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/bunnyrace/br_pass/br_pass_select.png",
      name = "btn_reward_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(836.5, 342)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 96, h = 60},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/bunnyrace/br_pass/br_pass_select.png",
      name = "btn_task_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(836.5, 276.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134.5, h = 63},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/bunnyrace/br_pass/br_pass_unlock.png",
      name = "btn_pass_unlock",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175, 109.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 66, h = 71},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_pass/br_pass_close.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(777.25, 435.5)
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
      name = "label_level_num",
      z = 0,
      parent = "progress_bg",
      text = "56",
      size = 36
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.25, 41)
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
      parent = "progress_bg",
      res = "UI/alpha/1080P/dragonboat/db_pass/db_time.png",
      name = "left_time_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(380.75, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 224),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time",
      z = 0,
      parent = "progress_bg",
      text = T("\229\137\169\228\189\153 12\229\164\1696\230\151\182"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(399.25, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(425, 16)
    },
    t = "Scale9Sprite",
    base = {
      name = "progress_bar_bg",
      z = 0,
      parent = "progress_bg",
      res = "UI/alpha/1080P/dragonboat/db_pass/db_progressbarbottom.png",
      capInsets = CCRectMake(15, 7.5, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(95.75, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(422, 13)
    },
    t = "Scale9Sprite",
    base = {
      name = "progress_bar",
      z = 0,
      parent = "progress_bg",
      res = "UI/alpha/1080P/dragonboat/db_pass/db_progressbar.png",
      capInsets = CCRectMake(5, 6.5, 408, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(97.25, 23.5)
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
      name = "label_exp_title",
      z = 0,
      parent = "progress_bg",
      text = T("\231\178\189\233\166\153\231\187\143\233\170\140\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(100.25, 45)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(136, 223, 10),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_exp_num",
      z = 0,
      parent = "progress_bg",
      text = "50",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(202.75, 45)
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
      name = "label_exp_base",
      z = 0,
      parent = "progress_bg",
      text = "/200",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(238.75, 45)
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
      name = "label_reward",
      z = 0,
      parent = "btn_reward",
      text = T("\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 31.25)
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
      name = "label_task",
      z = 0,
      parent = "btn_task",
      text = T("\228\187\187\229\138\161"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28, 31.25)
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
      name = "label_reward_select",
      z = 0,
      parent = "btn_reward_select",
      text = T("\229\165\150\229\138\177"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 32)
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
      name = "label_task_select",
      z = 0,
      parent = "btn_task_select",
      text = T("\228\187\187\229\138\161"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 32)
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
      name = "label_level",
      z = 0,
      parent = "bg",
      text = "56",
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205.75, 396)
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
      parent = "bg",
      name = "label_exp_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(231.75, 401)
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
      parent = "bg",
      res = "UI/alpha/1080P/dragonboat/db_pass/db_time.png",
      name = "img_left_time",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(551.25, 396.5)
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
      parent = "bg",
      name = "label_left_time",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(564.25, 396)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 293.5, h = 9},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_pass/br_pass_progress_bg.png",
      name = "progress_bar_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(376.75, 385.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(291.5, 8)
    },
    t = "Scale9Sprite",
    base = {
      name = "progress_bar",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/bunnyrace/br_pass/br_pass_progress.png",
      capInsets = CCRectMake(10, 4, 271.5, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(231.25, 385)
    }
  }
}

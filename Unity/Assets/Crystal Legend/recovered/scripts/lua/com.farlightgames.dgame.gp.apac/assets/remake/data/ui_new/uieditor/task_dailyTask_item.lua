ed.uieditor = ed.uieditor or {}
ed.uieditor.task_dailyTask_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 741, h = 70.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/task/daily_task_list_1.png",
      name = "img_conduct_bj",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(368.5, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 742, h = 71.5},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/task/daily_task_ok_bj.png",
      name = "img_pass_bj",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(368.5, 35.5)
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
      size = 16,
      text = T("\228\187\187\229\138\161\229\144\141\231\167\176"),
      name = "item_task_name",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(14, 45)
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
      size = 14,
      text = T("\228\187\187\229\138\161\229\134\133\229\174\185\230\143\143\232\191\176\230\150\135\230\156\172\239\188\140\229\164\167\230\166\130\230\156\128\233\149\191\232\131\189\231\148\168\228\186\140\229\141\129\228\184\170\229\173\151\230\149\176\227\128\130"),
      name = "item_task_txt",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(14, 20)
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
      size = 13,
      text = "2/3",
      name = "item_task_prs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.5, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(256, 50)
    },
    t = "Layer",
    base = {
      name = "item_task_itemlay",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(347, 11.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 9.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_541",
      z = 0,
      parent = "img_conduct_bj",
      res = "UI/alpha/1080P/task/task_progress_bj.png",
      capInsets = CCRectMake(10, 0, 10, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103.5, 9.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 9.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_541_Copy0",
      z = 0,
      parent = "img_pass_bj",
      res = "UI/alpha/1080P/task/task_progress_pass_bj.png",
      capInsets = CCRectMake(10, 0, 10, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_pass_bj",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_gift",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(673.5, 35.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 40)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_conduct",
      z = 0,
      parent = "img_conduct_bj",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(10, 10, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(673, 34.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 243, h = 70.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_conduct_bj",
      res = "UI/alpha/1080P/task/daily_task_list_3.png",
      name = "img_pass_fa",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(619.5, 35.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 170.55, h = 7.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_conduct_bj",
      res = "UI/alpha/1080P/task/task_progress.png",
      name = "img_progress_bar1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103.5, 9.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 168.75, h = 5.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_pass_bj",
      res = "UI/alpha/1080P/task/task_progress_pass.png",
      name = "img_progress_bar2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 244, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_545",
      z = 0,
      parent = "btn_gift",
      text = T("\233\162\134 \229\143\150"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.75, 22)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 244, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_conduct_str",
      z = 0,
      parent = "btn_conduct",
      text = T("\229\137\141 \229\190\128"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100.5, h = 59},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_pass_fa",
      res = "UI/alpha/1080P/task/daily_task_pass.png",
      name = "img_pass",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174.5, 35.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 233, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_550",
      z = 0,
      parent = "img_pass",
      text = T("\229\183\178\229\174\140\230\136\144"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 29.5)
    }
  }
}

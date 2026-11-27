ed.uieditor = ed.uieditor or {}
ed.uieditor.task_achievement_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 741, h = 93.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/task/achievement_list_item.png",
      name = "img_conduct_acg_bj",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(374, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 748, h = 96.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/task/achievement_list_pass.png",
      name = "img_pass_acg_bj",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(374, 47)
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
      text = T("\233\173\148\230\179\149\232\144\168\230\137\139"),
      name = "item_ach_name",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(97.5, 63.5)
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
      name = "item_ach_prs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184.5, 17.5)
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
      text = T("\229\156\168\229\143\164\230\139\137\229\149\166\233\173\148\230\179\149\229\159\142\229\160\161\230\137\147\232\180\165\228\186\140\229\141\129\228\189\141\233\187\145\230\154\151\228\185\139\231\165\158"),
      name = "item_ach_txt",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(97.5, 31.5)
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
      res = "UI/alpha/1080P/task/achievement_cjd.png",
      name = "ImageView_568",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476, 67.5)
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
      size = 18,
      text = "96",
      name = "item_ach_num",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(492.5, 68.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 35)
    },
    t = "Layer",
    base = {
      name = "item_ach_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(390, 7.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(35, 35)
    },
    t = "Layer",
    base = {name = "panel_icon", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(30.5, 28.5)
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
      parent = "img_conduct_acg_bj",
      res = "UI/alpha/1080P/task/task_progress_bj.png",
      capInsets = CCRectMake(10, 0, 10, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(181.5, 15.75)
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
      name = "ImageView_541_Copy1",
      z = 0,
      parent = "img_pass_acg_bj",
      res = "UI/alpha/1080P/task/task_progress_pass_bj.png",
      capInsets = CCRectMake(10, 0, 10, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(185, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 116.5, h = 77},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "img_pass_acg_bj",
      res = "UI/alpha/1080P/task/achievement_pass.png",
      name = "img_pass_ach",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(678, 49.75)
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
      parent = "img_pass_acg_bj",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_gift_ach",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(675, 45.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 40)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_conduct_ach",
      z = 0,
      parent = "img_conduct_acg_bj",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(10, 10, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(672.5, 43.25)
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
      parent = "img_conduct_acg_bj",
      res = "UI/alpha/1080P/task/task_progress.png",
      name = "img_progress_bar1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(182, 15.75)
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
      parent = "img_pass_acg_bj",
      res = "UI/alpha/1080P/task/task_progress_pass.png",
      name = "img_progress_bar2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(185.5, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 253, 189),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "img_pass_ach_str",
      z = 0,
      parent = "img_pass_ach",
      text = T("\229\183\178\232\190\190\230\136\144"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.25, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(249, 224, 131),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_complete_time",
      z = 0,
      parent = "img_pass_ach",
      text = "2022/10/22",
      size = 11
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.25, 29)
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
      name = "btn_gift_ach_str",
      z = 0,
      parent = "btn_gift_ach",
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
      parent = "btn_conduct_ach",
      text = T("\229\137\141 \229\190\128"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 21)
    }
  }
}

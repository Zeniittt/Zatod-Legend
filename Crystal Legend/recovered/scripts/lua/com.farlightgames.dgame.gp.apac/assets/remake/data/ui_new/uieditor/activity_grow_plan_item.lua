ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_grow_plan_item = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(512, 87)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(317.5, 29, 0.5, 29),
      res = "UI/alpha/1080P/activity/grow_plan/grow_plan_task_bg_todo.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(2.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(158, 65)
    },
    t = "Layer",
    base = {
      name = "reward_list",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(215, -31.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(65, 92, 68),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 18,
      text = T("\233\133\146\228\187\153\229\141\135\232\135\1795\230\152\159"),
      name = "task_desc",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(34.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 99.6, h = 40.4},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "get_reward",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(421, -0.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100.5, h = 59},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/grow_plan/grow_plan_task_fin_symbol.png",
      name = "completed",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(421, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(66, 85, 60),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      size = 18,
      text = T("\232\191\155\232\161\140\228\184\173"),
      name = "ongoing",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(425, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.5, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/grow_plan/grow_plan_task_corner_daily.png",
      name = "image_corner",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.5, 36)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 230, 167),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_400",
      z = 0,
      parent = "get_reward",
      text = T("\233\162\134\229\143\150"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.75, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/grow_plan/grow_plan_arrow.png",
      name = "image_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(77, 96, 71),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_402",
      z = 0,
      parent = "completed",
      text = T("\229\183\178\229\174\140\230\136\144"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 29.5)
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
      name = "label_corner",
      z = 0,
      parent = "image_corner",
      text = T("\230\156\172\230\151\165"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(13.75, 10.25)
    }
  }
}

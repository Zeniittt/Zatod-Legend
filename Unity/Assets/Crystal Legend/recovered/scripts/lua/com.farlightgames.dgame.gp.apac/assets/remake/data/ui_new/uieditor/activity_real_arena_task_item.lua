ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_real_arena_task_item = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(543, 96)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(317.5, 29, 0.5, 29),
      res = "UI/alpha/1080P/activity/realarena_reward/board.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-9.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 67)
    },
    t = "Layer",
    base = {
      name = "reward_list",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(180, -34.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(145, 61, 38),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 19,
      text = T("\230\140\145\230\136\152\231\171\158\230\138\128\229\156\1865\230\172\161"),
      name = "task_desc",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(28, 1)
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
      position = ccp(449.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.95, x = 0.95},
      flip = "",
      opacity = 255,
      fix_wh = {w = 95.475, h = 56.05},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/seven_day/seven_day_task_done.png",
      name = "completed",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(449.5, -2)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(145, 61, 38),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 20,
      text = "0/10",
      name = "ongoing",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(448, 0.5)
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
      position = ccp(499.5, -1.5)
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(526, 91)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 0, 8, 91),
      res = "UI/alpha/1080P/activity/pvptask/pvptask_shade.png",
      name = "image_mask",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-0.5, -0.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 242, 193),
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
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.75, 30)
    }
  }
}

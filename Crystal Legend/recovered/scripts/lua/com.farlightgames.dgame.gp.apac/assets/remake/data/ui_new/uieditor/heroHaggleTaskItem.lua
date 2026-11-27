ed.uieditor = ed.uieditor or {}
ed.uieditor.heroHaggleTaskItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 568, h = 78.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_task_bar_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0.5, 0)
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
      name = "label_task_name",
      z = 0,
      parent = "bg",
      text = T("\230\128\187\228\188\164\229\174\179\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30.5, 40.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 147.5, h = 48},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_button_red.png",
      name = "btn_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 38.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(239, 238, 228),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_des",
      z = 0,
      parent = "btn_detail",
      text = T("\233\162\134\229\143\150"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74.25, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 65.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(214, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_go",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(498.5, 14.75)
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
      name = "Label_36584",
      z = 0,
      parent = "bg",
      text = "500/100",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(474, 39.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/hero_haggle/hero_haggle_task_go.png",
      name = "ImageView_36585",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(540, 39.75)
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
      name = "layer_task_done",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(477.5, 39.25)
    }
  }
}

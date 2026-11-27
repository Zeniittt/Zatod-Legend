ed.uieditor = ed.uieditor or {}
ed.uieditor.hades_task_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 144, h = 45.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/hades/hades_task_tab_unchoose.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
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
      name = "label_name",
      z = 0,
      parent = "image_bg",
      text = T("\228\187\187\229\138\161\229\144\141\231\167\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72, 23.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.5, h = 16.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_task_redpoint.png",
      name = "image_red_point",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(130, 37.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 61.5, h = 35},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_task_focus.png",
      name = "image_trace",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(6.5, 23.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.3, x = 0.299999923},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16.0499958805, h = 14.1},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/common_mark.png",
      name = "image_finish",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, 22.75)
    }
  }
}

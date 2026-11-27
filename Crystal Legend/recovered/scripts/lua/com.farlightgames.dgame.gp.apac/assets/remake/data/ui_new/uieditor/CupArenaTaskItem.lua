ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaTaskItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 216.5, h = 344.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_task_bg.png",
      name = "bg",
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
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125, h = 125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/cuparena_camp_symbol_1.png",
      name = "img_camp",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.25, 247.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 146, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_task_des.png",
      name = "bg_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.25, 94.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 126.5, h = 35},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_task_go.png",
      name = "btn_go",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.75, 56.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 126.5, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_task_done.png",
      name = "bg_done",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.25, 54.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_medal",
      res = "UI/alpha/1080P/toparena/toparena_star_icon_2.png",
      name = "img_my_medal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(54, 14)
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
      name = "label_medal",
      z = 0,
      parent = "bg_medal",
      text = "+10",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 14)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 243, 160),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_go",
      z = 0,
      parent = "btn_go",
      text = T("\229\137\141\229\190\128"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.75, 18)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(212, 255, 129),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_done",
      z = 0,
      parent = "bg_done",
      text = T("\229\183\178\229\174\140\230\136\144"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56.25, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.42, x = 0.42},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.47, h = 19.74},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_done",
      res = "UI/alpha/1080P/common/common_mark.png",
      name = "img_done",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93.25, 18.5)
    }
  }
}

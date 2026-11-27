ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_bbgs_page = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "page_lay", z = 0},
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
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/bubugaosheng/bg.jpg",
      name = "ImageView_27",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
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
      parent = "page_lay",
      name = "Panel_3618",
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
      fix_wh = {w = 373, h = 153},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_3618",
      res = "UI/alpha/1080P/activity/bubugaosheng/text.png",
      name = "ImageView_3559",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(605, 455)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 541.5, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_3618",
      res = "UI/alpha/1080P/activity/bubugaosheng/bg_1.png",
      name = "ImageView_3562",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(717.5, 395)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 555, h = 293},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_3618",
      res = "UI/alpha/1080P/activity/bubugaosheng/bg_11.png",
      name = "ImageView_3564",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(717.5, 224)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97, h = 97},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_3618",
      res = "UI/alpha/1080P/activity/bubugaosheng/bg_2.png",
      name = "ImageView_3571",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(339, 161)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(555, 258)
    },
    t = "Layer",
    base = {
      parent = "ImageView_3564",
      name = "Panel_item",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
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
      name = "Label_3560",
      z = 0,
      parent = "ImageView_3559",
      text = T("\229\137\169\228\189\153\230\151\182\233\151\180\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(367.5, 53.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 125),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_time",
      z = 0,
      parent = "ImageView_3559",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(408.5, 54)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79.5, h = 65.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_3562",
      res = "UI/alpha/1080P/activity/bubugaosheng/right_fream.png",
      name = "ImageView_3563",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(461.75, 17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 205.5, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_3564",
      res = "UI/alpha/1080P/activity/seven_day/seven_day_tab_up_1.png",
      name = "ImageView_3565",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(147.5, 265.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 250, 228),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_page1s",
      z = 9,
      parent = "ImageView_3564",
      text = T("\229\133\168\230\156\141\230\142\146\229\144\141"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148.5, 276)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 250, 228),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "Label_page2s",
      z = 9,
      parent = "ImageView_3564",
      text = T("\230\156\172\230\156\141\230\142\146\229\144\141"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(406, 276)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 567, h = 69},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "ImageView_3564",
      res = "UI/alpha/1080P/activity/bubugaosheng/bg_10.png",
      name = "ImageView_3570",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(277, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 208, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_3571",
      res = "UI/alpha/1080P/activity/bubugaosheng/bg_3.png",
      name = "ImageView_3572",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 35)
    },
    t = "Layer",
    base = {
      parent = "ImageView_3564",
      name = "button1",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(25.5, 258)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 35)
    },
    t = "Layer",
    base = {
      parent = "ImageView_3564",
      name = "button2",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(279.5, 258)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107.525, h = 29.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_3571",
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_task_go.png",
      name = "ImageView_3651",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, -29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 152.5, h = 135},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_3564",
      res = "UI/alpha/1080P/activity/bubugaosheng/empty.png",
      name = "empty",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(277.5, 146.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(163, 142, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_page1",
      z = 0,
      parent = "button1",
      text = T("\229\133\168\230\156\141\230\142\146\229\144\141"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(122.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(163, 142, 153),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_page2",
      z = 0,
      parent = "button2",
      text = T("\230\156\172\230\156\141\230\142\146\229\144\141"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(126.5, 17.5)
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
      name = "Label_3652",
      z = 0,
      parent = "ImageView_3651",
      text = T("\229\137\141\229\190\128"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.25, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(138, 107, 129),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3668",
      z = 0,
      parent = "empty",
      text = T("\230\142\146\232\161\140\230\166\156\232\153\154\228\189\141\228\187\165\229\190\133"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76.25, 8.5)
    }
  }
}

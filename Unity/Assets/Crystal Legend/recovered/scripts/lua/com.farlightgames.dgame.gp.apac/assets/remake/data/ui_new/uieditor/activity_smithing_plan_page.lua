ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_smithing_plan_page = {
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
      res = "UI/alpha/1080P/activity/smithing_plan/bg.jpg",
      name = "bj",
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
      scaleSize = CCSizeMake(457, 305.5)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_item",
      z = 3
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(501.5, 56)
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
      name = "Panel_mod",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(361.5, 235)
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
      name = "Panel_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(216.5, 360)
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
      name = "Panel_task",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(477.5, 362)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 621.5, h = 310},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/smithing_plan/baseplate.png",
      name = "ImageView_24599",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(726.5, 209)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 276.5, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_mod",
      res = "UI/alpha/1080P/activity/smithing_plan/rewarddisplay3.png",
      name = "ImageView_24591",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(6, -90.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 429, h = 80},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_mod",
      res = "UI/alpha/1080P/activity/smithing_plan/rewarddisplay1.png",
      name = "ImageView_24592",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-55.5, -139.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 300, h = 93},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_mod",
      res = "UI/alpha/1080P/activity/smithing_plan/rewarddisplay2.png",
      name = "ImageView_24593",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(3.5, -131.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 172, h = 59.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_mod",
      res = "UI/alpha/1080P/activity/smithing_plan/table.png",
      name = "ImageView_24594",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(9, -114)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 135, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_mod",
      res = "UI/alpha/1080P/activity/smithing_plan/details_button1.png",
      name = "ImageView_24596",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(4.5, -66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 207.5, h = 207.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_mod",
      res = "UI/alpha/1080P/activity/smithing_plan/halo.png",
      name = "ImageView_24600",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 275.5, h = 94},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_title",
      res = "UI/alpha/1080P/activity/smithing_plan/title.png",
      name = "ImageView_24585",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134, 87)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 247.5, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_title",
      res = "UI/alpha/1080P/activity/smithing_plan/time.png",
      name = "ImageView_24586",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 515, h = 139.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_task",
      res = "UI/alpha/1080P/activity/smithing_plan/progressbar.png",
      name = "ImageView_24589",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(255.5, 67)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 471.5, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_task",
      res = "UI/alpha/1080P/activity/smithing_plan/progress bar1.png",
      name = "progress",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(256, 82.5)
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
      name = "Label_time",
      z = 0,
      parent = "ImageView_24586",
      text = T("\229\137\169\228\189\153 "),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(77.25, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17.5, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_24596",
      res = "UI/alpha/1080P/activity/smithing_plan/details_icon.png",
      name = "ImageView_24597",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_24596",
      res = "UI/alpha/1080P/activity/smithing_plan/details_button2.png",
      name = "ImageView_24623",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124.5, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_24586",
      res = "UI/alpha/1080P/activity/smithing_plan/timeicon.png",
      name = "ImageView_24587",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(54.25, 19.75)
    }
  }
}

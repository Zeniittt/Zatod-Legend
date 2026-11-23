ed.uieditor = ed.uieditor or {}
ed.uieditor.SevenDayTabBtn = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 127, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/seven_day/seven_day_tab_right_3.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 141, h = 56},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/seven_day/seven_day_tab_right_1.png",
      name = "selected",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(106, 59, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "selected_mid",
      z = 0,
      parent = "selected",
      text = "1",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75.5, 28)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(114, 74, 20),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "selected_suffix",
      z = 0,
      parent = "selected",
      text = T("\229\164\169"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(86.5, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 127, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/seven_day/seven_day_tab_right_3.png",
      name = "locked",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(114, 74, 20),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "selected_prefix",
      z = 0,
      parent = "selected",
      text = T("\231\172\172"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(65, 28)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "normal",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(63.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(231, 199, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "locked_mid",
      z = 0,
      parent = "locked",
      text = "1",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(186, 156, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "locked_suffix",
      z = 0,
      parent = "locked",
      text = T("\229\164\169"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(74.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "redlight",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120, 37)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(186, 156, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "locked_prefix",
      z = 0,
      parent = "locked",
      text = T("\231\172\172"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(52.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "locked",
      res = "UI/alpha/1080P/activity/seven_day/seven_day_tab_right_lock.png",
      name = "icon_locked",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(7.5, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(186, 156, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "normal_prefix",
      z = 0,
      parent = "normal",
      text = T("\231\172\172"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(-11, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(186, 156, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "normal_suffix",
      z = 0,
      parent = "normal",
      text = T("\229\164\169"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(11, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(231, 199, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "normal_mid",
      z = 0,
      parent = "normal",
      text = "1",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  }
}

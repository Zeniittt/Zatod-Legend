ed.uieditor = ed.uieditor or {}
ed.uieditor.GobackTaskPage = {
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
      res = "UI/alpha/1080P/goback/line_reward/goback_line_reward_bg.jpg",
      name = "bg",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 239.5, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn_go",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(645.5, 153.5)
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
      name = "Label_4049",
      z = 0,
      parent = "btn_go",
      text = T("\229\137\141\229\190\128\228\187\187\229\138\161"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.75, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 204.5, h = 133.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/line_reward/goback_line_reward_title.png",
      name = "ImageView_4742",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(436.5, 516)
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
      name = "time",
      z = 0,
      parent = "bg",
      text = T("\229\137\169\228\189\15310\229\164\16921\230\151\182"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(787, 418)
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
      name = "Panel_4859",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(585, 360)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 794, h = 161},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/line_reward/goback_line_reward_line_bg.png",
      name = "bg_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(647, 294)
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
      name = "tip_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(520, 420)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(725, 25)
    },
    t = "Layer",
    base = {
      parent = "bg_bar",
      name = "layer_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(77.5, 131.5)
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
      name = "label_score",
      z = 0,
      parent = "bg_bar",
      text = "59",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 129.5)
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
      name = "score",
      z = 0,
      parent = "bg_bar",
      text = T("\229\189\147\229\137\141\231\167\175\229\136\134"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 148)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120, 53)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(209.5, 70)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(301.5, 53.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(392, 70)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482, 53.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(572.5, 70.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(663.5, 53.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_bar",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon8",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(753.5, 70.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 685.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_bar",
      res = "UI/alpha/1080P/goback/line_reward/goback_line_reward_line.png",
      name = "bar",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 11.5)
    }
  }
}

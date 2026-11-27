ed.uieditor = ed.uieditor or {}
ed.uieditor.speedHelperWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 605.5, h = 384.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/helper/helper_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(469, 293.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 53},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/helper/helper_pause.png",
      name = "btn_pause",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264.75, 144.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 53},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/helper/helper_speed_down.png",
      name = "btn_down",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(323.75, 144.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 53},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/helper/helper_speed_up.png",
      name = "btn_up",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(524.25, 144.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 228),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_pause",
      z = 0,
      parent = "image_bg",
      text = T("\230\154\130\229\129\156"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264.75, 119.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 228),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_down",
      z = 0,
      parent = "image_bg",
      text = T("\229\135\143\233\128\159"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(323.75, 119.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 254, 228),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_up",
      z = 0,
      parent = "image_bg",
      text = T("\229\138\160\233\128\159"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(524.25, 119.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 145.5, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/helper/helper_progress_1.png",
      name = "image_bar_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(424.25, 144.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(226, 223, 216),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tips",
      z = 0,
      parent = "image_bg",
      text = T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\17650\231\186\167\239\188\140\229\188\128\229\144\175x3\229\128\141\229\138\160\233\128\159\228\184\138\233\153\144"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(394.75, 86.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.5, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/helper/helper_check_bg.png",
      name = "btn_check_box",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(322.75, 28.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(211, 208, 204),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_check_box_tips",
      z = 0,
      parent = "image_bg",
      text = T("\229\133\179\233\151\173\230\130\172\230\181\174\230\149\136\230\158\156"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(382.75, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(573.75, 263.75)
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
      parent = "image_bg",
      name = "title_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(395.25, 271.25)
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
      parent = "image_bg",
      name = "speed_rate_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(394.25, 216.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.5, h = 32.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bar_bg",
      res = "UI/alpha/1080P/helper/helper_progress_3.png",
      name = "btn_bar",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72.75, 12)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(145.5, 24)
    },
    t = "Layer",
    base = {
      parent = "image_bar_bg",
      name = "panel_bar_clip",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.75, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_check_box",
      res = "UI/alpha/1080P/helper/helper_check.png",
      name = "image_check",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.25, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 145.5, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_bar_clip",
      res = "UI/alpha/1080P/helper/helper_progress_2.png",
      name = "image_bar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(72, 12)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_1080",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  }
}

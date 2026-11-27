ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_riseStar_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 483.5, h = 79.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/risestar/inglist.png",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 65)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "reward_list",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(235.25, 8.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 17.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/risestar/daily_tag.png",
      name = "image_taskType",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(25.25, 65.25)
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
      name = "label_taskName",
      z = 0,
      parent = "image_bg",
      text = T("\230\175\143\230\151\165\230\182\136\232\128\151\228\189\147\229\138\155"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(24.75, 46.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 184.5, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/risestar/linebg.png",
      name = "image_processon_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120.25, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 133.5, h = 44.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/risestar/getaward_button.png",
      name = "btn_getReward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(398.75, 38.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 122, h = 38.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/risestar/complete_button.png",
      name = "btn_complate",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(400.75, 39.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 50)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "layer_goway",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(356.25, 14.75)
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
      name = "label_taskType",
      z = 0,
      parent = "image_taskType",
      text = "",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.75, 8.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 184.5, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_processon_bg",
      res = "UI/alpha/1080P/risestar/line.png",
      name = "image_process",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-0.25, 4.25)
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
      name = "Label_38397",
      z = 1,
      parent = "image_processon_bg",
      text = "480/480",
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85.75, 4.75)
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
      name = "Label_38399",
      z = 0,
      parent = "btn_getReward",
      text = T("\233\162\134\229\143\150"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68.25, 24.75)
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
      name = "Label_38401",
      z = 0,
      parent = "btn_complate",
      text = T("\229\183\178\229\174\140\230\136\144"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_goway",
      res = "UI/alpha/1080P/risestar/arrows.png",
      name = "ImageView_38403",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(75, 27)
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
      name = "Label_38404",
      z = 0,
      parent = "layer_goway",
      text = T("\229\137\141\229\190\128"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44, 27)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 184.5, h = 8.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_processon_bg",
      res = "UI/alpha/1080P/risestar/lineover.png",
      name = "image_processmask",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92.25, 4.25)
    }
  }
}

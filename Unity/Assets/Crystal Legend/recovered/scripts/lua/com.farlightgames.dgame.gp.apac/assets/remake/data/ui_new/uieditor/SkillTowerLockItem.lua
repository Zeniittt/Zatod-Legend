ed.uieditor = ed.uieditor or {}
ed.uieditor.SkillTowerLockItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 404},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skilltower/main_tower_bg_7.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 7)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 187.5, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/small_title_tower5.png",
      name = "title",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 99.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 107},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/main_tower_bg_8.png",
      name = "bg_info",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 48)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 245, h = 409},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/main_tower_frame_4.png",
      name = "frame",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 194.5)
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
      parent = "bg_info",
      name = "layer_info",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(105.5, 53.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 198, h = 24},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_info",
      res = "UI/alpha/1080P/skilltower/abyss_remake.png",
      name = "label_unopen",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 60.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 133, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/main_tower_couuntdown_bg.png",
      name = "bg_time",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 342.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_curfloor",
      z = 0,
      parent = "layer_info",
      text = T("\229\189\147\229\137\141\229\177\130\230\149\176"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-72, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_totaltime",
      z = 0,
      parent = "layer_info",
      text = T("\230\128\187\232\128\151\230\151\182"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-72, -3)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_curfloor1",
      z = 0,
      parent = "layer_info",
      text = "27/30",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(77, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_totaltime1",
      z = 0,
      parent = "layer_info",
      text = "10:23:24",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(77, -3)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 245, h = 421},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/mask_tower.png",
      name = "mask",
      z = 4
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 202)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_unopen1",
      z = 0,
      parent = "label_unopen",
      text = T("\229\185\187\229\162\131\229\189\147\229\137\141\230\173\163\229\156\168\233\135\141\231\187\132\228\184\173..."),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95.5, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60.5, 105)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(190.5, 115.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 231, 247),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "bg_time",
      text = T("12\229\164\1691\230\151\182"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 17, h = 17},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_time",
      res = "UI/alpha/1080P/skilltower/main_tower_countdown_icon.png",
      name = "ImageView_4878",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.5, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 100,
      fix_wh = {w = 148.5, h = 54},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_time",
      res = "UI/alpha/1080P/skilltower/abyss_main_icon_01_tf.png",
      name = "btn_buff",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66.5, 48)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.5, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_buff",
      res = "UI/alpha/1080P/skilltower/abyss_main_icon_02_tf.png",
      name = "btn_buff_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.75, 24)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 93.5, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_buff",
      res = "UI/alpha/1080P/skilltower/abyss_main_icon_03_tf.png",
      name = "btn_buff_label_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.25, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 223, 140),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_buff_label",
      z = 0,
      parent = "btn_buff",
      text = T("\230\156\172\230\156\159\230\149\136\230\158\156"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(54.75, 25)
    }
  }
}

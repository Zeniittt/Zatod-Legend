ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueCollectScene = {
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
      res = "UI/alpha/1080P/rogue/collect/collect_bg.jpg",
      name = "image_bg",
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
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "image_title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(161.5, 599)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 336.5, h = 51},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/collect/collect_progress_bg.png",
      name = "destiny_collect_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(257.5, 172.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 336.5, h = 51},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/collect/collect_progress_bg.png",
      name = "event_collect_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(925, 172.5)
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
      name = "Label_48098",
      z = 0,
      parent = "destiny_collect_bg",
      text = T("\230\148\182\233\155\134\232\191\155\229\186\166\239\188\154"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142.75, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 230, 154),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_destiny_progress",
      z = 0,
      parent = "destiny_collect_bg",
      text = "0%",
      size = 23
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(198.75, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 237.5, h = 363},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/collect/collect_destiny_enter_1.png",
      name = "destiny_enter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(257.5, 376.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "destiny_collect_bg",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_destiny_entry_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(268.25, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230, h = 355.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/collect/collect_event_enter_1.png",
      name = "event_enter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(925, 380)
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
      name = "Label_48098",
      z = 0,
      parent = "event_collect_bg",
      text = T("\230\148\182\233\155\134\232\191\155\229\186\166\239\188\154"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142.75, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 230, 154),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_event_progress",
      z = 0,
      parent = "event_collect_bg",
      text = "0%",
      size = 23
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(198.75, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "event_collect_bg",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_event_entry_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(268.25, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 50)
    },
    t = "Layer",
    base = {
      parent = "destiny_enter",
      name = "panel_destiny_name",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(69.25, 89.5)
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
      name = "label_destiny_desc",
      z = 1,
      parent = "destiny_enter",
      text = T("\229\145\189\232\191\144\230\152\173\231\132\182\232\139\165\230\143\173\229\145\189\232\191\144\230\151\160\229\143\175\229\140\185\230\149\140"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.75, 63.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 278.5, h = 380},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "destiny_enter",
      res = "UI/alpha/1080P/rogue/collect/collect_destiny_enter_2.png",
      name = "destiny_enter_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.35, 0.1),
      position = ccp(52.25, 32)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 267.5, h = 374},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "destiny_enter",
      res = "UI/alpha/1080P/rogue/collect/collect_destiny_enter_3.png",
      name = "destiny_enter_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.1),
      position = ccp(141.25, 30)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 50)
    },
    t = "Layer",
    base = {
      parent = "event_enter",
      name = "panel_event_name",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(64, 81.75)
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
      name = "label_event_desc",
      z = 1,
      parent = "event_enter",
      text = T("\231\140\156\231\140\156\231\156\139\239\188\140\228\187\128\228\185\136\229\143\171\230\131\138\229\150\156"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.5, 56.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 242, h = 326},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "event_enter",
      res = "UI/alpha/1080P/rogue/collect/collect_event_enter_2.png",
      name = "event_enter_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.1),
      position = ccp(136.5, 33.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 267.5, h = 327},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "event_enter",
      res = "UI/alpha/1080P/rogue/collect/collect_event_enter_3.png",
      name = "event_enter_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.1),
      position = ccp(72.5, 66.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 336.5, h = 51},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/collect/collect_progress_bg.png",
      name = "script_collect_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(596, 172.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 237.5, h = 363},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/collect/collect_script_enter_1.png",
      name = "script_enter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 377.5)
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
      name = "Label_48098",
      z = 0,
      parent = "script_collect_bg",
      text = T("\230\148\182\233\155\134\232\191\155\229\186\166\239\188\154"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142.75, 30)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 230, 154),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_script_progress",
      z = 0,
      parent = "script_collect_bg",
      text = "0%",
      size = 23
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(198.75, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "script_collect_bg",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_script_entry_red",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(268.25, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 50)
    },
    t = "Layer",
    base = {
      parent = "script_enter",
      name = "panel_script_name",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(67.75, 87)
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
      name = "label_script_desc",
      z = 1,
      parent = "script_enter",
      text = T("\230\188\148\231\187\142\229\145\189\232\191\144\227\128\129\230\188\148\231\187\142\231\187\147\229\177\128"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.75, 63.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 282, h = 383},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "script_enter",
      res = "UI/alpha/1080P/rogue/collect/collect_script_enter_2.png",
      name = "script_enter_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.1),
      position = ccp(93.75, 35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 265, h = 373.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "script_enter",
      res = "UI/alpha/1080P/rogue/collect/collect_script_enter_3.png",
      name = "script_enter_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.1),
      position = ccp(140.75, 34)
    }
  }
}

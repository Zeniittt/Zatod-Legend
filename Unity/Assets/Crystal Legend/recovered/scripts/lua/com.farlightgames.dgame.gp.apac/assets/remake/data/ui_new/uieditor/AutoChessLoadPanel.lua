ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessLoadPanel = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
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
      fix_wh = {w = 533.5, h = 60.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/loading/tips_bg.png",
      name = "ImageView_11891",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 47)
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
      name = "label_tip",
      z = 0,
      parent = "ImageView_11891",
      text = T("\229\189\147\230\139\165\230\156\1373\228\184\170\231\155\184\229\144\140\232\139\177\233\155\132\230\151\182\239\188\140\232\139\177\233\155\132\229\176\134\232\135\170\229\138\168\229\141\135\230\152\159\239\188\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(266.75, 19.75)
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
      name = "label_tip_title",
      z = 0,
      parent = "ImageView_11891",
      text = "TIPS:",
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(266.75, 42.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 115)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "node_player_1",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-29, 16)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "img_enter_tip",
      z = 2,
      parent = "bg",
      text = T("\229\141\179\229\176\134\232\191\155\229\133\165\230\184\184\230\136\143"),
      size = 36
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479.5, 110.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(97, 232, 80),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name_1",
      z = 5,
      parent = "node_player_1",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\144\141\229\173\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 32)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_player_1",
      res = "UI/alpha/1080P/chess/loading/progress_bg.png",
      name = "img_progress_bg_1",
      z = 4
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(5, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 115)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "node_player_2",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(120, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.95, x = 0.95},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.825, h = 89.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_player_1",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "icon_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 66)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 115)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "node_player_3",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(759, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_progress_bg_1",
      res = "UI/alpha/1080P/chess/loading/progress.png",
      name = "img_progress_1",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 9.25)
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
      name = "label_progress_1",
      z = 10,
      parent = "img_progress_bg_1",
      text = "0%",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 9.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 115)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "node_player_4",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(908, 16)
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
      name = "label_name_2",
      z = 5,
      parent = "node_player_2",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\144\141\229\173\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 32)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_player_2",
      res = "UI/alpha/1080P/chess/loading/progress_bg.png",
      name = "img_progress_bg_2",
      z = 4
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(5, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.95, x = 0.95},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.825, h = 89.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_player_2",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "icon_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 66)
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
      name = "label_name_3",
      z = 5,
      parent = "node_player_3",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\144\141\229\173\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 32)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1200, 141.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_205",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/chess/loading/player_bg.png",
      capInsets = CCRectMake(0.5, 0.5, 1, 140.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 71)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_player_3",
      res = "UI/alpha/1080P/chess/loading/progress_bg.png",
      name = "img_progress_bg_3",
      z = 4
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(5, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.95, x = 0.95},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.825, h = 89.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_player_3",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "icon_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 66)
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
      name = "label_name_4",
      z = 5,
      parent = "node_player_4",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151\229\144\141\229\173\151"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 32)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_progress_bg_2",
      res = "UI/alpha/1080P/chess/loading/progress.png",
      name = "img_progress_2",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 9.25)
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
      name = "label_progress_2",
      z = 10,
      parent = "img_progress_bg_2",
      text = "0%",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 9.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_player_4",
      res = "UI/alpha/1080P/chess/loading/progress_bg.png",
      name = "img_progress_bg_4",
      z = 4
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(5, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.95, x = 0.95},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.825, h = 89.3},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_player_4",
      res = "UI/alpha/1080P/mainhead/main_head_frame_silver.png",
      name = "icon_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48, 66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_progress_bg_3",
      res = "UI/alpha/1080P/chess/loading/progress.png",
      name = "img_progress_3",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 9.25)
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
      name = "label_progress_3",
      z = 10,
      parent = "img_progress_bg_3",
      text = "0%",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 9.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 88.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_progress_bg_4",
      res = "UI/alpha/1080P/chess/loading/progress.png",
      name = "img_progress_4",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 9.25)
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
      name = "label_progress_4",
      z = 10,
      parent = "img_progress_bg_4",
      text = "0%",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 9.25)
    }
  }
}

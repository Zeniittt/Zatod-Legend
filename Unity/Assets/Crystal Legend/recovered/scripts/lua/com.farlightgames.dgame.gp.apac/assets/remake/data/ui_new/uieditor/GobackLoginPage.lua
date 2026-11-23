ed.uieditor = ed.uieditor or {}
ed.uieditor.GobackLoginPage = {
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
      res = "UI/alpha/1080P/goback/login_reward/goback_login_reward_bg.jpg",
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
      fix_wh = {w = 100.5, h = 127.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/login_reward/goback_login_reward_item_bg_2.png",
      name = "day1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(607, 384)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100.5, h = 127.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/login_reward/goback_login_reward_item_bg_2.png",
      name = "day2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(712.5, 384)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100.5, h = 127.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/login_reward/goback_login_reward_item_bg_2.png",
      name = "day3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(817.5, 384)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100.5, h = 127.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/login_reward/goback_login_reward_item_bg_2.png",
      name = "day4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(607, 254.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100.5, h = 127.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/login_reward/goback_login_reward_item_bg_2.png",
      name = "day5",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(712.5, 254.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 100.5, h = 127.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/login_reward/goback_login_reward_item_bg_2.png",
      name = "day6",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(817.5, 254.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 257.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/login_reward/goback_login_reward_item_bg_big_2.png",
      name = "day7",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(950.5, 319)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 420, h = 550.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/login_reward/goback_login_reward_cat.png",
      name = "ImageView_3957",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(340.5, 336.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 511, h = 122},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/login_reward/goback_login_reward_title.png",
      name = "ImageView_3958",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(786.5, 522.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/login_reward/goback_login_reward_time.png",
      name = "ImageView_8093",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(712, 166.5)
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
      z = 1,
      parent = "bg",
      text = "Text Label",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(733, 166.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 110, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_day1",
      z = 0,
      parent = "day1",
      text = T("\231\172\172\228\184\128\229\164\169"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 110, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_day2",
      z = 0,
      parent = "day2",
      text = T("\231\172\172\228\186\140\229\164\169"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 110, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_day3",
      z = 0,
      parent = "day3",
      text = T("\231\172\172\228\184\137\229\164\169"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 110, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_day4",
      z = 0,
      parent = "day4",
      text = T("\231\172\172\229\155\155\229\164\169"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 110, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_day5",
      z = 0,
      parent = "day5",
      text = T("\231\172\172\228\186\148\229\164\169"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 110, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_day6",
      z = 0,
      parent = "day6",
      text = T("\231\172\172\229\133\173\229\164\169"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 110, 37),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_day7",
      z = 0,
      parent = "day7",
      text = T("\231\172\172\228\184\131\229\164\169"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 22.25)
    }
  }
}

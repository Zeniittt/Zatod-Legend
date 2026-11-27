ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashCourseWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 833, h = 628.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_clash_course/background.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 308.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 188.5, h = 375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_clash_course/decorate2.png",
      name = "ImageView_10432",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93, 243.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 187.5, h = 366},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_clash_course/decorate3.png",
      name = "ImageView_10433",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(746, 231.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_clash_course/icon_close.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(789.5, 443.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 363, h = 495},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_clash_course/decorate1.png",
      name = "image_tree",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(417.5, 290.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(622, 356.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(110.5, 75.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 729.5, h = 577},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/guild/guild_clash_course/background_cover.png",
      name = "ImageView_10621",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(416.5, 341.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 240),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_tree",
      text = T("\231\172\172\229\133\173\229\141\129\232\181\155\229\173\163"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(181.5, 423)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(21, 313)
    },
    t = "Layer",
    base = {
      parent = "image_tree",
      name = "panel_node",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(171.5, 30)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 6, h = 24},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_tree",
      res = "UI/alpha/1080P/guild/guild_clash_course/decorate1_hourline.png",
      name = "image_time_minute",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.1),
      position = ccp(181.5, 376)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 6, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_tree",
      res = "UI/alpha/1080P/guild/guild_clash_course/decorate1_minuteline.png",
      name = "image_time_hour",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.1),
      position = ccp(181.5, 376)
    }
  }
}

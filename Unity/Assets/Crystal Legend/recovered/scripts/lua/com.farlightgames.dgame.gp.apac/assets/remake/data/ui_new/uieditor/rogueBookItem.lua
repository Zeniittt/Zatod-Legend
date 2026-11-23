ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueBookItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 400, h = 400},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/main/main_book_1.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 157.5, h = 162},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/main/main_book_choose_arrow2.png",
      name = "image_cur_tips",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200, 396.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "spine_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(200, 29)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 50)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_name",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(105, 207.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(237, 227, 213),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_cur_tips",
      z = 0,
      parent = "image_cur_tips",
      text = T("\230\173\163\229\156\168\230\184\184\231\142\169"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 103.5)
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
      parent = "panel_name",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "image_book_red",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(163.5, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 191, h = 193.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/main/main_book_light.png",
      name = "image_lock",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200, 233)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 96.5, h = 106},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_lock",
      res = "UI/alpha/1080P/rogue/main/main_book_lock.png",
      name = "ImageView_6479",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95.5, 96.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 207.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_lock",
      res = "UI/alpha/1080P/rogue/main/main_book_lock_bg.png",
      name = "ImageView_6480",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95.5, -13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 194, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_unlock_time",
      z = 0,
      parent = "ImageView_6480",
      text = T("12\229\164\169\229\144\142\229\188\128\230\148\190"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103.75, 18.25)
    }
  }
}

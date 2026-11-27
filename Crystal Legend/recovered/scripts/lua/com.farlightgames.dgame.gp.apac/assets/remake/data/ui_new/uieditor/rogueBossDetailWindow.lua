ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueBossDetailWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 511, h = 347.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/main/main_book_boss_skill.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(472, 262)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(75, 75)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_boss_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(37.5, 249.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_boss_name",
      z = 0,
      parent = "image_bg",
      text = T("\229\144\141\231\167\176\228\186\148\228\184\170\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(190, 306.25)
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
      name = "label_boss_desc",
      z = 0,
      parent = "image_bg",
      text = T("BOSS\230\143\143\232\191\176"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(127, 289.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(435, 85)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_skill_icon_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(38, 148.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_skill_name",
      z = 0,
      parent = "image_bg",
      text = T("\230\138\128\232\131\189\229\144\141\231\167\176"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(57.5, 123.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 75)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_skill_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(56.5, 36.25)
    }
  }
}

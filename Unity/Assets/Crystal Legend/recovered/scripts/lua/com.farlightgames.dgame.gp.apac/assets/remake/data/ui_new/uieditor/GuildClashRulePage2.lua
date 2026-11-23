ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashRulePage2 = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(700, 430)
    },
    t = "Layer",
    base = {name = "panel_rule", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(135, 74, 44),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tips",
      z = 0,
      parent = "panel_rule",
      text = T("\230\175\143\232\189\174\230\175\148\232\181\155\229\145\168\230\156\159\228\184\186\228\184\128\229\145\168"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(345.5, 416.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 754.5, h = 489.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_rule",
      res = "UI/alpha/1080P/guild/guild_gamedec/dec02.png",
      name = "ImageView_10883",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(347, 228.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 126, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_rule",
      res = "UI/alpha/1080P/guild/guild_gamedec/littletitle.png",
      name = "ImageView_10893",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(349.5, 387.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(135, 74, 11),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_num_1",
      z = 0,
      parent = "ImageView_10883",
      text = "01",
      size = 45
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.75, 386.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 269.5, h = 255},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_10883",
      res = "UI/alpha/1080P/guild/guild_gamedec/girl2.png",
      name = "ImageView_10890",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(574.75, 175.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(239, 209, 175),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_little_title",
      z = 0,
      parent = "ImageView_10893",
      text = T("\230\175\148\232\181\155\233\152\182\230\174\181"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 15)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 45)
    },
    t = "Layer",
    base = {
      parent = "ImageView_10890",
      name = "panel_desc_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9.75, 5.5)
    }
  }
}

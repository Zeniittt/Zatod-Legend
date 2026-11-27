ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashRulePage4 = {
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 754.5, h = 489.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_rule",
      res = "UI/alpha/1080P/guild/guild_gamedec/dec04.png",
      name = "ImageView_10883",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(349, 229)
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
      text = "03",
      size = 45
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62.75, 415.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 334.5, h = 232},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_10883",
      res = "UI/alpha/1080P/guild/guild_gamedec/girl4.png",
      name = "ImageView_10890",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(434.75, 318.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 389, h = 191},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_10883",
      res = "UI/alpha/1080P/guild/guild_gamedec/girl5.png",
      name = "ImageView_10891",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(262.25, 121.25)
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
      name = "label_num_2",
      z = 0,
      parent = "ImageView_10883",
      text = "04",
      size = 45
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(669.25, 187.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(310, 50)
    },
    t = "Layer",
    base = {
      parent = "ImageView_10890",
      name = "panel_desc_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12.25, 174.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(215, 50)
    },
    t = "Layer",
    base = {
      parent = "ImageView_10891",
      name = "panel_desc_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9.5, 106.5)
    }
  }
}

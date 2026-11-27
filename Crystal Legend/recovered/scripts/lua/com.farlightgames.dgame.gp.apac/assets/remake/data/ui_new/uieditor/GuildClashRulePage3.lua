ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashRulePage3 = {
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
      res = "UI/alpha/1080P/guild/guild_gamedec/dec03.png",
      name = "ImageView_10883",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(348.5, 229)
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
      text = "02",
      size = 45
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.25, 415.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 459.5, h = 202},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_10883",
      res = "UI/alpha/1080P/guild/guild_gamedec/girl3.png",
      name = "ImageView_10890",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(484.25, 138.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(265, 50)
    },
    t = "Layer",
    base = {
      parent = "ImageView_10890",
      name = "panel_desc_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9.25, 8)
    }
  }
}

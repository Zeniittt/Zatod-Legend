ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashGameGuideWin = {
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
      res = "UI/alpha/1080P/guild/guild_gamedec/background.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477.5, 280.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(248, 219, 184),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\231\142\169\230\179\149\230\148\187\231\149\165"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(378.75, 469.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(700, 430)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(30.25, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 57.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "arrow_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(2.25, 244.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "arrow_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(752.25, 244.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(795, 490)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_touch_area",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-18.25, 1.25)
    }
  }
}

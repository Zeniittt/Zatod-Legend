ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashMemberActiveItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 646.5, h = 59.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_clash_report/clashreport_rolefloor.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(323, 29.5)
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
      name = "label_total_active",
      z = 0,
      parent = "image_bg",
      text = "4321",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(451.75, 29.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(136, 211, 94),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_today_active",
      z = 0,
      parent = "image_bg",
      text = "44",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(573.75, 29.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13.75, 7.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(155, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_name",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(73.25, 19.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(236, 103, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_job",
      z = 0,
      parent = "image_bg",
      text = T("\228\188\154\233\149\191"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(162.25, 50.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_gs",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(279.75, 18.25)
    }
  }
}

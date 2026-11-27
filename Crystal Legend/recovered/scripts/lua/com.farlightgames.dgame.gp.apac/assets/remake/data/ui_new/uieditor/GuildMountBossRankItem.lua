ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMountBossRankItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(290, 70)
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name",
      z = 0,
      parent = "bg",
      text = "Text Label",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145, 60)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_3.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31.5, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_3.png",
      name = "icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(88, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_3.png",
      name = "icon3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(144.5, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_3.png",
      name = "icon4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(201, 26)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_3.png",
      name = "icon5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(257.5, 25)
    }
  }
}

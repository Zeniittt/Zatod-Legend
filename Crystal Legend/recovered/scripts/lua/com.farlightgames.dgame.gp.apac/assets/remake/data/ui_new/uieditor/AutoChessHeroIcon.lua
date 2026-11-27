ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessHeroIcon = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.5, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chess/battle/tag_chess_1.png",
      name = "bg",
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
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.999991, h = 44.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_1.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.75, 32)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.0999927, h = 51.0999927},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/chess_equip_fream_2.png",
      name = "selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.75, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.399999917, x = 0.399999917},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11.199997676, h = 11.199997676},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "gold",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.25, 6)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 53),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "num",
      z = 0,
      parent = "bg",
      text = "5",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.75, 6)
    }
  }
}

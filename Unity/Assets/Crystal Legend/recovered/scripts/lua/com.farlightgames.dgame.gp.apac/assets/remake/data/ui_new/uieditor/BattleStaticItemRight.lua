ed.uieditor = ed.uieditor or {}
ed.uieditor.BattleStaticItemRight = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 230.5, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crusade/bar_data_bg.png",
      name = "bar_bg",
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
      fix_wh = {w = 230.5, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bar_bg",
      res = "UI/alpha/1080P/crusade/bar_enemy_data.png",
      name = "bar",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(230.75, 6.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(239, 235, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_num",
      z = 0,
      parent = "bar_bg",
      text = "100,000,000",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115.25, 22.25)
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
      parent = "bar_bg",
      name = "panel_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(260.75, 12.25)
    }
  }
}

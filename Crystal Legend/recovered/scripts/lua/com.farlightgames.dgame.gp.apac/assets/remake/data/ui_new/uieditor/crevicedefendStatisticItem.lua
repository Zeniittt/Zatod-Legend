ed.uieditor = ed.uieditor or {}
ed.uieditor.crevicedefendStatisticItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 636, h = 65.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crevicedefend/recommendteam1.png",
      name = "bg_img",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 249, 161),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_team",
      z = 0,
      parent = "bg_img",
      text = T("1\233\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32, 34.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(338, 65)
    },
    t = "Layer",
    base = {
      parent = "bg_img",
      name = "panel_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(87.5, 0.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage_des",
      z = 0,
      parent = "bg_img",
      text = T("\228\188\164\229\174\179"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(431.5, 34.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 249, 161),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage_num",
      z = 0,
      parent = "bg_img",
      text = "123",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(535.5, 32.75)
    }
  }
}

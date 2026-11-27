ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaKnockoutTeamItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 537.5, h = 100.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/knockout/knockout_myteam_1.png",
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
      parent = "bg",
      text = T("1\233\152\159"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66.75, 58.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 75)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(124.25, 14.25)
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
      name = "label_gs",
      z = 0,
      parent = "bg",
      text = T("\230\136\152\229\138\155\239\188\154123456"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66.75, 21.25)
    }
  }
}

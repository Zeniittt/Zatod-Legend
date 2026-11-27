ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaOppoTeamItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 472, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/selection/cuparena_selection_team_1.png",
      name = "bg_team",
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
      parent = "bg_team",
      text = T("1\233\152\159"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 60)
    },
    t = "Layer",
    base = {
      parent = "bg_team",
      name = "panel_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(124.5, 8)
    }
  }
}

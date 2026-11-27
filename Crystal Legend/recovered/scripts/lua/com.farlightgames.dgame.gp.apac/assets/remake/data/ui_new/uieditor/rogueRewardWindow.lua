ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueRewardWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 892, h = 283.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_pearlget_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(475, 331.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(700, 105)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(96, 41.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(900, 181)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_click_area",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(6, 7.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(148, 140, 181),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tips",
      z = 0,
      parent = "image_bg",
      text = T("\231\130\185\229\135\187\229\177\143\229\185\149\228\187\187\230\132\143\228\189\141\231\189\174\232\191\148\229\155\158"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(450, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 50)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(352, 175.25)
    }
  }
}

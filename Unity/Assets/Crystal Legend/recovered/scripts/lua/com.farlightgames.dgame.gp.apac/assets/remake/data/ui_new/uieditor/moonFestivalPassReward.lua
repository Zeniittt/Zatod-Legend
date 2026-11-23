ed.uieditor = ed.uieditor or {}
ed.uieditor.moonFestivalPassReward = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 118, h = 282.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/bunnyrace/br_pass/br_pass_icon.png",
      name = "reward_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(173.5, 248)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(565, 275.5)
    },
    t = "Layer",
    base = {
      name = "layer_pass_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(231.5, 110)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(128, 65, 27),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_pass_title_normal",
      z = 0,
      parent = "reward_title_bg",
      text = T("\231\145\158\231\178\189\230\130\160\231\132\182"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 262.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(118, 90, 4),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_pass_title_pay",
      z = 0,
      parent = "reward_title_bg",
      text = T("\231\178\189\233\159\181\233\148\166\231\168\139"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65, 111.75)
    }
  }
}

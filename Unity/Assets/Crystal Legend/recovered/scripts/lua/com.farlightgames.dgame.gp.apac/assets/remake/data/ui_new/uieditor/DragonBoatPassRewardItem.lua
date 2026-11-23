ed.uieditor = ed.uieditor or {}
ed.uieditor.DragonBoatPassRewardItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76, h = 275.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_pass/db_bg_reward_list.png",
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
      color = ccc3(255, 247, 216),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_level",
      z = 9,
      parent = "bg",
      text = T("1\231\186\167"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38, 256.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "icon_1",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(38, 181.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(67, 67)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "icon_2",
      z = 9
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(38, 62.75)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMountMainSceneRewardItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(37, 45)
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
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.99999784, h = 33.599997984},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/crusade_box_gold_closed.png",
      name = "fca",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guildmount/award_timesbackground.png",
      name = "bg_score",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18, 6)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "score",
      z = 0,
      parent = "bg_score",
      text = "2",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 8)
    }
  }
}

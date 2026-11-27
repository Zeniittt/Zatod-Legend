ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeDungeonBossRewardItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 477, h = 61.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/boss/boss_reward_unachieve_1.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 79, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/dungeon/boss/boss_reward_unachieve_2.png",
      name = "bg_prec",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83, 30.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 2, x = 2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/account_sifting_mark.png",
      name = "state",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(397, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(209, 50)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(134.5, 6.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "prec",
      z = 0,
      parent = "bg_prec",
      text = "25%",
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 13.5)
    }
  }
}

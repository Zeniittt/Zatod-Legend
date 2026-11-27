ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeDungeonBossReward = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 517, h = 336},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dungeon/boss/boss_reward_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 290)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 236, 128),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 0,
      parent = "bg",
      text = T("\232\191\155\229\186\166\229\165\150\229\138\177"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(258.5, 302.5)
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
      name = "sub_title",
      z = 0,
      parent = "bg",
      text = T("\233\166\150\230\172\161\230\140\145\230\136\152BOSS\232\190\190\229\136\176\229\175\185\229\186\148\232\191\155\229\186\166\229\144\142\232\142\183\229\190\151\229\165\150\229\138\177"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(258.5, 266)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 245, 164),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "tip",
      z = 0,
      parent = "bg",
      text = T("\229\189\147\229\137\141\230\156\128\233\171\152\230\140\145\230\136\152\232\191\155\229\186\166:"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(129.5, 235.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(87, 236, 80),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "percent",
      z = 0,
      parent = "bg",
      text = "75%",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(205.5, 235.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(480, 210)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(18.5, 10.5)
    }
  }
}

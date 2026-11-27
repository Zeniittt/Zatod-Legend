ed.uieditor = ed.uieditor or {}
ed.uieditor.arenaRewardItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 83)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(5, 5, 543, 77),
      res = "UI/alpha/1080P/crusade/bg_replay_item.png",
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
      color = ccc3(255, 215, 126),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "rank",
      z = 0,
      parent = "bg",
      text = T("\230\142\146\229\144\141:"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reward",
      z = 0,
      parent = "bg",
      text = T("\231\187\147\231\174\151\229\165\150\229\138\177\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(256, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "icon_diamond",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 56.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/icon/money_arenatoken_big.png",
      name = "icon_pvpcoin",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 26.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(195, 70)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_6912",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(347, 6.5)
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
      name = "label_diamond",
      z = 0,
      parent = "icon_diamond",
      text = "x27500",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(29, 14)
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
      name = "label_pvpcoin",
      z = 0,
      parent = "icon_pvpcoin",
      text = "x100",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.5, 12.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.exerciseStageCell = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 264.5, h = 430},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pool/pool_wanted_bg_ipad.png",
      name = "bg_ipad",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 255.5, h = 433},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pool/pool_wanted_1_ipad.png",
      name = "wanted_bg_ipad",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4.5, -1.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      size = 20,
      text = T("\229\165\179\230\173\166\231\165\158\231\154\132\229\175\185\229\134\179"),
      name = "name",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132, 307)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      size = 15,
      text = T("\228\184\187\232\166\129\229\165\150\229\138\177\233\162\132\232\167\136"),
      name = "reward_label",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131.5, 89.5)
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
      name = "rewardLayer",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(32, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 255.5, h = 358},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pool/pool_wanted_1.png",
      name = "wanted_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4.5, -2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 264.5, h = 354},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pool/pool_wanted_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  }
}

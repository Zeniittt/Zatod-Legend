ed.uieditor = ed.uieditor or {}
ed.uieditor.AbyssRewardItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 728.5, h = 80},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skilltower/abyss/abyss_rank_base_3.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(365, 40)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(207, 76.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(320.25, 2)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "Label_4679",
      z = 0,
      parent = "bg",
      text = "Text Label",
      size = 40
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(31.75, 42)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(740.5, 92)
    },
    t = "Scale9Sprite",
    base = {
      name = "mask",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/toparena/reward/reward_mygrade_bg01.png",
      capInsets = CCRectMake(20, 20, 20, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(364.25, 40)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 105, h = 41},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "mask",
      res = "UI/alpha/1080P/toparena/reward/reward_mygrade_bg02.png",
      name = "label_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(664.25, 46)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_my_rank",
      z = 0,
      parent = "label_bg",
      text = T("\230\136\145\231\154\132\230\142\146\229\144\141"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.5, 21)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.buyVitalityWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(536.5, 305.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 200, 25, 250),
      res = "UI/alpha/1080P/package/bg_normal.png",
      name = "bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(489, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(543, 310.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "frame",
      z = 2,
      parent = "bg",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_big.png",
      capInsets = CCRectMake(20, 20, 445.5, 273)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(268.25, 152.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 485.5, h = 54},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame",
      res = "UI/alpha/1080P/package/bg_tip_title.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(271.5, 275.75)
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
      name = "label_title",
      z = 0,
      parent = "bg_title",
      text = T("\232\161\165\229\133\133\228\189\147\229\138\155"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.75, 40)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(525, 245)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5.75, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(744, 408)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_2427",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  }
}

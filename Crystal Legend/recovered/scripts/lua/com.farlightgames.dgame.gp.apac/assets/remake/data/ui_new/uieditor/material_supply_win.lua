ed.uieditor = ed.uieditor or {}
ed.uieditor.material_supply_win = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(634, 310)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15, 15, 20, 20),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "bg_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(616.5, 302.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(610, 260)
    },
    t = "Layer",
    base = {
      parent = "bg_detail",
      name = "mid_layer",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(225, 35)
    },
    t = "Layer",
    base = {
      parent = "bg_detail",
      name = "layer_title",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(213, 274.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "line_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(188.5, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "line_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 17)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "layer_title",
      text = T("\232\161\165\229\133\133\230\157\144\230\150\153"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 17)
    }
  }
}

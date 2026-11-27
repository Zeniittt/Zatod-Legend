ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildManagerWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(585.5, 300)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 50, 350),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line2",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      capInsets = CCRectMake(33, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86.75, 269.5)
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
      name = "title",
      z = 1,
      parent = "bg",
      text = T("\229\133\172\228\188\154\232\174\190\231\189\174"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292.75, 273.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(149.5, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line1",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      capInsets = CCRectMake(33, 0, 1, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(497.75, 271.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 1.30000007},
      flip = "",
      opacity = 255,
      fix_wh = {w = 267.150014385, h = 28.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/package/bg_compose.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292.75, 272)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(571.25, 283.5)
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
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(540, 215)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(23.75, 29)
    }
  }
}

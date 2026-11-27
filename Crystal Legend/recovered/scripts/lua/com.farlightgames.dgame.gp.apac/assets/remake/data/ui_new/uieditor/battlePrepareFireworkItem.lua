ed.uieditor = ed.uieditor or {}
ed.uieditor.battlePrepareFireworkItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(654, 107)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(109.5, 37, 109.5, 37),
      res = "UI/alpha/1080P/herolist/bg_hero_normal.png",
      name = "image_bg",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 80)
    },
    t = "Layer",
    base = {name = "panel_item", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-306, -39.5)
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
      size = 18,
      text = T("\231\169\191\229\164\169\231\140\180"),
      name = "label_item_name",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-182.5, 28)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.5, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/package/selected.png",
      name = "image_select",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(307.5, 38)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(672, 125)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(27, 43, 27, 43),
      res = "UI/alpha/1080P/nianmonster/nian_pre_firework_frame.png",
      name = "image_select_frame",
      z = 1
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
      color = ccc3(107, 50, 36),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 15,
      text = T("\232\191\153\230\152\175\228\184\128\230\174\181\230\143\143\232\191\176"),
      name = "label_desc",
      z = 1
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(-209.5, 8.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(654, 107)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(13, 13, 13, 13),
      res = "UI/alpha/1080P/nianmonster/nian_pre_firework_shadow.png",
      name = "image_mask",
      z = 2
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
      color = ccc3(252, 121, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 18,
      text = T("\239\188\136\230\156\170\230\139\165\230\156\137\239\188\137"),
      name = "label_have",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-148.5, 28.5)
    }
  }
}

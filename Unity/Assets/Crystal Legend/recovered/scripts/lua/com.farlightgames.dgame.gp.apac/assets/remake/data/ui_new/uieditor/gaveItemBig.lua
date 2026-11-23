ed.uieditor = ed.uieditor or {}
ed.uieditor.gaveItemBig = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 931, h = 340},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/giveItem/giveitem_bj_1.png",
      name = "outClickLay",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 465.5, h = 123},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/giveItem/give_item_str.png",
      name = "ImageView_109",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 463)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(138, 88, 62),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 12,
      text = T("\231\130\185\229\135\187\229\177\143\229\185\149\228\187\187\230\132\143\228\189\141\231\189\174\232\191\148\229\155\158"),
      name = "Label_110",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478, 128.5)
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
      visible = false
    },
    t = "Label",
    base = {
      size = 12,
      text = T("\230\129\173\229\150\156\230\130\168\232\142\183\229\190\151\228\187\165\228\184\139\229\165\150\229\138\177:"),
      name = "Label_111",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478.5, 715.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(750, 283.5)
    },
    t = "Layer",
    base = {name = "lay_post", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(102.5, 135.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.chooseBoxItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 129, h = 146.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/hero/equip/equip_chest_item_bg.png",
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
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name",
      z = 0,
      parent = "bg",
      text = T("\233\129\147\229\133\183\229\144\141\231\167\176\229\177\133\228\184\173"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 58.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/equip_frame_mask.png",
      name = "mask",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 108.75)
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
      parent = "mask",
      res = "UI/alpha/1080P/package/selected.png",
      name = "ImageView_11845",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  }
}

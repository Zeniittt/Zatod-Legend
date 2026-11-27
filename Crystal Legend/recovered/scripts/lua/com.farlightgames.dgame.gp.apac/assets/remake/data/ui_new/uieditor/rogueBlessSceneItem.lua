ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueBlessSceneItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(924, 94)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(866, 31, 20, 31),
      res = "UI/alpha/1080P/rogue/bless/bless_bag_rank1.png",
      name = "image_bg",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(238, 204, 133),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 21,
      text = T("\231\136\177\228\185\139\229\144\187"),
      name = "label_name",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(165, 74.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(90, 90)
    },
    t = "Layer",
    base = {name = "panel_icon", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(755, 57.5)
    },
    t = "Layer",
    base = {name = "panel_desc", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(165, 4)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/bless/bless_bag_unlock_icon.png",
      name = "image_lock_tag",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 82)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(235, 202, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      size = 18,
      text = T("\227\128\144\229\183\178\229\188\186\229\140\150\227\128\145"),
      name = "label_reinforce",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(833, 76.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(605, 57.5)
    },
    t = "Layer",
    base = {
      name = "panel_desc_touch_area",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(164.5, 4)
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
      name = "label_lock",
      z = 0,
      parent = "image_lock_tag",
      text = T("\230\156\170\232\167\163\233\148\129"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 12.5)
    }
  }
}

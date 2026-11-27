ed.uieditor = ed.uieditor or {}
ed.uieditor.attr_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/package/new/equip_point.png",
      name = "ImageView_141_Copy3",
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
      color = ccc3(61, 48, 36),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_attr",
      z = 0,
      parent = "ImageView_141_Copy3",
      text = T("\230\153\186\229\138\155"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(18, 6)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 2,
      flip = "",
      color = ccc3(61, 48, 36),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_num",
      z = 0,
      parent = "ImageView_141_Copy3",
      text = "+12",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(226.5, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 0.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "ImageView_141_Copy3",
      res = "UI/alpha/1080P/package/seg_attr.png",
      name = "ImageView_145",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.5, -6.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(248, 26)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg",
      z = 0,
      parent = "ImageView_141_Copy3",
      res = "UI/alpha/1080P/package/new/equip_attribute_bg.png",
      capInsets = CCRectMake(16.5, 10, 16.5, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114, 5.5)
    }
  }
}

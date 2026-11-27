ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueRevelationCard = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 237.5, h = 356},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/bless/bless_echo_bg.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 194, h = 141},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/bless_the_tower_simple.png",
      name = "image_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.75, 274)
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
      name = "label_name",
      z = 0,
      parent = "image_bg",
      text = T("\229\144\175\231\164\186\229\144\141\231\167\176"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.75, 188)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(191.5, 127.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(23.75, 40.5)
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
      name = "label_bless_type",
      z = 1,
      parent = "image_bg",
      text = T("\229\161\148"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.75, 213.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(44, 28)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_bless_type_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/bless_name_bg_4.png",
      capInsets = CCRectMake(14.5, 9, 14.5, 9)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.75, 214)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.HeroPackageMainWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(875, 468)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(40, 40, 0.5, 200),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "bg",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(43, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(758.5, 435)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13.5, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(171, 496.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(82.5, 435)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(780.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 3.5, h = 450},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_btn",
      res = "UI/alpha/1080P/herolist/splitline.png",
      name = "line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(-4, 438)
    }
  }
}

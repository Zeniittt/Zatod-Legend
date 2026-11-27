ed.uieditor = ed.uieditor or {}
ed.uieditor.summonRulePop = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(600, 336)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 10),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "Image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480.5, 279.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 350)
    },
    t = "Layer",
    base = {
      name = "panel_touch",
      z = 99
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(157, 105)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Image_bg",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "ImageView_692",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205.5, 309.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Image_bg",
      res = "UI/alpha/1080P/common/line_2b.png",
      name = "ImageView_692_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(403, 309)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
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
      parent = "Image_bg",
      text = T("\232\167\132\229\136\153\232\175\180\230\152\142"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(301.5, 311.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 57.5, h = 49.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_touch",
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "arrow_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23, 177.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 49.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "panel_touch",
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "arrow_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(623, 177.5)
    }
  }
}

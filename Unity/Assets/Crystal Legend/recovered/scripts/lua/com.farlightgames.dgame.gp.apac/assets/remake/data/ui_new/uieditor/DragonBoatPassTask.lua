ed.uieditor = ed.uieditor or {}
ed.uieditor.DragonBoatPassTask = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(680, 262)
    },
    t = "Layer",
    base = {name = "layer_task", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(158, 88.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 672.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/db_pass/db_bg_list_shadow.png",
      name = "img_shadow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(497.5, 99)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.moonFestivalPassTask = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(680, 272)
    },
    t = "Layer",
    base = {name = "layer_task", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(117, 112.5)
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
      res = "UI/alpha/1080P/bunnyrace/br_pass/br_pass_list_shadow.png",
      name = "img_shadow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(456.5, 123)
    }
  }
}

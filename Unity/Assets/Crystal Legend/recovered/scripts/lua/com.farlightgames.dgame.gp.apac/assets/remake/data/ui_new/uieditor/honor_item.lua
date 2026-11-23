ed.uieditor = ed.uieditor or {}
ed.uieditor.honor_item = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 100)
    },
    t = "Layer",
    base = {name = "node_item", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_item",
      res = "UI/alpha/1080P/honorwall/honorwall_hero_unchoose.png",
      name = "image_checkbox_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 18)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "node_item",
      name = "node_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(35, 75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_checkbox_bg",
      res = "UI/alpha/1080P/honorwall/honorwall_hero_choose.png",
      name = "image_checkbox",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.5, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.75, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_checkbox",
      res = "UI/alpha/1080P/package/selected.png",
      name = "ImageView_6444",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.5, 15.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.frame_item = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
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
      fix_wh = {w = 20.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_item",
      res = "UI/alpha/1080P/common/account_sifting_1.png",
      name = "image_checkbox_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.5, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "node_item",
      name = "node_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(25, 25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_checkbox_bg",
      res = "UI/alpha/1080P/common/account_sifting_2.png",
      name = "image_checkbox",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.25, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.5, h = 15},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_checkbox",
      res = "UI/alpha/1080P/common/account_sifting_mark.png",
      name = "ImageView_6444",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.25, 10.75)
    }
  }
}

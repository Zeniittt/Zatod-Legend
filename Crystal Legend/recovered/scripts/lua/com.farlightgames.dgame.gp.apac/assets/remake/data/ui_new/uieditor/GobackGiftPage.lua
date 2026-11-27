ed.uieditor = ed.uieditor or {}
ed.uieditor.GobackGiftPage = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/goback/goods/goback_goods_bg.jpg",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 305)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(400, 151.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 681.5, h = 132.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/goback/goods/goback_goods_title.png",
      name = "ImageView_4270",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(720, 515.5)
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
      name = "label_time",
      z = 0,
      parent = "bg",
      text = "Text Label",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(717.5, 474)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloAttrTip = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 175)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(90, 80, 8, 5),
      res = "UI/alpha/1080P/chesscard/tips/fream_1.png",
      name = "bg",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(175, 141)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12.5, 15.5)
    }
  }
}

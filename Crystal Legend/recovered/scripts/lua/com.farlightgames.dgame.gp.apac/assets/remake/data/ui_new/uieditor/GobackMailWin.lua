ed.uieditor = ed.uieditor or {}
ed.uieditor.GobackMailWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(597, 395)
    },
    t = "Layer",
    base = {
      name = "layer_outclick",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(177.5, 67)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 143.5, h = 134},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_outclick",
      res = "UI/alpha/1080P/goback/goback_once_reward.png",
      name = "btn_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(433, 91)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(249, 81, 100),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_reward",
      z = 0,
      parent = "btn_reward",
      text = T("\233\162\134\229\143\150\229\165\150\229\138\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.75, 12.5)
    }
  }
}

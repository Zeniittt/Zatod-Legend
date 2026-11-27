ed.uieditor = ed.uieditor or {}
ed.uieditor.RaidRankTitle = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1.4000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 571.2000408, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/raid/bottomstripe.png",
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
      size = 16,
      text = "title",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  }
}

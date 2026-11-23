ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessRankGradeIcon = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 146, h = 201},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/chess/season/6.png",
      name = "icon",
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
      name = "label",
      z = 0,
      parent = "icon",
      text = T("\229\155\189\231\142\139"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 47)
    }
  }
}

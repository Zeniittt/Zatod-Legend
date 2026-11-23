ed.uieditor = ed.uieditor or {}
ed.uieditor.SpineEditorAnimItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 121, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rankingscene/ranking_unselected_1.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 121, h = 28.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/rankingscene/ranking_selected_1.png",
      name = "selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.5, 14.25)
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
      name = "name",
      z = 0,
      parent = "bg",
      text = "COCO ATK1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.5, 14.25)
    }
  }
}

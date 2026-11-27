ed.uieditor = ed.uieditor or {}
ed.uieditor.awakeDungeonLevelUp = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(782, 270.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(260.5, 55, 260.5, 125),
      res = "UI/alpha/1080P/dungeon/dungeon_shade.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(480, 410.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 197.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(109, 30.5)
    }
  }
}

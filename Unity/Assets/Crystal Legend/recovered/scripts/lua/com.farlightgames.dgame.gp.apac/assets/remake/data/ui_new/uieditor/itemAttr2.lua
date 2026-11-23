ed.uieditor = ed.uieditor or {}
ed.uieditor.itemAttr2 = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(495, 35)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 0, 5, 35),
      res = "UI/alpha/1080P/hero/hero_upgrade_bg_4.png",
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
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "attrname",
      z = 0,
      parent = "bg",
      text = T("\229\138\155\233\135\143"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(35, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "attrnum",
      z = 0,
      parent = "bg",
      text = "12345678",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(478, 17.5)
    }
  }
}

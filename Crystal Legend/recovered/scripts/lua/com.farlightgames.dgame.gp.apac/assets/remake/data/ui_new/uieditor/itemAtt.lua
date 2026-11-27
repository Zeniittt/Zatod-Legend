ed.uieditor = ed.uieditor or {}
ed.uieditor.itemAtt = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(230, 27)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(18, 9, 3, 9),
      res = "UI/alpha/1080P/hero/equip/equip_prop_bg_1.png",
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
      text = T("\232\163\133\229\164\135\229\177\158\230\128\167"),
      name = "name",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-92.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 16,
      text = "+12345",
      name = "num",
      z = 1
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(105.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(230, 27)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(18, 9, 3, 9),
      res = "UI/alpha/1080P/hero/equip/equip_prop_bg_2.png",
      name = "bg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  }
}

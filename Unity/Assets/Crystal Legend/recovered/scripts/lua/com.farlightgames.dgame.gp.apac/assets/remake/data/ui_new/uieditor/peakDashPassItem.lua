ed.uieditor = ed.uieditor or {}
ed.uieditor.peakDashPassItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(110.5, 259.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(9, 10, 4.5, 10),
      res = "UI/alpha/1080P/fundpeak/select.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-10.5, -10.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 80)
    },
    t = "Layer",
    base = {
      name = "advanced_reward_icon",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4, 8.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 80)
    },
    t = "Layer",
    base = {
      name = "base_reward_icon",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4, 101)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 176, 22),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 18,
      text = "1000",
      name = "title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44, 213.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_fund_pass_item = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(88.5, 238.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(9, 10, 4.5, 10),
      res = "UI/alpha/1080P/fund/fund_bg1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(216, 168, 230),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 18,
      text = T("20\231\186\167"),
      name = "title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.5, 224)
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
      position = ccp(4, 120.5)
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
      position = ccp(4, 19.5)
    }
  }
}

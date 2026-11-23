ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaChooseCampWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(450, 480)
    },
    t = "Layer",
    base = {
      name = "panel_touch",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(255, 30)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(20, 20)
    },
    t = "Layer",
    base = {
      parent = "panel_touch",
      name = "panel_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(225, 240)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(491.5, 128)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_tip_bg",
      z = 0,
      parent = "panel_touch",
      res = "UI/alpha/1080P/cuparena/cuparena_signup_info_bg.png",
      capInsets = CCRectMake(10, 10, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(226.5, 56)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 240)
    },
    t = "Layer",
    base = {
      parent = "panel_bg",
      name = "panel_join",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-100, -148)
    }
  }
}

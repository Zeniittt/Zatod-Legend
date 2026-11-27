ed.uieditor = ed.uieditor or {}
ed.uieditor.SevenDayRewardItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.5, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/seven_day/seven_day_point_bg.png",
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
      fix_wh = {w = 6, h = 8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/seven_day/seven_day_bar_3.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.25, 22.75)
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
      name = "num",
      z = 0,
      parent = "bg",
      text = "5",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.75, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.66, x = 0.66},
      flip = "",
      opacity = 255,
      fix_wh = {w = 59.4, h = 59.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "icon_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.25, 60.75)
    }
  }
}

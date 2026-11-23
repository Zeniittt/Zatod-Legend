ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_calender = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 696.5, h = 464},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/calendar/activity_calendar.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(482, 257)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(660, 360)
    },
    t = "Layer",
    base = {name = "date_list", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(153, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.4, h = 26.4},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "close_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(796.5, 452)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(660, 314.5)
    },
    t = "Layer",
    base = {
      name = "banner_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(152.5, 45.5)
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
      size = 28,
      text = T("\230\180\187\229\138\168\230\151\165\229\142\134"),
      name = "label_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(483.5, 448)
    }
  }
}

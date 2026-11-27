ed.uieditor = ed.uieditor or {}
ed.uieditor.timeCorridorShopScene = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "bg", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 56},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_button_back.png",
      name = "back_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-31, 505)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 278, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_shop_text_bg_1.png",
      name = "left_time_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 495.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(850, 435)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_goods",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(56.5, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(249, 229, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time",
      z = 0,
      parent = "left_time_bg",
      text = T("\229\137\169\228\189\153 10\229\164\16910\229\176\143\230\151\182"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139, 14.75)
    }
  }
}

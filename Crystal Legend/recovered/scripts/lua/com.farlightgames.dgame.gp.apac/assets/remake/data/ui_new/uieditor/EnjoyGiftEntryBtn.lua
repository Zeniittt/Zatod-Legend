ed.uieditor = ed.uieditor or {}
ed.uieditor.EnjoyGiftEntryBtn = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 80)
    },
    t = "Layer",
    base = {name = "root", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-40, -40)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(71.5, 18.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "name_bg",
      z = 0,
      parent = "root",
      res = "UI/alpha/1080P/impulsegift/box_bg.png",
      capInsets = CCRectMake(10, 9, 10, 1)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(41, 34)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "root",
      res = "UI/alpha/1080P/impulsegift/box_red.png",
      name = "red_img",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66.5, 69.5)
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
      name = "red_num_txt",
      z = 0,
      parent = "root",
      text = "15",
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66.5, 70)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 216, 96),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name",
      z = 0,
      parent = "root",
      text = T("\233\153\144\230\151\182\231\164\188\229\140\133"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40.5, 25)
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
      name = "time_txt",
      z = 0,
      parent = "root",
      text = "01:20:35",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(10.5, 7)
    }
  }
}

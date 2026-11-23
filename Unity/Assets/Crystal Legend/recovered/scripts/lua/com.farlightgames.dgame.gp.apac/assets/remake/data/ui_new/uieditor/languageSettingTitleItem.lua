ed.uieditor = ed.uieditor or {}
ed.uieditor.languageSettingTitleItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(470, 40)
    },
    t = "Layer",
    base = {
      name = "panel_content",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-235, -22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 7.5, h = 7.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_content",
      res = "UI/alpha/1080P/common/global/language_icon.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 370, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_content",
      res = "UI/alpha/1080P/common/global/language_boundary.png",
      name = "line",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(251.5, 18)
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
      name = "label_des",
      z = 0,
      parent = "panel_content",
      text = T("\230\150\135\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38, 18)
    }
  }
}

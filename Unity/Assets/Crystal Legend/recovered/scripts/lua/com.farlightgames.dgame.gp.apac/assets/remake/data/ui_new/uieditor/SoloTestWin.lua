ed.uieditor = ed.uieditor or {}
ed.uieditor.SoloTestWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 92.399994456, h = 39.199997648},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/button_a_butt.png",
      name = "ImageView_6292",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(897, 120.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 92.399994456, h = 39.199997648},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/button_a_butt.png",
      name = "ImageView_6292_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(897, 66.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6293",
      z = 0,
      parent = "ImageView_6292",
      text = T("\230\136\152\230\150\151\232\176\131\232\175\1491"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.75, 24.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6293",
      z = 0,
      parent = "ImageView_6292_Copy0",
      text = T("\230\136\152\230\150\151\232\176\131\232\175\1492"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.75, 24.5)
    }
  }
}

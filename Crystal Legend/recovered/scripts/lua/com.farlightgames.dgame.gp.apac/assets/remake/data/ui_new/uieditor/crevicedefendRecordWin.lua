ed.uieditor = ed.uieditor or {}
ed.uieditor.crevicedefendRecordWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 697.05, h = 396},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crevicedefend/recommend_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477.5, 264.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(646.5, 323.5)
    },
    t = "Layer",
    base = {
      name = "panel_record",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(151, 82.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 172, h = 143.5},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crevicedefend/null.png",
      name = "img_empty",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(473, 272.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crevicedefend/recommend_close.png",
      name = "btn_close",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(810.5, 437)
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
      size = 10,
      text = "",
      name = "label_title",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(471.5, 435)
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
      name = "label_empty",
      z = 0,
      parent = "img_empty",
      text = T("\230\154\130\230\151\160\232\174\176\229\189\149"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85, 3.25)
    }
  }
}

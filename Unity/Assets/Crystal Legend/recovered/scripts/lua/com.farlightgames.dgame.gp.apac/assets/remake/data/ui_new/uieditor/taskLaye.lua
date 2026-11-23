ed.uieditor = ed.uieditor or {}
ed.uieditor.taskLaye = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(891.5, 543.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(150, 50, 550, 400),
      res = "UI/alpha/1080P/taskModel/task_pop_bg.png",
      name = "ImageView_23",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(460.5, 269.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(841.5, 460.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(100, 175, 600, 85),
      res = "UI/alpha/1080P/taskModel/task_pop_bg_2.png",
      name = "ImageView_23_Copy0",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(464.5, 270.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 422.5)
    },
    t = "Layer",
    base = {name = "btn_layer", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(862.5, 58.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "ui_layer", z = 7},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 45.9, h = 46.75},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_brak",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38, 509)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_brak",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "ImageView_74",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.5, 28)
    }
  }
}

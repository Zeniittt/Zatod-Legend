ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaTimelineCurItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 427.5, h = 71},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/cuparena_schedule_frame_1.png",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 110),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_des",
      z = 0,
      parent = "bg",
      text = T("\229\138\160\229\133\165\233\152\181\232\144\165"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(197.25, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 157.5, h = 75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/cuparena_schedule_dec_1.png",
      name = "img_tips",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.25, 36)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "bg",
      text = "2024-8-20",
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(100.75, 35.5)
    }
  }
}

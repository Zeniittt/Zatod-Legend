ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaTimelineItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 422, h = 65.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/cuparena_schedule_frame_2.png",
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
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_des",
      z = 0,
      parent = "bg",
      text = T("\230\183\152\230\177\176\232\181\155\229\188\128\229\167\139"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(194.5, 32.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.5, h = 43.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/cuparena_schedule_dec_2.png",
      name = "img_tips",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.5, 32.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(219, 246, 244),
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
      position = ccp(98, 32.75)
    }
  }
}

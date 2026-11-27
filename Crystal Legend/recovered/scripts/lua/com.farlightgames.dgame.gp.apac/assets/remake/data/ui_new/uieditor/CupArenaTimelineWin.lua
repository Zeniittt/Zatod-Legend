ed.uieditor = ed.uieditor or {}
ed.uieditor.CupArenaTimelineWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 920.5, h = 598},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/cuparena/cuparena_schedule_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(491.5, 265)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 138, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/cuparena_schedule_title_bg.png",
      name = "bg_des",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(460.25, 520)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/cuparena/cuparena_schedule_quit.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(787.75, 463.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(440, 300)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_timeline",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(246.25, 150.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 325, h = 394.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_timeline",
      res = "UI/alpha/1080P/cuparena/cuparena_schedule_dec_3.png",
      name = "ImageView_16892",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149.5, 127.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.exerciseDegreeCell = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 174, h = 62},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/pool/pool_stag_open_unchoose.png",
      name = "degree_btn",
      z = 0,
      text = "",
      press = "UI/alpha/1080P/pool/pool_stag_open_choose.png",
      size = 7
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 174, h = 62},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "degree_btn",
      res = "UI/alpha/1080P/pool/pool_stag_choose_frame.png",
      name = "selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "degree_btn",
      res = "UI/alpha/1080P/pool/difficulty/diff_lock_1.png",
      name = "degree_image",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46, 31.5)
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
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "degree_label",
      z = 0,
      parent = "degree_btn",
      text = T("\233\154\190\229\186\1661"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106, 31.5)
    }
  }
}

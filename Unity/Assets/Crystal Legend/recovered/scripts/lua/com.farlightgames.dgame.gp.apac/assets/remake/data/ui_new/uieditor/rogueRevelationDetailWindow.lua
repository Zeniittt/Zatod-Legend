ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueRevelationDetailWindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(486, 220)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(16.5, 16.5, 16.5, 16.5),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name",
      z = 0,
      parent = "image_bg",
      text = T("\229\144\175\231\164\186\229\144\141\231\167\176"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(25.5, 192.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_destiny",
      z = 0,
      parent = "image_bg",
      text = T("\231\154\135\229\184\157\231\154\132\229\144\175\231\164\186"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(443.5, 192.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1.60000014},
      flip = "",
      opacity = 255,
      fix_wh = {w = 442.40003871, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_boss_line.png",
      name = "line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(243, 172)
    }
  }
}

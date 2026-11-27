ed.uieditor = ed.uieditor or {}
ed.uieditor.forgingRecordItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 604.5, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/log/excel.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0.5)
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
      name = "item_type",
      z = 0,
      parent = "bg",
      text = T("\231\177\187\229\158\139\231\177\187\229\158\139\231\177\187\229\158\139\231\177\187\229\158\139\231\177\187\229\158\139"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(303.25, 17.75)
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
      name = "name",
      z = 0,
      parent = "bg",
      text = T("\229\144\141\231\167\176\229\144\141\231\167\176\229\144\141\231\167\176\229\144\141\231\167\176\229\144\141\231\167\176\229\144\141\231\167\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(497.75, 17.25)
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
      name = "time",
      z = 0,
      parent = "bg",
      text = T("\230\151\182\233\151\180\230\151\182\233\151\180\230\151\182\233\151\180\230\151\182\233\151\180\230\151\182\233\151\180\230\151\182\233\151\180"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111.75, 18.25)
    }
  }
}

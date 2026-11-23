ed.uieditor = ed.uieditor or {}
ed.uieditor.SkillTowerAbyssRecordSelfItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 728.5, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skilltower/abyss/abyss_record_frame.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(364, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 200, 83),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_des",
      z = 0,
      parent = "bg",
      text = T("\233\128\154\229\133\179\232\128\151\230\151\182\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(533.75, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 237, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "bg",
      text = "08:19:13",
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(543.25, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(330, 60)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_heroes",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(38.75, 12)
    }
  }
}

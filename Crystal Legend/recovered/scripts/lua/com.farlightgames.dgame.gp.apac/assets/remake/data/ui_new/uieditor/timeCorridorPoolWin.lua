ed.uieditor = ed.uieditor or {}
ed.uieditor.timeCorridorPoolWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 694, h = 453},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/timecorridor/timecorridor_pool_bg_1.png",
      name = "bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 280.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 51.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_button_close.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(711.5, 407)
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
      name = "label_title",
      z = 0,
      parent = "bg",
      text = T("\230\166\130\231\142\135\232\175\166\230\131\133"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(347, 382.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(108, 105, 124),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_tip",
      z = 0,
      parent = "bg",
      text = T("\229\144\140\231\177\187\229\165\150\229\138\177\232\142\183\229\190\151\231\154\132\230\166\130\231\142\135\229\157\135\231\173\137\239\188\140\230\166\130\231\142\135\232\175\166\230\131\133\228\184\141\229\140\133\230\139\172\229\133\141\232\180\185\229\141\149\230\172\161\232\191\189\229\175\187\227\128\130"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(347, 341)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(607, 294)
    },
    t = "Scale9Sprite",
    base = {
      name = "prob_panel",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_pool_bg_2.png",
      capInsets = CCRectMake(7.5, 7.5, 0.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(341, 179.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(602, 289)
    },
    t = "Layer",
    base = {
      parent = "prob_panel",
      name = "Panel_461",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(2.5, 2.5)
    }
  }
}

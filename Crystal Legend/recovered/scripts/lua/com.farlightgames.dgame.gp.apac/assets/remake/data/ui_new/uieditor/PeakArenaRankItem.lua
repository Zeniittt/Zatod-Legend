ed.uieditor = ed.uieditor or {}
ed.uieditor.PeakArenaRankItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 728.5, h = 80},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/toparena/rank/rank_bg_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(364, 40)
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
      name = "name",
      z = 0,
      parent = "bg",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(224.25, 52)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_server_name",
      z = 0,
      parent = "bg",
      text = T("3\229\140\186\229\183\168\233\190\153\229\174\136\230\138\164"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(224.25, 27)
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
      name = "label_1",
      z = 0,
      parent = "bg",
      text = T("\231\167\175\229\136\134:"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(589.75, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999833, x = 0.799999833},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107.999977455, h = 49.9999895625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/toparena/rank/toparena_rankname_1.png",
      name = "image_grade_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(472.25, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(44, 44)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(150, 15)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 42.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_score",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(612.75, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 50)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_rank",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(15.25, 15.5)
    }
  }
}

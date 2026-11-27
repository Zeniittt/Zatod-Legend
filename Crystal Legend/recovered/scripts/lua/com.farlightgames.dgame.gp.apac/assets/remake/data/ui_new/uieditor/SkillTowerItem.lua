ed.uieditor = ed.uieditor or {}
ed.uieditor.SkillTowerItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211, h = 403.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skilltower/main_tower_bg_2.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 187.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/small_title_tower1.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 99.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_num_floor",
      z = 0,
      parent = "bg",
      text = "27/30",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(179.5, 69.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_num_star",
      z = 0,
      parent = "bg",
      text = "50/90",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(178.5, 51.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_5022",
      z = 0,
      parent = "bg",
      text = T("\229\189\147\229\137\141\233\128\154\229\133\179\229\177\130\230\149\176"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.5, 69.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_5023",
      z = 0,
      parent = "bg",
      text = T("\229\189\147\229\137\141\230\148\182\233\155\134\230\152\159\230\149\176"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.5, 51.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 245, h = 409},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/skilltower/main_tower_frame_1.png",
      name = "frame",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.5, 201.75)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.hades_boss_detail = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 590.5, h = 378.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/hades/hades_boss_skill.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478, 271.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(222, 214, 129),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name",
      z = 0,
      parent = "bg",
      text = T("BOSS\229\144\141\229\173\151"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(174.75, 327.25)
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
      name = "desc",
      z = 0,
      parent = "bg",
      text = "Text Label",
      size = 15
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(174.75, 312.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(222, 214, 129),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "skillname",
      z = 0,
      parent = "bg",
      text = T("\230\138\128\232\131\189\229\144\141\231\167\176"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(106.75, 150.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 57.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "btn_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.75, 189.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57.5, h = 49.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/summon/summon_rule_arrow.png",
      name = "btn_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(580.25, 189.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(605, 350)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "click_area",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5.25, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(95.25, 270.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(398.5, 78)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_skill",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(111.75, 172.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 85)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_skill_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(106.75, 46.75)
    }
  }
}

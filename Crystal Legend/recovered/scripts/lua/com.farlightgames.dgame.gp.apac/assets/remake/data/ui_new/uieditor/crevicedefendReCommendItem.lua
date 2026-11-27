ed.uieditor = ed.uieditor or {}
ed.uieditor.crevicedefendReCommendItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 718.5, h = 85},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crevicedefend/recommend_list.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(359, 42.5)
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
      name = "label_name",
      z = 0,
      parent = "bg",
      text = T("\231\142\169\229\174\182\229\144\141\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(117.75, 56.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 235, 195),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_guild",
      z = 0,
      parent = "bg",
      text = T("\229\190\183\233\178\129\228\188\138\233\152\181\229\174\185"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(117.25, 28)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 194, 66),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage",
      z = 0,
      parent = "bg",
      text = T("\230\128\187\228\188\164\229\174\179"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(357.75, 54)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(239, 238, 228),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_damage_value",
      z = 0,
      parent = "bg",
      text = T("\229\190\183\233\178\129\228\188\138\233\152\181\232\144\165"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(357.75, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 127, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crevicedefend/recommend_button.png",
      name = "btn_click",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(588.25, 41)
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
      name = "label_gamble",
      z = 0,
      parent = "btn_click",
      text = T("\230\159\165\231\156\139\232\175\166\230\131\133"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.5, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "root_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(50.25, 19)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.crevicedefendRecordItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 656.5, h = 78},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/crevicedefend/battle_list.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0.5, 0)
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
      text = T("\230\128\187\228\188\164\229\174\179\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(47.25, 40)
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
      text = "",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124.25, 40.5)
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
      name = "label_day",
      z = 0,
      parent = "bg",
      text = T("\230\128\187\228\188\164\229\174\179"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(413.25, 40)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crevicedefend/battle_dps.png",
      name = "image_dps",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(218.25, 39.5)
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
      name = "btn_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(566.25, 39)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_guild",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(124.25, 40.5)
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
      parent = "btn_detail",
      text = T("\230\159\165\231\156\139\232\175\166\230\131\133"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(95, 19.25)
    }
  }
}

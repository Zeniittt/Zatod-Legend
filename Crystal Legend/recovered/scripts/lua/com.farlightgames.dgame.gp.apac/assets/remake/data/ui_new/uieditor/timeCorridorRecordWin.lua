ed.uieditor = ed.uieditor or {}
ed.uieditor.timeCorridorRecordWin = {
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
      position = ccp(711, 407)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 604.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/timecorridor/timecorridor_record_table_1.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(347.5, 306)
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
      text = T("\232\191\189\229\175\187\232\174\176\229\189\149"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(347, 381)
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
      name = "label_tip",
      z = 0,
      parent = "bg",
      text = T("\230\156\128\229\164\154\229\143\175\228\187\165\230\159\165\231\156\139200\230\157\161\232\174\176\229\189\149"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(347.5, 341)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(147, 134, 187),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_no_record",
      z = 0,
      parent = "bg",
      text = T("\230\130\168\232\191\152\230\178\161\230\156\137\232\191\189\229\175\187\232\174\176\229\189\149\229\147\166"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(349.5, 179)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(610, 255)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_record",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(43.5, 33)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_type",
      z = 0,
      parent = "title_bg",
      text = T("\231\177\187\229\158\139"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56.25, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name",
      z = 0,
      parent = "title_bg",
      text = T("\229\144\141\231\167\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(245.75, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 251, 232),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "title_bg",
      text = T("\230\151\182\233\151\180"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(494.75, 18.75)
    }
  }
}

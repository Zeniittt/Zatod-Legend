ed.uieditor = ed.uieditor or {}
ed.uieditor.forgingRecordWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(760, 426)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 19, 201.5),
      res = "UI/alpha/1080P/fireforge/log/board.png",
      name = "bg",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(98.5, 64)
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
      name = "title",
      z = 0,
      parent = "bg",
      text = T("\233\148\187\233\128\160\232\174\176\229\189\149"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(368.5, 397.5)
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
      name = "bottom_des",
      z = 0,
      parent = "bg",
      text = T("\229\143\175\228\187\165\230\159\165\231\156\139\230\156\128\232\191\145300\230\157\161\232\174\176\229\189\149"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(364, 35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 604.5, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/fireforge/log/excel_title.png",
      name = "title_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(374, 338)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(606.5, 267)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(71, 54)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 155.5, h = 151.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/fireforge/log/empty.png",
      name = "root_none",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(368.5, 188.5)
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
      parent = "title_record",
      text = T("\231\177\187\229\158\139"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(303.75, 18.5)
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
      parent = "title_record",
      text = T("\229\144\141\231\167\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(499.25, 18.5)
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
      parent = "title_record",
      text = T("\229\135\186\231\130\137\230\151\182\233\151\180"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(103.25, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(171, 171, 171),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_none",
      z = 0,
      parent = "root_none",
      text = T("\230\154\130\230\151\160\233\148\187\233\128\160\232\174\176\229\189\149\229\147\166~"),
      size = 26
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.75, 75.75)
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
      name = "desc",
      z = 0,
      parent = "bg",
      text = T("\232\135\170\228\184\138\230\172\161\233\148\187\233\128\160\229\135\186\229\148\175\228\184\128\232\163\133\229\164\135\228\187\165\230\157\165\239\188\140\229\183\178\231\180\175\232\174\161\233\148\187\233\128\160250\230\172\161"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(370.5, 370.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(677.5, 403)
    },
    t = "Layer",
    base = {name = "bg_click", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(140.5, 78.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.rightsSettingItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550.5, 72.5)
    },
    t = "Layer",
    base = {name = "item", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(556, 70)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg",
      z = 0,
      parent = "item",
      res = "UI/alpha/1080P/common/main_vit_tips.png",
      capInsets = CCRectMake(7.5, 7.5, 7.5, 7.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(276.5, 33.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(241, 193, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "right_name",
      z = 0,
      parent = "item",
      text = T("\230\157\131\233\153\144\229\144\141\229\173\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(9.5, 55.5)
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
      name = "right_desc",
      z = 0,
      parent = "item",
      text = T("\230\157\131\233\153\144\228\187\139\231\187\141"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(10.5, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(51, 255, 35),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "right_ok",
      z = 0,
      parent = "item",
      text = T("\229\183\178\229\188\128\229\144\175"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(500, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(79, 37),
      flip = "",
      labelConfig = {
        color = ccc3(235, 223, 207)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(7.5, -2.5, 7.5, 0.5),
      name = "right_no",
      z = 0,
      parent = "item",
      text = T("\229\137\141\229\190\128\232\174\190\231\189\174"),
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(502.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 66, 66),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_472",
      z = 0,
      parent = "right_no",
      text = T("\230\156\170\229\188\128\229\144\175"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 49)
    }
  }
}

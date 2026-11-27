ed.uieditor = ed.uieditor or {}
ed.uieditor.StoreMonthCardItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 281, h = 436.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newshop/monthcard_bg.png",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 253, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_time",
      z = 0,
      parent = "bg",
      text = T("\229\137\169\228\189\15328\229\164\169"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20.5, 273.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 130.5, h = 44.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/monthcard.png",
      name = "title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81, 382.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 281, h = 436.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/newshop/monthcard_bg2.png",
      name = "ImageView_415",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, 218.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(101.5, 40)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_buy",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(10, 10, 81, 22)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140.5, 51.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 139.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(17, 94.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_buy",
      z = 0,
      parent = "btn_buy",
      text = T("\194\16568.00"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_buy",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "icon_redLight",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(94.75, 33.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.GobackGiftItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 203, h = 287},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/goback/goods/goback_goods_card_2.png",
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
      fix_scale = {y = 0.9000001, x = 0.9000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.000009, h = 81.000009},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139.5, 126.5)
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
      name = "price",
      z = 0,
      parent = "bg",
      text = T("\229\133\141\232\180\185"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.5, 36)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 40)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "btn_go",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(28, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(87, 51, 13),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "tip",
      z = 0,
      parent = "bg",
      text = T("\233\153\144\232\180\1731\230\172\161"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.5, 73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.5, 202)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(87, 51, 13),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name",
      z = 0,
      parent = "bg",
      text = T("\229\155\158\229\189\146\231\137\185\230\157\1311"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.5, 259)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9000001, x = 0.9000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.000009, h = 81.000009},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139.5, 202)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9000001, x = 0.9000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.000009, h = 81.000009},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.5, 126.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(194.5, 278)
    },
    t = "Scale9Sprite",
    base = {
      name = "mask",
      z = 2,
      parent = "bg",
      res = "UI/alpha/1080P/goback/goods/goback_goods_sold_out.png",
      capInsets = CCRectMake(10, 10, 20, 20)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.5, 147.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.5, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "mask",
      res = "UI/alpha/1080P/common/common_mark.png",
      name = "mark1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.25, 193.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.5, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "mask",
      res = "UI/alpha/1080P/common/common_mark.png",
      name = "mark2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134.75, 193.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.5, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "mask",
      res = "UI/alpha/1080P/common/common_mark.png",
      name = "mark3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.25, 118.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.5, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "mask",
      res = "UI/alpha/1080P/common/common_mark.png",
      name = "mark4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134.75, 118.5)
    }
  }
}

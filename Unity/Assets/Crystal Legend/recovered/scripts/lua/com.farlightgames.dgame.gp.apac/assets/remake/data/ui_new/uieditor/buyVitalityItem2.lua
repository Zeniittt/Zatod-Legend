ed.uieditor = ed.uieditor or {}
ed.uieditor.buyVitalityItem2 = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(507.5, 84)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 29.5, 15, 29.5),
      res = "UI/alpha/1080P/scale9/box_bg.png",
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
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/frame/equip_frame_green.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.25, 42)
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
      name = "title",
      z = 0,
      parent = "bg",
      text = T("\228\189\147\229\138\155\229\164\167\233\184\161\232\133\191"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(89.75, 58.5)
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
      name = "desc",
      z = 0,
      parent = "bg",
      text = T("\229\143\175\228\187\165\232\161\165\229\133\13330\231\130\185\228\189\147\229\138\155"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(89.75, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(100, 40),
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(40, 15, 40, 15),
      name = "btn_use",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_big.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(447.25, 42)
    }
  },
  {
    config = {
      rotation = 0.737629652,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(33, 33)
    },
    t = "Scale9Sprite",
    base = {
      name = "minus_button",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/package/btn_package1.png",
      capInsets = CCRectMake(10, 10, 55, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(298.75, 42)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(32, 32)
    },
    t = "Scale9Sprite",
    base = {
      name = "add_button",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/package/btn_package1.png",
      capInsets = CCRectMake(10, 10, 55, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(374.25, 42)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(41.5, 28.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_number",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/package/bg_soldout.png",
      capInsets = CCRectMake(11, 5, 28, 35)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(337.25, 42)
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
      name = "label_use",
      z = 0,
      parent = "btn_use",
      text = T("\228\189\191 \231\148\168"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 21)
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
      name = "use_amount",
      z = 0,
      parent = "bg_number",
      text = "123",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.75, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19, h = 7.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "minus_button",
      res = "UI/alpha/1080P/common/buy_down.png",
      name = "ImageView_10565",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16.5, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "add_button",
      res = "UI/alpha/1080P/common/buy_add.png",
      name = "ImageView_10564",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16, 16)
    }
  }
}

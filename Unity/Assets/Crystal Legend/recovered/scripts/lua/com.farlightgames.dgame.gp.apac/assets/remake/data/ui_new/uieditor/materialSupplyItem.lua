ed.uieditor = ed.uieditor or {}
ed.uieditor.materialSupplyItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(194, 259)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 20, 20),
      res = "UI/alpha/1080P/skill/skill_bg_fastsupply.png",
      name = "bg_box_detail",
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
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "itemIcon",
      z = 0,
      parent = "bg_box_detail",
      text = T("\229\155\190\230\160\135"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 206.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(100, 40),
      flip = "",
      labelConfig = {
        color = ccc3(254, 241, 169)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/package/btn_package2.png",
      capInsets = CCRectMake(35, 16.5, 47.5, 17.5),
      name = "use_button",
      z = 0,
      parent = "bg_box_detail",
      text = T("\228\189\191\231\148\168"),
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97, 39)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(165, 40)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_number",
      z = 0,
      parent = "bg_box_detail",
      res = "UI/alpha/1080P/package/bg_soldout.png",
      capInsets = CCRectMake(5, 5, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95.5, 101)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 183.6, h = 140.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_box_detail",
      res = "UI/alpha/1080P/battle/battle_prepare_fa_3.png",
      name = "bg_hua",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(97, 185)
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
      name = "Label_name",
      z = 0,
      parent = "bg_box_detail",
      text = T("\230\138\128\232\131\189\232\191\155\233\152\182\231\159\179\233\128\137\230\139\169\231\174\177"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96, 148.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(42, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "minus_button",
      z = 0,
      parent = "bg_number",
      res = "UI/alpha/1080P/package/btn_package1.png",
      capInsets = CCRectMake(10, 10, 38.5, 16.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(18.5, 20)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(42, 42)
    },
    t = "Scale9Sprite",
    base = {
      name = "add_button",
      z = 0,
      parent = "bg_number",
      res = "UI/alpha/1080P/package/btn_package1.png",
      capInsets = CCRectMake(10, 10, 38.5, 16.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149.5, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(152, 132, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "use_amount_limit",
      z = 0,
      parent = "bg_number",
      text = "/123",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(81, 18.5)
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
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(80.5, 18.5)
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
      name = "Label_1014",
      z = 0,
      parent = "minus_button",
      text = "-",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 22.5)
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
      name = "Label_1015",
      z = 0,
      parent = "add_button",
      text = "+",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 22.5)
    }
  }
}

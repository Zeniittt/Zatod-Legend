ed.uieditor = ed.uieditor or {}
ed.uieditor.singleHeroPetInfoPanel = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(370, 116)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(300, 0, 0.5, 0.5),
      res = "UI/alpha/1080P/pet/pet_illustration_bottom.png",
      name = "bg",
      z = 0
    },
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
      scaleSize = CCSizeMake(10, 10)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(70, 58)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 30)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "master_label",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(176.5, 31)
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
      name = "pet_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(3, 70.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(40, 45.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "pet_name",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(148.5, 61.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 36.4},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pet_name",
      res = "UI/alpha/1080P/hero/hero_str.png",
      name = "pet_attr",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 197.5, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pet_name",
      res = "UI/alpha/1080P/pet/pet_name_bg_1.png",
      name = "ImageView_67414",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.5, 22)
    }
  }
}

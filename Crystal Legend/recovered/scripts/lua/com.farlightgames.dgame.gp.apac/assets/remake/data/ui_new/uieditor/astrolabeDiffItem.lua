ed.uieditor = ed.uieditor or {}
ed.uieditor.astrolabeDiffItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "contain", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 2.49999976},
      flip = "",
      opacity = 255,
      fix_wh = {w = 221.24997876, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "contain",
      res = "UI/alpha/1080P/astrolabe/astrolabe_attr_desc_bg_2.png",
      name = "ImageView_296",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116, 2.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.09999315, h = 31.49999475},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "contain",
      res = "UI/alpha/1080P/rogue/bless/bless_reinforce_arrow.png",
      name = "ImageView_294",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(254, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 2.49999976},
      flip = "",
      opacity = 255,
      fix_wh = {w = 221.24997876, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "contain",
      res = "UI/alpha/1080P/astrolabe/astrolabe_attr_desc_bg_2.png",
      name = "ImageView_296_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(394, 2.5)
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
      name = "name1",
      z = 0,
      parent = "contain",
      text = T("\230\156\128\231\187\136\231\137\169\231\144\134\228\188\164\229\174\179"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(3, 19.5)
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
      name = "num1",
      z = 0,
      parent = "contain",
      text = T("\230\156\128\231\187\136\231\137\169\231\144\134\228\188\164\229\174\179"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(231, 19.5)
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
      name = "name2",
      z = 0,
      parent = "contain",
      text = T("\230\156\128\231\187\136\231\137\169\231\144\134\228\188\164\229\174\179"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(280.5, 19.5)
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
      name = "num2",
      z = 0,
      parent = "contain",
      text = T("\230\156\128\231\187\136\231\137\169\231\144\134\228\188\164\229\174\179"),
      size = 16
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(509, 19.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.noticeWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 960, h = 399.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "installer/update_bg.png",
      name = "ImageView_634",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 274)
    },
    t = "Layer",
    base = {
      parent = "ImageView_634",
      name = "panel",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(155, 74.25)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(155, 52.5),
      flip = "",
      labelConfig = {
        color = ccc3(255, 230, 155)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "installer/login/button_com_mini.png",
      capInsets = CCRectMake(15, 3.5, 15, 15),
      name = "btn_ok",
      z = 0,
      parent = "ImageView_634",
      text = "",
      press = "installer/login/button_com_mini.png",
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 40.25)
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
      parent = "ImageView_634",
      name = "title_label",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 374.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_label",
      res = "installer/battle_prepare_lins_1.png",
      name = "ImageView_635",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_label",
      res = "installer/battle_prepare_lins_3.png",
      name = "ImageView_635_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-79, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 230, 155),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "button_label",
      z = 0,
      parent = "btn_ok",
      text = T("\230\156\149\231\159\165\233\129\147\228\186\134"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.5, 26.75)
    }
  }
}

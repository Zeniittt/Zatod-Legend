ed.uieditor = ed.uieditor or {}
ed.uieditor.pirateshopGoodsPop = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 675, h = 430.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/pirateshop/buy_menu.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(486, 270)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(134, 92, 64),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_354",
      z = 0,
      parent = "bg",
      text = T("\232\180\173\228\185\176\232\163\133\229\164\135"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(337, 394.25)
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
      name = "Label_name",
      z = 0,
      parent = "bg",
      text = T("\229\156\163\229\133\137"),
      size = 19
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(190, 351.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(104, 83, 73),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_txt",
      z = 0,
      parent = "bg",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(190, 321.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(106, 97, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_357",
      z = 0,
      parent = "bg",
      text = T("\230\140\129\230\156\137\239\188\154"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(536.5, 350.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(52, 83, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_count",
      z = 0,
      parent = "bg",
      text = "123",
      size = 13
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(553, 350.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 552.5, h = 2.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pirateshop/line.png",
      name = "ImageView_359",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(332.5, 247.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(104, 83, 73),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_360",
      z = 0,
      parent = "bg",
      text = T("\228\187\165\228\184\139\232\139\177\233\155\132\233\156\128\232\166\129\232\191\153\228\187\182\232\163\133\229\164\135"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(334.5, 248.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(534, 115)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(66.5, 115.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 153.599990784, h = 45.199997288},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/buttion_big.png",
      name = "btn_buy",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(336, 71.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      fix_wh = {w = 40.5, h = 41.25},
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
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(654, 414.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 512, h = 244},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pirateshop/buy_menu_blank.png",
      name = "ImageView_2405",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(337.5, 168.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_288",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
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
      name = "Label_2508",
      z = 0,
      parent = "ImageView_2405",
      text = T("\230\154\130\230\151\160\232\139\177\233\155\132\233\156\128\232\166\129\230\173\164\232\163\133\229\164\135\229\147\166~"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(256, 135.5)
    }
  }
}

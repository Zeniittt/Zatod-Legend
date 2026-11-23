ed.uieditor = ed.uieditor or {}
ed.uieditor.debugLogin = {
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
      name = "panel_debug",
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
      scaleSize = CCSizeMake(173, 52.5),
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
      name = "entergame",
      z = 0,
      parent = "panel_debug",
      text = T("\232\191\155\229\133\165\230\184\184\230\136\143"),
      press = "installer/login/button_com_mini.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(494, 267)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(173, 52.5),
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
      name = "setup",
      z = 0,
      parent = "panel_debug",
      text = T("\232\174\190  \231\189\174"),
      press = "installer/login/button_com_mini.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(494, 194.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      name = "panel_release",
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
      scaleSize = CCSizeMake(173, 52.5),
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
      name = "setradio",
      z = 0,
      parent = "panel_debug",
      text = T("\229\136\134\232\190\168\231\142\135\232\174\190\231\189\174"),
      press = "installer/serverselect_confirm_button_2.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(494, 121.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(173, 52.5),
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
      name = "closedebug",
      z = 0,
      parent = "panel_debug",
      text = T("\229\164\141\229\136\187\230\156\141\230\168\161\229\188\143"),
      press = "installer/serverselect_confirm_button_2.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(494, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.8, x = 1.9},
      fix_wh = {w = 225.15, h = 67.5},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "installer/serverselect_confirm_button_1.png",
      name = "uieditor",
      z = 0,
      parent = "panel_debug",
      text = T("\229\156\186\230\153\175\231\188\150\232\190\145"),
      press = "installer/serverselect_confirm_button_2.png",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(494, 99.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(188, 52.5),
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
      name = "btn_login",
      z = 0,
      parent = "panel_release",
      text = T("\231\153\187  \229\189\149"),
      press = "installer/login/button_com_mini.png",
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 122)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(188, 52.5),
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
      name = "opendebug",
      z = 0,
      parent = "panel_release",
      text = T("Debug\230\168\161\229\188\143"),
      press = "installer/login/button_com_mini.png",
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 52.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_126",
      z = 0,
      parent = "panel_release",
      res = "installer/login/input_bg.png",
      capInsets = CCRectMake(12.5, 12.5, 12.5, 12.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478.5, 275)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 52.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_126_Copy0",
      z = 0,
      parent = "panel_release",
      res = "installer/login/input_bg.png",
      capInsets = CCRectMake(12.5, 12.5, 12.5, 12.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478.5, 212)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_127",
      z = 0,
      parent = "ImageView_126",
      text = T("\232\180\166\229\143\183:"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(196.5, 30)
    },
    t = "Layer",
    base = {
      parent = "ImageView_126",
      name = "panel_box_account",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(91, 11.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_127",
      z = 0,
      parent = "ImageView_126_Copy0",
      text = T("\229\175\134\231\160\129:"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(43, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(196.5, 30)
    },
    t = "Layer",
    base = {
      parent = "ImageView_126_Copy0",
      name = "panel_box_password",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(91, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_debug",
      res = "installer/login/button_com_mini.png",
      name = "btn_language",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76.5, 496.5)
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
      name = "label_lan",
      z = 0,
      parent = "btn_language",
      text = T("\229\189\147\229\137\141\232\175\173\232\168\128\239\188\154cn"),
      size = 15,
      font = ed.fontBold
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
    }
  }
}

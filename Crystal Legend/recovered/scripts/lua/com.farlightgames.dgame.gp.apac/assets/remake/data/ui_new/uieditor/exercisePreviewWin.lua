ed.uieditor = ed.uieditor or {}
ed.uieditor.exercisePreviewWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(707.5, 436)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(40, 175, 21, 41),
      res = "UI/alpha/1080P/common/com_new_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 266)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 680, h = 444.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pool/pool_preview_bg_1.png",
      name = "tatoo",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(353.75, 218)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 338.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Thursday",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/pool/pool_preview_tattoo_deep.png",
      capInsets = CCRectMake(0, 30, 0.5, 11)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(353.75, 15)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(108, 386.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "select",
      z = 2,
      parent = "bg",
      res = "UI/alpha/1080P/pool/pool_preview_choose.png",
      capInsets = CCRectMake(0, 50, 0.5, 20.5)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(353.75, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(320, 32)
    },
    t = "Scale9Sprite",
    base = {
      name = "title_bg",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/package/bg_compose.png",
      capInsets = CCRectMake(100, 0, 5.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(353.75, 411.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 338.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Wednesday",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/pool/pool_preview_tattoo_light.png",
      capInsets = CCRectMake(0, 30, 0.5, 11)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(255.25, 15)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 338.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Tuesday",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/pool/pool_preview_tattoo_deep.png",
      capInsets = CCRectMake(0, 30, 0.5, 11)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(156.75, 15)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 338.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Monday",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/pool/pool_preview_tattoo_light.png",
      capInsets = CCRectMake(0, 30, 0.5, 11)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(58.35, 15)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 338.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Friday",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/pool/pool_preview_tattoo_light.png",
      capInsets = CCRectMake(0, 30, 0.5, 11)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(452.25, 15)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 338.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Saturday",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/pool/pool_preview_tattoo_deep.png",
      capInsets = CCRectMake(0, 30, 0.5, 11)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(550.75, 15)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 338.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Sunday",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/pool/pool_preview_tattoo_light.png",
      capInsets = CCRectMake(0, 30, 0.5, 11)
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(649.25, 15)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(0.35, 0.35)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "Panel_12909",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(687.25, 436)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 36.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Thursday_bg",
      z = 0,
      parent = "Thursday",
      res = "UI/alpha/1080P/pool/pool_preview_day.png",
      capInsets = CCRectMake(5, 0, 11, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.7, 358)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 338.5)
    },
    t = "Layer",
    base = {
      parent = "Thursday",
      name = "Thursday_layer",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "title_label",
      z = 0,
      parent = "title_bg",
      text = T("\230\156\170\230\157\165\233\162\132\232\168\128"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(160, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_bg",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      name = "left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-31, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title_bg",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      name = "right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(351, 16)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.65, 36.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Wednesday_bg",
      z = 0,
      parent = "Wednesday",
      res = "UI/alpha/1080P/pool/pool_preview_day.png",
      capInsets = CCRectMake(5, 0, 11, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.7, 358)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 338.5)
    },
    t = "Layer",
    base = {
      parent = "Wednesday",
      name = "Wednesday_layer",
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
      scaleSize = CCSizeMake(97.5, 36.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Tuesday_bg",
      z = 0,
      parent = "Tuesday",
      res = "UI/alpha/1080P/pool/pool_preview_day.png",
      capInsets = CCRectMake(5, 0, 11, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.6, 358)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 338.5)
    },
    t = "Layer",
    base = {
      parent = "Tuesday",
      name = "Tuesday_layer",
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
      scaleSize = CCSizeMake(97.5, 36.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Monday_bg",
      z = 0,
      parent = "Monday",
      res = "UI/alpha/1080P/pool/pool_preview_day.png",
      capInsets = CCRectMake(5, 0, 11, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.7, 358)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 338.5)
    },
    t = "Layer",
    base = {
      parent = "Monday",
      name = "Monday_layer",
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
      scaleSize = CCSizeMake(97.5, 36.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Friday_bg",
      z = 0,
      parent = "Friday",
      res = "UI/alpha/1080P/pool/pool_preview_day.png",
      capInsets = CCRectMake(5, 0, 11, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.7, 358)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 338.5)
    },
    t = "Layer",
    base = {
      parent = "Friday",
      name = "Friday_layer",
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
      scaleSize = CCSizeMake(97.5, 36.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Saturday_bg",
      z = 0,
      parent = "Saturday",
      res = "UI/alpha/1080P/pool/pool_preview_day.png",
      capInsets = CCRectMake(5, 0, 11, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.7, 358)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 338.5)
    },
    t = "Layer",
    base = {
      parent = "Saturday",
      name = "Saturday_layer",
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
      scaleSize = CCSizeMake(97.5, 36.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "Sunday_bg",
      z = 0,
      parent = "Sunday",
      res = "UI/alpha/1080P/pool/pool_preview_day.png",
      capInsets = CCRectMake(5, 0, 11, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.7, 358)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(97.5, 338.5)
    },
    t = "Layer",
    base = {
      parent = "Sunday",
      name = "Sunday_layer",
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
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 54, h = 55},
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
      name = "close_btn",
      z = 3,
      parent = "Panel_12909",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(6.5, -8)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "Thursday_label",
      z = 0,
      parent = "Thursday_bg",
      text = T("\230\152\159\230\156\159\229\155\155"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "Wednesday_label",
      z = 0,
      parent = "Wednesday_bg",
      text = T("\230\152\159\230\156\159\228\184\137"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "Tuesday_label",
      z = 0,
      parent = "Tuesday_bg",
      text = T("\230\152\159\230\156\159\228\186\140"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "Monday_label",
      z = 0,
      parent = "Monday_bg",
      text = T("\230\152\159\230\156\159\228\184\128"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "Friday_label",
      z = 0,
      parent = "Friday_bg",
      text = T("\230\152\159\230\156\159\228\186\148"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "Saturday_label",
      z = 0,
      parent = "Saturday_bg",
      text = T("\230\152\159\230\156\159\229\133\173"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 1,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 1,
      visible = true
    },
    t = "Label",
    base = {
      name = "Sunday_label",
      z = 0,
      parent = "Sunday_bg",
      text = T("\230\152\159\230\156\159\230\151\165"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.5, 18.25)
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
      parent = "close_btn",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  }
}

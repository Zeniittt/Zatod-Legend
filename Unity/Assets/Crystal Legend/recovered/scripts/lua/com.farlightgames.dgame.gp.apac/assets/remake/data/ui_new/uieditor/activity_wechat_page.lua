ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_wechat_page = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "page_lay", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/wechat_official/bg.jpg",
      name = "ImageView_27",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 410.5, h = 72},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/wechat_official/item_bg.png",
      name = "ImageView_3217",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(727, 144)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 251, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/wechat_official/code_bg.png",
      name = "ImageView_3219",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(727, 74)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_type",
      z = 0,
      parent = "ImageView_3217",
      text = T("\230\156\170\232\190\190\230\136\144"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(182.75, 49.5)
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
      parent = "ImageView_3217",
      name = "Panel_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(37.25, 36)
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
      parent = "ImageView_3217",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "goto_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(348.75, 36)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 209, 130),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3218",
      z = 0,
      parent = "ImageView_3217",
      text = T(""),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183.75, 20)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(159, 129, 114),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_3220",
      z = 0,
      parent = "ImageView_3219",
      text = T("\231\187\145\229\174\154\231\160\129:"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 209, 130),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_number",
      z = 0,
      parent = "ImageView_3219",
      text = "9638213",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(136, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.5, h = 41.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_3219",
      res = "UI/alpha/1080P/crusade/btn_challenge.png",
      name = "copy_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(231, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 232, 159),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_btn",
      z = 0,
      parent = "goto_btn",
      text = T("\229\137\141\229\190\128"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 2, x = 2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41, h = 43},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "copy_btn",
      res = "UI/alpha/1080P/setting/setting_code_copy.png",
      name = "ImageView_3223",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 41.25)
    }
  }
}

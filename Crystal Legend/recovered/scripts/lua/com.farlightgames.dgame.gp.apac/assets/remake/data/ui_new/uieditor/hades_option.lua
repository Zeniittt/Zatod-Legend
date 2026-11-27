ed.uieditor = ed.uieditor or {}
ed.uieditor.hades_option = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 468.5, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/hades/hades_boss_heat_active1.png",
      name = "image_bg",
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
      color = ccc3(255, 198, 163),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_option_name",
      z = 0,
      parent = "image_bg",
      text = T("\232\161\128\232\132\137\232\167\137\233\134\146"),
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(37.25, 29.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 68, h = 67},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_hot.png",
      name = "image_hot",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(147.25, 28)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 208, 152),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_heat_num",
      z = 0,
      parent = "image_bg",
      text = "1234",
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(193.75, 29)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 195, 254),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_desc",
      z = 0,
      parent = "image_bg",
      text = T("\228\189\191\231\148\168\229\156\163\229\160\130\233\162\157\229\164\150\232\142\183\229\190\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(375.75, 29)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(170.5, 48)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_num",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(291.25, 5.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.3999961, h = 23.3999961},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/buff/buff_doom.png",
      name = "image_buff_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.75, 29)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 50)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "layer_click_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4.75, 3.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 0,
      fix_wh = {w = 70, h = 69},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hades/hades_hot_highlight.png",
      name = "image_hot_highlight",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148.25, 27)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44, h = 46.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_num",
      res = "UI/alpha/1080P/hades/hades_boss_heat_down.png",
      name = "btn_minus",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44, h = 46.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_num",
      res = "UI/alpha/1080P/hades/hades_boss_heat_up.png",
      name = "btn_add",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(147, 22)
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
      name = "label_num",
      z = 0,
      parent = "panel_num",
      text = "+123456",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86, 23)
    }
  }
}

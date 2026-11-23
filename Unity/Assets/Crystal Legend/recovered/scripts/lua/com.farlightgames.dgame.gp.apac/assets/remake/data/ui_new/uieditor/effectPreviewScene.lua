ed.uieditor = ed.uieditor or {}
ed.uieditor.effectPreviewScene = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(275, 390)
    },
    t = "Layer",
    base = {name = "panel_list", z = 0},
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
      scaleSize = CCSizeMake(225, 55)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 16.5, 200, 16.5),
      res = "UI/alpha/1080P/guild/setup_rename_bg.png",
      name = "image_search_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(112.5, 450)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_search",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(250, 450)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_pause",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 500)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_next_frame",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(455, 500)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_speed",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(560, 500)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_reset",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(665, 450)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_review",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(350, 450)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(660, 390)
    },
    t = "Layer",
    base = {name = "panel_show", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(300, 0)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_scale",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(665, 499.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75, h = 75},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/fireforge/bless_board.png",
      name = "delete_area",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(903, 489)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_action",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(770, 500)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_pre_page",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(455, 450)
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
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_next_page",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(560, 450)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.5, x = 1.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_search",
      res = "UI/alpha/1080P/guild/seach_tab.png",
      name = "ImageView_24820",
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
      name = "label_pause",
      z = 0,
      parent = "btn_pause",
      text = T("\230\154\130\229\129\156"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
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
      name = "label_path",
      z = 0,
      parent = "panel_list",
      text = "path:",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(40, 407.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 37.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_list",
      res = "UI/alpha/1080P/common/backbtn-disabled.png",
      name = "btn_up",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.5, 407.5)
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
      name = "label",
      z = 0,
      parent = "btn_next_frame",
      text = T("\228\184\139\228\184\128\229\184\167"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
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
      name = "label_speed",
      z = 0,
      parent = "btn_speed",
      text = T("x1\229\128\141\233\128\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
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
      name = "label",
      z = 0,
      parent = "btn_reset",
      text = T("\233\135\141\231\189\174\230\137\128\230\156\137"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
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
      name = "label_review",
      z = 0,
      parent = "btn_review",
      text = T("\229\191\171\233\128\159\233\162\132\232\167\136"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
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
      name = "label_scale",
      z = 0,
      parent = "btn_scale",
      text = T("x1\231\188\169\230\148\190"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
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
      parent = "delete_area",
      res = "UI/alpha/1080P/fireforge/break/abandon.png",
      name = "image_delete",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 37.5)
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
      name = "Label_24856",
      z = 0,
      parent = "delete_area",
      text = T("\230\139\150\229\136\176\230\173\164\229\164\132\229\136\160\233\153\164"),
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.5, 15)
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
      name = "label_action",
      z = 0,
      parent = "btn_action",
      text = T("\229\138\168\228\189\156\229\136\135\230\141\162"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
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
      name = "label_pre_page",
      z = 0,
      parent = "btn_pre_page",
      text = T("\228\184\138\228\184\128\233\161\181"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
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
      name = "label_next_page",
      z = 0,
      parent = "btn_next_page",
      text = T("\228\184\139\228\184\128\233\161\181"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
    }
  }
}

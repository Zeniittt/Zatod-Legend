ed.uieditor = ed.uieditor or {}
ed.uieditor.legend_equip_reset_confirm = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(434, 246)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(13, 13, 13, 13),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478, 283)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "image_title_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(323.5, 219)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "image_title_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 219)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\232\163\133\229\164\135\233\135\141\231\189\174"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(217, 221)
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
      name = "label_tips",
      z = 0,
      parent = "image_bg",
      text = T("\233\135\141\231\189\174\229\144\142\239\188\140\232\191\148\232\191\152\232\163\133\229\164\135\230\156\172\228\189\147\229\143\138\229\141\135\230\152\159\232\181\132\230\186\144"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(217, 193.5)
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
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_reset",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(216.5, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_confirm",
      z = 0,
      parent = "btn_reset",
      text = T("\233\135\141\231\189\174"),
      size = 17
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
      fix_wh = {w = 532, h = 72.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/fireforge/upboard.png",
      name = "image_reset_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(217, 132.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 171.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/legendequip/reset/board.png",
      name = "bg_bind",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(217, 72)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 60)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_result",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(258.5, 103)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(60, 60)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_source",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(84.5, 103)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.5, h = 19.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "img_to",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(217, 132)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(200, 75)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_reset",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(117, 9)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_23192",
      z = 0,
      parent = "bg_bind",
      text = T("\232\163\133\229\164\135\232\167\163\231\187\145\229\144\142\239\188\140\229\143\175\232\191\155\232\161\140\233\135\141\231\189\174"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85.75, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 57, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_reset",
      res = "UI/alpha/1080P/main/main_status_plus_icon_1.png",
      name = "btn_add_times",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(181.5, 62)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_times",
      z = 0,
      parent = "panel_reset",
      text = T("\230\156\172\229\145\168\229\137\169\228\189\153\230\172\161\230\149\176\239\188\1540/5"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(93.5, 62.5)
    }
  }
}

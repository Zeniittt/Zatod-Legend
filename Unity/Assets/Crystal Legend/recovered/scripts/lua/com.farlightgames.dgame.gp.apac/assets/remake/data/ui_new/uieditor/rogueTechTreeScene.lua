ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueTechTreeScene = {
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
      res = "UI/alpha/1080P/rogue/techtree/techtree_bg1.jpg",
      name = "image_bg",
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
      scaleSize = CCSizeMake(550, 480)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_tech_tree",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(116.5, 90)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 248.5, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/crusade/bg_title_crusade.png",
      name = "image_title_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(305, 595)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 122, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/techtree/techtree_point_bg.png",
      name = "image_tech_point_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(968.5, 596.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 300.5, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_title_bg",
      res = "UI/alpha/1080P/rogue/techtree/techtree_title_bg.png",
      name = "light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.25, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 218),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_title_bg",
      text = T("\230\132\159\230\130\159\231\172\148\232\174\176"),
      size = 29
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(108.25, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 136.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/techtree/techtree_bg2.png",
      name = "image_bg2",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 68.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 289, h = 38},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/techtree/techtree_name_bg.png",
      name = "image_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(892.5, 390)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.5, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_tech_point_bg",
      res = "UI/alpha/1080P/rogue/techtree/tech_point_2.png",
      name = "tech_point_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21.5, 14.5)
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
      name = "label_tech_point_amount",
      z = 0,
      parent = "image_tech_point_bg",
      text = "0",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(73, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 135)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(765, 230)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(207, 29)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_cost_point_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/techtree/techtree_point_bg.png",
      capInsets = CCRectMake(40.5, 9.5, 40.5, 9.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(892.5, 210.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 209, h = 54.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/bless_shop_buy.png",
      name = "btn_learn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(892.5, 161.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 280, h = 280},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/techtree/techtree_light.png",
      name = "image_icon_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(892.5, 503.5)
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
      name = "label_name",
      z = 0,
      parent = "image_name_bg",
      text = T("\230\149\176\229\128\188\230\143\144\229\141\135"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(144.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 304, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/techtree/techtree_line.png",
      name = "image_parting_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(713, 267.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 783, h = 659},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/techtree/techtree_dec.png",
      name = "image_dec",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(396, 329.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 420, h = 127.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/techtree/techtree_learned_bg.png",
      name = "image_learned",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(892.5, 177)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.5, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_cost_point_bg",
      res = "UI/alpha/1080P/rogue/techtree/tech_point_2.png",
      name = "cost_point_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(84, 14.5)
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
      name = "label_cost_point_amount",
      z = 0,
      parent = "image_cost_point_bg",
      text = "0",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.5, 14.5)
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
      name = "label_learn",
      z = 0,
      parent = "btn_learn",
      text = T("\233\162\134 \230\130\159"),
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.14, x = 1.14},
      flip = "",
      opacity = 255,
      fix_wh = {w = 114.57, h = 115.14},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_icon_bg",
      res = "UI/alpha/1080P/rogue/techtree/icon/Bless.png",
      name = "image_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(140, 140)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 236, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_learned",
      z = 0,
      parent = "image_learned",
      text = T("\229\183\178\233\162\134\230\130\159"),
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210, 63.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 260.1, h = 34.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/techtree/techtree_name_bg.png",
      name = "image_total_gs_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(595, 592.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19.8, h = 19.8},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_total_gs_bg",
      res = "UI/alpha/1080P/rogue/techtree/techtree_gs.png",
      name = "ImageView_7734",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 255, 218),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_gs_tips",
      z = 0,
      parent = "image_total_gs_bg",
      text = T("\230\128\187\230\136\152\229\138\155\239\188\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(95, 19)
    }
  }
}

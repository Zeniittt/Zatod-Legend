ed.uieditor = ed.uieditor or {}
ed.uieditor.add_honor_panel = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(535, 391)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 200),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "image_bg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(549, 266.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      fix_wh = {w = 43.2, h = 44},
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
      name = "btn_back",
      z = 3,
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(800.5, 448.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(137, 237)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 200),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "image_bg2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(213, 189.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(137, 153)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 200),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "image_bg3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(213, 385.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 523, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg1",
      res = "UI/alpha/1080P/honorwall/honorwall_choose_title_bg.png",
      name = "image_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(267.5, 371.5)
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
      name = "label_title",
      z = 1,
      parent = "image_bg1",
      text = T("\233\128\137\230\139\169\229\183\178\232\142\183\229\190\151\231\154\132\229\190\189\231\171\160"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(267.5, 373)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(510, 290.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg1",
      name = "node_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13, 64.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(120, 210)
    },
    t = "Layer",
    base = {
      parent = "image_bg2",
      name = "node_tab_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(8.5, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(255, 290.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg1",
      name = "node_frame_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13, 64.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(255, 290.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg1",
      name = "node_avatar_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(267.5, 64.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {
      parent = "image_bg3",
      name = "node_view",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(67.5, 65.5)
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
      name = "label_view_tip",
      z = 0,
      parent = "image_bg3",
      text = T("\233\162\132\232\167\136"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68.5, 130.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(101.5, 42),
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
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(10, 10, 12.5, 10),
      name = "btn_save_continue",
      z = 2,
      parent = "image_bg1",
      text = "",
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(463.5, 34)
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
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_7989",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(525, 55)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_8245",
      z = 0,
      parent = "image_bg1",
      res = "UI/alpha/1080P/honorwall/honorwall_hero_choose_bg.png",
      capInsets = CCRectMake(10, 10, 10, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(267.5, 35)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line_r",
      z = 0,
      parent = "image_bg1",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      capInsets = CCRectMake(20, 0, 40, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(271.5, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(500, 12)
    },
    t = "Scale9Sprite",
    base = {
      name = "line_l",
      z = 0,
      parent = "image_bg1",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      capInsets = CCRectMake(20, 0, 40, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(263.5, 62.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 6.75, h = 7.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg1",
      res = "UI/alpha/1080P/common/battle_star_lins.png",
      name = "ImageView_8254",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(267.5, 66)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 249, 173),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_8255",
      z = 1,
      parent = "btn_save_continue",
      text = T("\230\183\187\229\138\160"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(0, 0, 0),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_8255_Copy0",
      z = 0,
      parent = "btn_save_continue",
      text = T("\230\183\187\229\138\160"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 20)
    }
  }
}

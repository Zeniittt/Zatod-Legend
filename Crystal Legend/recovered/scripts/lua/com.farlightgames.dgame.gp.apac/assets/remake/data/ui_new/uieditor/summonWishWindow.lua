ed.uieditor = ed.uieditor or {}
ed.uieditor.summonWishWindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 485)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(150, 150, 150, 150),
      res = "UI/alpha/1080P/summon/wish_bg.png",
      name = "bg",
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
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {name = "temp", z = 0},
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
      fix_wh = {w = 652, h = 109},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summon/wish_title_bg.png",
      name = "title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 490)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 506.5, h = 466.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summon/screen_icon_bg.png",
      name = "left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(296.5, 274)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 50)
    },
    t = "Layer",
    base = {name = "top", z = 1},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(297.5, 430)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(346.5, 388)
    },
    t = "Layer",
    base = {name = "right", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(525, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(101, 39.5),
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
      normal = "UI/alpha/1080P/common/button_a_butt.png",
      capInsets = CCRectMake(15, 20, 58, 10.5),
      name = "btn_save",
      z = 0,
      parent = "left",
      text = T("\228\191\157\229\173\152"),
      press = "UI/alpha/1080P/common/button_a_butt.png",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(243.25, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 652, h = 109},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summon/wish_title_bg_global.png",
      name = "title_bg_global",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 490)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(275, 90)
    },
    t = "Layer",
    base = {
      parent = "left",
      name = "wish_heros_root",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(108.25, 173.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 246, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_img",
      z = 0,
      parent = "left",
      text = T("\229\183\178\233\128\137\229\144\141\229\141\149"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(245.25, 375.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "text_title",
      z = 0,
      parent = "right",
      text = T("\232\139\177\233\155\132\229\144\141\229\141\149"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(169.5, 371.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.5, h = 82},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wish_heros_root",
      res = "UI/alpha/1080P/summon/unknow_hero_bg.png",
      name = "item_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.5, h = 82},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wish_heros_root",
      res = "UI/alpha/1080P/summon/unknow_hero_bg.png",
      name = "item_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184, 45)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(350, 58.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "tab_bg",
      z = 0,
      parent = "right",
      res = "UI/alpha/1080P/summon/wish_bg2.png",
      capInsets = CCRectMake(15, 0.5, 15, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172, 30.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 36},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "wish_heros_root",
      res = "UI/alpha/1080P/summon/summon_list_add.png",
      name = "ImageView_844",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45.5, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 36},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "wish_heros_root",
      res = "UI/alpha/1080P/summon/summon_list_add.png",
      name = "ImageView_844_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135, 45.5)
    }
  },
  {
    config = {
      rotation = 0.2045765,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(127, 20.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "hero_list_title_bg",
      z = 0,
      parent = "right",
      res = "UI/alpha/1080P/scale9/scale9_1.png",
      capInsets = CCRectMake(45, 5, 45, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(169.5, 371.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 36},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "wish_heros_root",
      res = "UI/alpha/1080P/summon/summon_list_add.png",
      name = "ImageView_844_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(225.5, 45.5)
    }
  },
  {
    config = {
      rotation = 0.2045765,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(357, 285)
    },
    t = "Scale9Sprite",
    base = {
      name = "hero_list_bg",
      z = 0,
      parent = "right",
      res = "UI/alpha/1080P/summon/wish_bg4.png",
      capInsets = CCRectMake(5, 150, 5, 125)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172.5, 211)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 148),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_54",
      z = 0,
      parent = "title_bg_global",
      text = T("\232\174\184\230\132\191\229\141\149"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(326, 68.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 49, h = 50.5},
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
      normal = "UI/alpha/1080P/summon/tab_normal.png",
      name = "btn_1",
      z = 0,
      parent = "tab_bg",
      text = "",
      press = "UI/alpha/1080P/summon/tab_selected.png",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 49, h = 50.5},
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
      normal = "UI/alpha/1080P/summon/tab_normal.png",
      name = "btn_2",
      z = 0,
      parent = "tab_bg",
      text = "",
      press = "UI/alpha/1080P/summon/tab_selected.png",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 49, h = 50.5},
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
      normal = "UI/alpha/1080P/summon/tab_normal.png",
      name = "btn_3",
      z = 0,
      parent = "tab_bg",
      text = "",
      press = "UI/alpha/1080P/summon/tab_selected.png",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(208, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 49, h = 50.5},
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
      normal = "UI/alpha/1080P/summon/tab_normal.png",
      name = "btn_4",
      z = 0,
      parent = "tab_bg",
      text = "",
      press = "UI/alpha/1080P/summon/tab_selected.png",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(271.5, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_1",
      res = "UI/alpha/1080P/summon/tab_selected.png",
      name = "btn_selected_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_text_1",
      z = 1,
      parent = "btn_1",
      text = T("\229\133\168\233\131\168"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_text_2",
      z = 1,
      parent = "btn_2",
      text = T("\229\138\155"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_2",
      res = "UI/alpha/1080P/summon/tab_selected.png",
      name = "btn_selected_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_text_3",
      z = 1,
      parent = "btn_3",
      text = T("\230\153\186"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_3",
      res = "UI/alpha/1080P/summon/tab_selected.png",
      name = "btn_selected_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "btn_text_4",
      z = 1,
      parent = "btn_4",
      text = T("\230\149\143"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_4",
      res = "UI/alpha/1080P/summon/tab_selected.png",
      name = "btn_selected_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
    }
  }
}

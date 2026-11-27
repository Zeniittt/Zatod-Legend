ed.uieditor = ed.uieditor or {}
ed.uieditor.summonWishScene = {
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
      visible = false,
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
      position = ccp(480, 485)
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
      scaleSize = CCSizeMake(0.5, 0.5)
    },
    t = "Layer",
    base = {name = "top", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(307, 469.5)
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
      text = T("\229\143\172\229\148\164"),
      press = "UI/alpha/1080P/common/button_a_butt.png",
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(243.25, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(638.5, 131)
    },
    t = "Scale9Sprite",
    base = {
      name = "wish_heros_bg",
      z = 0,
      parent = "left",
      res = "UI/alpha/1080P/summon/wish_text_bg.png",
      capInsets = CCRectMake(200, 0.5, 200, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(241.25, 203.25)
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
      position = ccp(170, 371)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 236.5, h = 168},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wish_heros_bg",
      res = "UI/alpha/1080P/package/bg_deso.png",
      name = "ImageView_66",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(321.25, 51.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 279.5, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wish_heros_bg",
      res = "UI/alpha/1080P/summon/decoration_parts.png",
      name = "decoration_part1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(320.75, 132)
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(275, 90)
    },
    t = "Layer",
    base = {
      parent = "wish_heros_bg",
      name = "wish_heros_root",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(186.25, 35.5)
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
      position = ccp(45, 45)
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
      position = ccp(134.5, 45)
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
      name = "item_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(225, 45)
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
      text = T("\229\133\168\233\131\168"),
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
      text = T("\229\138\155"),
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
      text = T("\230\153\186"),
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
      text = T("\230\149\143"),
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
  }
}

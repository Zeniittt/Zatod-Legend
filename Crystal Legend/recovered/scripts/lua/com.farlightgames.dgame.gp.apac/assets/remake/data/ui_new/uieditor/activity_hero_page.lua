ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_hero_page = {
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
      res = "UI/alpha/1080P/activity/hero_gift/hero_gift_bg.jpg",
      name = "ImageView_45",
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
      fix_wh = {w = 301, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/hero_gift/hero_gift_str_bg2.png",
      name = "ImageView_112",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(599, 367)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 600, h = 204},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "page_lay",
      res = "UI/alpha/1080P/activity/hero_gift/hero_gift_str_img.png",
      name = "ImageView_113",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(495, 428)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(450, 100)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_116",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(218, 60)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(236, 252, 254),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_114",
      z = 0,
      parent = "ImageView_112",
      text = T("\229\133\141\232\180\185\233\162\134\229\143\150 12\229\164\1696\230\151\182"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(154.5, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(425, 91)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_115",
      z = 0,
      parent = "Panel_116",
      res = "UI/alpha/1080P/activity/hero_gift/hero_gift_item_bg.png",
      capInsets = CCRectMake(25, 15, 12.5, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(214.5, 48.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 284, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_116",
      res = "UI/alpha/1080P/activity/hero_gift/hero_gift_str_bg.png",
      name = "ImageView_117",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(248, 75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_118",
      z = 0,
      parent = "Panel_116",
      text = T("\233\128\154\229\133\179\230\136\152\229\189\185\231\172\172\228\184\137\231\171\160\229\144\142\229\143\175\229\133\141\232\180\185\233\162\134\229\143\150"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(116.5, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(237, 151, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_118_Copy0",
      z = 0,
      parent = "Panel_116",
      text = T("\229\189\147\229\137\141\232\191\155\229\186\166\239\188\154\231\172\172\228\186\140\231\171\160"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(116.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 141),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_120",
      z = 0,
      parent = "Panel_116",
      text = T("\230\156\170\232\190\190\230\136\144"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(248.5, 75.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(125, 150)
    },
    t = "Layer",
    base = {
      parent = "page_lay",
      name = "Panel_hero",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(308, 159)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.2, h = 33.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_116",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_goto_stage",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(364, 30.5)
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
      name = "Label_386",
      z = 0,
      parent = "btn_goto_stage",
      text = T("\229\137\141\229\190\128"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.25, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 243, 141),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_386_Copy0",
      z = 0,
      parent = "btn_goto_stage",
      text = T("\229\137\141\229\190\128"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueDestinyChooseScene = {
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
      res = "UI/alpha/1080P/rogue/bless/destiny_choose_bg.jpg",
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
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_destiny_choose",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(105, 90)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 604.5, h = 98},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/destiny_detail.png",
      name = "image_tips_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 595)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 69, h = 54},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/destiny_choose_arrow.png",
      name = "image_left_arrow",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(130.5, 360)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 69, h = 54},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/destiny_choose_arrow.png",
      name = "image_right_arrow",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1037, 360)
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
      name = "btn_next",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(586, 137)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(1170, 434)
    },
    t = "Scale9Sprite",
    base = {
      name = "destiny_info_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/destiny_info_bg.png",
      capInsets = CCRectMake(35, 144.5, 35, 144.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 360)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.2, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95.5, 632.5)
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
      parent = "image_tips_bg",
      text = T("\233\128\137\230\139\169\228\184\128\229\188\160\229\161\148\231\189\151\239\188\140\230\143\173\231\164\186\228\189\160\229\156\168\230\149\133\228\186\139\228\184\173\231\154\132\229\145\189\232\191\144"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(302.25, 49)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(237.5, 356)
    },
    t = "Layer",
    base = {
      parent = "panel_destiny_choose",
      name = "panel_destiny_card",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(54.5, 95)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(595, 337.5)
    },
    t = "Layer",
    base = {
      parent = "panel_destiny_choose",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(309.5, 112)
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
      name = "label_next",
      z = 0,
      parent = "btn_next",
      text = T("\228\184\139\228\184\128\230\173\165"),
      size = 25
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(101.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37, h = 35.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/common/break_butt.png",
      name = "ImageView_51626",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  }
}

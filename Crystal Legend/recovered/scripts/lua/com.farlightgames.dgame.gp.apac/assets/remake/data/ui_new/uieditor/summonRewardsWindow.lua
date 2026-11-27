ed.uieditor = ed.uieditor or {}
ed.uieditor.summonRewardsWindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(989, 444)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(165, 150, 165, 150),
      res = "UI/alpha/1080P/summon/reward_bg_big.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 323)
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 230, 154),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 15,
      text = T("\230\136\144\229\138\159\232\180\173\228\185\176\231\187\143\233\170\140\232\141\175\232\134\143*10\239\188\140\232\181\160\233\128\129\239\188\154"),
      name = "reward_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478, 440.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(123.5, 49),
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
      name = "btn_summon",
      z = 0,
      capInsets = CCRectMake(35, 48, 35, 48),
      text = T("\229\143\172\229\148\164\229\141\129\230\172\161"),
      press = "UI/alpha/1080P/common/button_a_butt.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(337.5, 59.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 134, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/battle/battle_prepare_txt_bg.png",
      name = "ImageView_88",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(336.5, 99.5)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(123.5, 49),
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
      name = "btn_back",
      z = 0,
      capInsets = CCRectMake(35, 48, 35, 48),
      text = T("\232\191\148\229\155\158"),
      press = "UI/alpha/1080P/common/button_a_butt.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(612.5, 59.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(766, 280)
    },
    t = "Layer",
    base = {
      name = "panel_content",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(101.5, 138.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "Panel_357", z = 0},
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
      fix_wh = {w = 18.5, h = 23.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_88",
      res = "UI/alpha/1080P/icon/soulchest_ticket.png",
      name = "cost_res_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.5, 12.5)
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
      name = "cost_res_nun",
      z = 0,
      parent = "ImageView_88",
      text = "x10",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 117, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/summon/reward_text.png",
      name = "image_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(494.5, 375.5)
    }
  }
}

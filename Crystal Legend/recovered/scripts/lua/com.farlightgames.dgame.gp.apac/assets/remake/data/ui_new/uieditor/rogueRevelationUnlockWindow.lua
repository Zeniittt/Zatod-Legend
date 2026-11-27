ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueRevelationUnlockWindow = {
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
      res = "UI/alpha/1080P/rogue/bless/bless_choose_bg.png",
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
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 595)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(222, 213, 222),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_bat_tips",
      z = 1,
      parent = "image_bg",
      text = T("\232\175\166\231\187\134\230\143\143\232\191\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(972.5, 595.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/bless_shop_batchchoose_on.png",
      name = "btn_detail",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(907, 594.5)
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
      name = "btn_confirm",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 134.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(275, 355)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_card_bg",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(447.5, 187)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.5, h = 26.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_detail",
      res = "UI/alpha/1080P/rogue/bless/bless_shop_batchchoose_button1.png",
      name = "image_detail_switch",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10, 9.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(249, 249, 235),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_confirm",
      z = 0,
      parent = "btn_confirm",
      text = T("\231\161\174\229\174\154"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.5, 27.25)
    }
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueBlessScene = {
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
      res = "UI/alpha/1080P/rogue/bless/bless_shop_bg.jpg",
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
      position = ccp(287, 598)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(937.5, 400)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(115, 120)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(937.5, 50)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_btn_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(115, 520.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 35.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_amount_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/lottery/lottery_meat_bg.png",
      capInsets = CCRectMake(25, 12.5, 25, 12.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(995.5, 591)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 421.5, h = 219},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/bless_empty_bg.png",
      name = "image_empty_tips",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(585, 360)
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
      parent = "image_title_bg",
      res = "UI/alpha/1080P/dreamland/rule_butt_bj.png",
      name = "btn_rule",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(191.75, 17.75)
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
      name = "label_amount",
      z = 0,
      parent = "image_amount_bg",
      text = "88888",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(62, 17.75)
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
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(843, 591)
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
      name = "label_detail_tips",
      z = 0,
      parent = "image_bg",
      text = T("\232\175\166\231\187\134\230\143\143\232\191\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(908.5, 591)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_amount_bg",
      res = "UI/alpha/1080P/icon/pearl.png",
      name = "pearl_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 9, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_rule",
      res = "UI/alpha/1080P/common/rule_butt.png",
      name = "ImageView_27775",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.25, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(150, 119, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_empty_tips",
      z = 0,
      parent = "image_empty_tips",
      text = T("\230\154\130\230\156\170\232\142\183\229\190\151\230\156\172\229\145\189\232\191\144\231\165\157\231\166\143"),
      size = 27
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210.75, 109.5)
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
  }
}

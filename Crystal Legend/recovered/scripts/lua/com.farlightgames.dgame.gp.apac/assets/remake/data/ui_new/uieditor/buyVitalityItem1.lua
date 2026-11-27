ed.uieditor = ed.uieditor or {}
ed.uieditor.buyVitalityItem1 = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(507.5, 84)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 29.5, 15, 29.5),
      res = "UI/alpha/1080P/scale9/box_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
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
      name = "title",
      z = 0,
      parent = "bg",
      text = T("\228\189\147\229\138\155\229\164\167\233\184\161\232\133\191"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(89.75, 58.5)
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
      name = "desc",
      z = 0,
      parent = "bg",
      text = T("\229\143\175\228\187\165\232\161\165\229\133\13330\231\130\185\228\189\147\229\138\155"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(89.75, 24)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(100, 40),
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
      normal = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(40, 15, 40, 15),
      name = "btn_buy",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_big.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(447.25, 32)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 59, 56),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_times",
      z = 0,
      parent = "bg",
      text = T("\228\187\138\230\151\165\233\153\144\232\180\173  0/14"),
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(494.25, 66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63, h = 63},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/icon/vitality_icon.jpg",
      name = "ImageView_13691",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.25, 42)
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
      name = "label_buy",
      z = 0,
      parent = "btn_buy",
      text = T("\232\180\173\228\185\176"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.399998656, h = 22.399998656},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_buy",
      res = "UI/alpha/1080P/icon/diamond.png",
      name = "icon_diamond",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33.99999796, h = 35.99999784},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/activity/activity_buff/buy_vitality_discount.png",
      name = "buff_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(206.75, 58)
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
      name = "num",
      z = 0,
      parent = "btn_buy",
      text = "60",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30.5, 21)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_13691",
      res = "UI/alpha/1080P/common/frame/equip_frame_green.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(35, 35)
    }
  }
}

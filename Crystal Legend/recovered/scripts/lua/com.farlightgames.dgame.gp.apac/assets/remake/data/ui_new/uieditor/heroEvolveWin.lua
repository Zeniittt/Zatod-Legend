ed.uieditor = ed.uieditor or {}
ed.uieditor.heroEvolveWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(550, 370)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 25, 10, 25),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_2454",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(375, 339.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 0,
      parent = "bg",
      text = T("\232\139\177\233\155\132\229\141\135\230\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 340)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_2453",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175.5, 340)
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
      name = "desc",
      z = 0,
      parent = "bg",
      text = T("\228\184\173\230\142\146\230\179\149\229\184\136\239\188\140\228\189\191\231\148\168\233\187\145\230\154\151\231\154\132\229\183\171\230\156\175\230\157\128\228\188\164\229\175\185\230\137\139\239\188\140\232\135\170\232\186\171\230\139\165\230\156\137\229\188\186\229\164\167\231\154\132\231\187\173\232\136\170\232\131\189\229\138\155\227\128\130"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 306)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 519.5, h = 107.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_upgrade_hero_bg.png",
      name = "bg_heroicon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(264, 240)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 92.5, h = 39},
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
      normal = "UI/alpha/1080P/package/btn_package2.png",
      name = "btn_cancle",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175, 44)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 92.5, h = 39},
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
      normal = "UI/alpha/1080P/package/btn_package2.png",
      name = "btn_ok",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(375, 44)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(485, 35)
    },
    t = "Scale9Sprite",
    base = {
      name = "attr1",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_upgrade_bg_3.png",
      capInsets = CCRectMake(25, 0, 2.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 167)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(485, 35)
    },
    t = "Scale9Sprite",
    base = {
      name = "attr2",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_upgrade_bg_4.png",
      capInsets = CCRectMake(25, 0, 2.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 132)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_heroicon",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(167.75, 53.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81, h = 81},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_heroicon",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "icon2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(380.25, 53.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(485, 35)
    },
    t = "Scale9Sprite",
    base = {
      name = "attr3",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_upgrade_bg_3.png",
      capInsets = CCRectMake(25, 0, 5, 35)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(275, 97)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.5, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_heroicon",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(273.25, 53.25)
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
      name = "label_cancle",
      z = 0,
      parent = "btn_cancle",
      text = T("\229\143\150 \230\182\136"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 19.5)
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
      name = "label_ok",
      z = 0,
      parent = "btn_ok",
      text = T("\231\161\174 \232\174\164"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "attrname1",
      z = 0,
      parent = "attr1",
      text = T("\229\138\155\233\135\143\230\136\144\233\149\191"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "to1",
      z = 0,
      parent = "attr1",
      text = "1",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "from1",
      z = 0,
      parent = "attr1",
      text = "1",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.75, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "attr1",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "arrow1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "attrname2",
      z = 0,
      parent = "attr2",
      text = T("\230\153\186\229\138\155\230\136\144\233\149\191"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "to2",
      z = 0,
      parent = "attr2",
      text = "1",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "from2",
      z = 0,
      parent = "attr2",
      text = "12345",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.75, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "attr2",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "arrow2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "attrname3",
      z = 0,
      parent = "attr3",
      text = T("\230\149\143\230\141\183\230\136\144\233\149\191"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "to3",
      z = 0,
      parent = "attr3",
      text = "1",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(355, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "from3",
      z = 0,
      parent = "attr3",
      text = "12",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.5, 17.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 18.75, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "attr3",
      res = "UI/alpha/1080P/hero/hero_upgrade_arrow.png",
      name = "arrow3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.5, 17.5)
    }
  }
}

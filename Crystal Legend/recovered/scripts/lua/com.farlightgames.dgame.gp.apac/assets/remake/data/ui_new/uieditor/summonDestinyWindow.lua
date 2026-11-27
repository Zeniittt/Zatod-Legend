ed.uieditor = ed.uieditor or {}
ed.uieditor.summonDestinyWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 958, h = 545},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summondestiny/destiny_list_bg_2.png",
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
      name = "label_time",
      z = 0,
      parent = "bg",
      text = "Text Label",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 465)
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
      fix_wh = {w = 506.5, h = 451.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/summondestiny/destiny_list_bg_1.png",
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
      position = ccp(297.5, 469.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 395)
    },
    t = "Layer",
    base = {name = "layer_item", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(497, 50)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(101.5, 42),
      flip = "",
      labelConfig = {
        color = ccc3(254, 241, 169)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      capInsets = CCRectMake(15, 20, 58, 10.5),
      name = "btn_save",
      z = 0,
      parent = "left",
      text = T("\228\191\157 \229\173\152"),
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(243.25, 24.25)
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
      position = ccp(108.25, 165.75)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "label_tip",
      z = 0,
      parent = "left",
      text = "Text Label",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(143.25, 123.75)
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
      res = "UI/alpha/1080P/summondestiny/destiny_hero.png",
      name = "item_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135, 39)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29.599998224, h = 28.799998272},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "wish_heros_root",
      res = "UI/alpha/1080P/summondestiny/destiny_add.png",
      name = "ImageView_844_Copy0",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135, 40.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 221, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name",
      z = 2,
      parent = "wish_heros_root",
      text = T("\232\175\183\233\128\137\230\139\169\229\145\189\229\174\154\232\139\177\233\155\132"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134.5, -10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 121.5, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "wish_heros_root",
      res = "UI/alpha/1080P/summondestiny/destiny_soulstone_bg.png",
      name = "bg_stone",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.5, -30.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_stone",
      res = "UI/alpha/1080P/icon/herodetail_soulstone_icon.png",
      name = "icon_stone",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.75, 9.5)
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
      name = "Label_1802",
      z = 0,
      parent = "bg_stone",
      text = "100/100",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63.75, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 239, 247),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "bg",
      text = T("\230\156\172\229\145\168\231\131\173\231\130\185\232\139\177\233\155\132"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 496)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 228, 248),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_img",
      z = 0,
      parent = "left",
      text = T("\229\145\189\229\174\154\232\139\177\233\155\132"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(246.25, 267.25)
    }
  }
}

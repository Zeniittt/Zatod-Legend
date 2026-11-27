ed.uieditor = ed.uieditor or {}
ed.uieditor.heroUpLevelWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(407.5, 240)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(50, 128.5, 25, 150),
      res = "UI/alpha/1080P/package/bg_normal.png",
      name = "bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(489, 308.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(410, 242.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "frame",
      z = 2,
      parent = "bg",
      res = "UI/alpha/1080P/battle/battle_prepare_9bg_big.png",
      capInsets = CCRectMake(20, 200, 445.5, 200)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(203.75, 120)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 485.5, h = 54},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/package/bg_tip_title.png",
      name = "bg_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(203.75, 208.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(390, 84)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_main",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/scale9/box_bg.png",
      capInsets = CCRectMake(20, 29.5, 15, 29.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(203.75, 156)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 215.599987064, h = 91.99999448},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/hero/hero_upgrade_hero_tattoos.png",
      name = "bg_materials",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(203.75, 59)
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
      name = "Label_11098",
      z = 0,
      parent = "bg",
      text = T("\230\182\136\232\128\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(203.75, 94.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(398.25, 228)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(107, 97, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label_none",
      z = 0,
      parent = "bg",
      text = T("\228\184\141\230\187\161\232\182\179\229\141\135\231\186\167\230\157\161\228\187\182"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(203.75, 59)
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
      name = "label_title",
      z = 0,
      parent = "bg_title",
      text = T("\229\141\135 \231\186\167"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(242.75, 41)
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
      parent = "bg_main",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_3.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60, 42)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 101.5, h = 42},
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
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_use",
      z = 0,
      parent = "bg_main",
      text = "",
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(326, 43)
    }
  },
  {
    config = {
      rotation = 0.737629652,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(33, 33)
    },
    t = "Scale9Sprite",
    base = {
      name = "minus_button",
      z = 0,
      parent = "bg_main",
      res = "UI/alpha/1080P/package/btn_package1.png",
      capInsets = CCRectMake(10, 10, 55, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145, 42)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(32, 32)
    },
    t = "Scale9Sprite",
    base = {
      name = "add_button",
      z = 0,
      parent = "bg_main",
      res = "UI/alpha/1080P/package/btn_package1.png",
      capInsets = CCRectMake(10, 10, 55, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(245, 42)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(65, 32)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_number",
      z = 0,
      parent = "bg_main",
      res = "UI/alpha/1080P/package/bg_soldout.png",
      capInsets = CCRectMake(11, 5, 28, 35)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(195, 42)
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
      name = "Label_11100",
      z = 0,
      parent = "bg_main",
      text = T("\231\155\174\230\160\135\231\173\137\231\186\167"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(195, 70)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_materials",
      res = "UI/alpha/1080P/common/frame/equip_frame_green.png",
      name = "icon1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134.75, 43)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_2427",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
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
      name = "label_use",
      z = 0,
      parent = "btn_use",
      text = T("\228\189\191 \231\148\168"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19, h = 7.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "minus_button",
      res = "UI/alpha/1080P/common/buy_down.png",
      name = "ImageView_10565",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16.5, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 19, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "add_button",
      res = "UI/alpha/1080P/common/buy_add.png",
      name = "ImageView_10564",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16, 16)
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
      name = "use_amount",
      z = 0,
      parent = "bg_number",
      text = "123",
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102, h = 42},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_use",
      res = "UI/alpha/1080P/common/button_mini_grey.png",
      name = "btn_disable",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 21)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(199, 185, 199),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_12189",
      z = 0,
      parent = "btn_disable",
      text = T("\228\189\191\231\148\168"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51, 22)
    }
  }
}

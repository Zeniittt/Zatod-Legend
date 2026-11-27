ed.uieditor = ed.uieditor or {}
ed.uieditor.exchangeSoulPopWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 920, h = 501.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/soulexchange/soulexchange_bg2.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 290)
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
      name = "ImageView_4336",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(618, 444.25)
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
      res = "UI/alpha/1080P/common/battle_prepare_lins_3.png",
      name = "ImageView_4336_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(302, 443.75)
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
      name = "Label_4338",
      z = 0,
      parent = "bg",
      text = T("\233\128\137\230\139\169\232\139\177\233\155\132\230\187\161\230\152\159\229\144\142\230\186\162\229\135\186\231\154\132\231\129\181\233\173\130\231\159\179"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(460, 446.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(700, 221)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(110, 211.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(150, 163, 181),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4340",
      z = 0,
      parent = "bg",
      text = T("\228\184\128\230\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(161, 185.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(150, 163, 181),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4340_Copy0",
      z = 0,
      parent = "bg",
      text = T("\228\186\140\230\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(271, 185.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(150, 163, 181),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4340_Copy1",
      z = 0,
      parent = "bg",
      text = T("\228\184\137\230\152\159"),
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(377, 184.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/soulexchange/soulexchange_frame.png",
      name = "btn1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(181.5, 184.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/soulexchange/soulexchange_frame.png",
      name = "btn2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(292, 184.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/soulexchange/soulexchange_frame.png",
      name = "btn3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(399, 184.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 33.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/soulexchange/soulexchange_all_bg.png",
      name = "btn_all",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(756.5, 185.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.50000012, x = 1.50000012},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.50000252, h = 36.75000294},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/icon/herodetail_soulstone_icon.png",
      name = "ImageView_4351",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145.5, 118.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(175, 225, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_star1",
      z = 0,
      parent = "bg",
      text = T("1\230\152\159\230\149\176\233\135\143"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(222, 129.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(175, 225, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_star2",
      z = 0,
      parent = "bg",
      text = T("2\230\152\159\230\149\176\233\135\143"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(334, 129.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(175, 225, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_star3",
      z = 0,
      parent = "bg",
      text = T("3\230\152\159\230\149\176\233\135\143"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(450.5, 129.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.75, h = 23.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn1",
      res = "UI/alpha/1080P/common/common_mark.png",
      name = "tick1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn1",
      res = "UI/alpha/1080P/soulexchange/soulexchange_xx.png",
      name = "btn_unable1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(151, 216, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "num1",
      z = 0,
      parent = "bg",
      text = "0",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(222, 109.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(238, 149, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "num2",
      z = 0,
      parent = "bg",
      text = "0",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(336.5, 109.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.75, h = 23.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn2",
      res = "UI/alpha/1080P/common/common_mark.png",
      name = "tick2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn2",
      res = "UI/alpha/1080P/soulexchange/soulexchange_xx.png",
      name = "btn_unable2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 228, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "num3",
      z = 0,
      parent = "bg",
      text = "0",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(453.5, 109.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(147, 247, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_4359",
      z = 0,
      parent = "bg",
      text = T("\229\136\134\232\167\163\232\142\183\229\190\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(578, 118.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5, x = 0.5},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26.75, h = 23.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn3",
      res = "UI/alpha/1080P/common/common_mark.png",
      name = "tick3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27, h = 27},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn3",
      res = "UI/alpha/1080P/soulexchange/soulexchange_xx.png",
      name = "btn_unable3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.5, 13.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 97.3, h = 97.64998605},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/soulexchange/soulexchange_button.png",
      name = "btn_resolve",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(460, 47.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_token_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(667, 81.75)
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
      name = "label_all",
      z = 0,
      parent = "btn_all",
      text = T("\229\133\168\233\128\137"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(70, 70)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_token_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(740, 81.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(745, 414.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_click_area",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(88.5, 53.25)
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
    base = {
      parent = "bg",
      name = "panel_eff_resolve",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(460, 34.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 100)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_click_area2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(359.5, -9.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125, h = 153.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/soulexchange/soulexchange_soul.png",
      name = "image_empty",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(461, 324.75)
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
      name = "label_resolve",
      z = 0,
      parent = "btn_resolve",
      text = T("\231\134\148\231\130\188"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.5, 62.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(75, 88, 88),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_empty",
      z = 0,
      parent = "image_empty",
      text = T("\232\191\152\230\178\161\230\156\137\230\186\162\229\135\186\230\187\161\230\152\159\229\144\142\231\154\132\231\129\181\233\173\130\231\159\179\229\147\166~"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70, 62.75)
    }
  }
}

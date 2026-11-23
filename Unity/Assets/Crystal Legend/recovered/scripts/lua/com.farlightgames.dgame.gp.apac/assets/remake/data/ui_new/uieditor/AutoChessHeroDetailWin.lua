ed.uieditor = ed.uieditor or {}
ed.uieditor.AutoChessHeroDetailWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(232.5, 408.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 19.5, 200),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(763.5, 329.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15.5, 15.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "node_head",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(40, 374.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(336.5, 210)
    },
    t = "Scale9Sprite",
    base = {
      name = "pet_detail_bg",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      capInsets = CCRectMake(10, 10, 15, 200)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-167, 150.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 192, h = 56.5},
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
      normal = "UI/alpha/1080P/common/button_big_red.png",
      name = "btn_sell",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_big_red.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.5, 48.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(314, 125)
    },
    t = "Layer",
    base = {
      parent = "pet_detail_bg",
      name = "panel_pet_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(12.75, 12)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(53, 255, 5),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_pet_tip",
      z = 0,
      parent = "pet_detail_bg",
      text = T("\231\130\185\229\135\1871\228\184\170\228\191\161\228\189\191\232\163\133\229\164\135\231\187\153\232\139\177\233\155\132"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(169.25, 150.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(15.5, 15.5)
    },
    t = "Layer",
    base = {
      parent = "pet_detail_bg",
      name = "node_pet_info",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(22.25, 180)
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
      name = "label_sell_btn_desc",
      z = 0,
      parent = "btn_sell",
      text = T("\229\135\186\229\148\174\239\188\154"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 29.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.30000007, x = 1.30000007},
      flip = "",
      opacity = 255,
      fix_wh = {w = 36.40000196, h = 36.40000196},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_sell",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "img_gold_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 1},
      fix_wh = {w = 101.5, h = 37.8},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_pet_equip",
      z = 0,
      parent = "bg",
      text = "",
      press = "UI/alpha/1080P/common/button_com_mini.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-58, 29.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(252, 241, 201),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_pet_equip_desc",
      z = 0,
      parent = "node_pet_info",
      text = T("\228\191\161\228\189\191\230\138\128\232\131\189\230\143\143\232\191\176"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(-3, -7.5)
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
      name = "label_pet_name",
      z = 0,
      parent = "node_pet_info",
      text = T("\228\191\161\228\189\191\229\144\141\229\173\151"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-3, 6.5)
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
      name = "labe_btn_equip",
      z = 0,
      parent = "btn_pet_equip",
      text = T("\232\163\133\229\164\135"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22)
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
      name = "name",
      z = 0,
      parent = "bg",
      text = T("\232\139\177\233\155\132\229\144\141\229\173\151\229\133\173\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(82.5, 386.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 224, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/tag_tips_bg.png",
      name = "node_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.5, 332.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(215, 211.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_attr",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9, 103.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 53),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_price",
      z = 0,
      parent = "btn_sell",
      text = "+5",
      size = 30
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(137, 28.25)
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
      name = "label_pet_desc",
      z = 10,
      parent = "panel_attr",
      text = T("\228\191\161\228\189\191\230\143\143\232\191\176"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(60.5, 61)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_skill_desc",
      z = 0,
      parent = "panel_attr",
      text = T("\230\138\128\232\131\189\230\143\143\232\191\176"),
      size = 12
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(61, 133)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_attr",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon_skill",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 111.5)
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
      name = "label_equip_tip",
      z = 10,
      parent = "panel_attr",
      text = T("\230\154\130\230\156\170\232\163\133\229\164\135\233\129\147\229\133\183"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(120, 41)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.5, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/chess/battle/gold.png",
      name = "icon_gold",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(91, 363.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 26.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_4838",
      z = 0,
      parent = "panel_attr",
      res = "UI/alpha/1080P/chess/battle/tag_mask.png",
      capInsets = CCRectMake(10, 5, 10, 40)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(107.5, 193.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 26.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_4838_Copy0",
      z = 0,
      parent = "panel_attr",
      res = "UI/alpha/1080P/chess/battle/tag_mask.png",
      capInsets = CCRectMake(10, 5, 10, 40)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(107.5, 166)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.5999999, x = 0.5999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 53.999991, h = 53.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_attr",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "img_pet_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.5, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_4838",
      res = "UI/alpha/1080P/chess/battle/chess_hp.png",
      name = "img_attr_icon_hp",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_attr_hp",
      z = 2,
      parent = "ImageView_4838",
      text = "123456",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(37, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_attr_ad",
      z = 2,
      parent = "ImageView_4838",
      text = "123456",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(133, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 35},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_4838",
      res = "UI/alpha/1080P/chess/battle/chess_atk.png",
      name = "img_attr_icon_ad",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.5, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_attr_arm",
      z = 2,
      parent = "ImageView_4838_Copy0",
      text = "123456",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(37, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_4838_Copy0",
      res = "UI/alpha/1080P/chess/battle/chess_arm.png",
      name = "img_attr_icon_arm",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 232, 185),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_attr_crit",
      z = 2,
      parent = "ImageView_4838_Copy0",
      text = "123456",
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(133, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_4838_Copy0",
      res = "UI/alpha/1080P/chess/battle/chess_mr.png",
      name = "img_attr_icon_crit",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(116.5, 13.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 53),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "gold",
      z = 0,
      parent = "icon_gold",
      text = "5",
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.25, 16.5)
    }
  }
}

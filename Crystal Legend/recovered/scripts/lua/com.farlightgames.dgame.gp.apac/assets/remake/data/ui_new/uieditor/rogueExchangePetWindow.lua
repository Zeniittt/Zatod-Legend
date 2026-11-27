ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueExchangePetWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 933.5, h = 466},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/instance/instance_pet_frame_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 295)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 65.5, h = 78},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_pet_egg.png",
      name = "image_egg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0),
      position = ccp(456.75, 342)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63.5, h = 64},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_pet_frame_quit.png",
      name = "btn_close",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(832.75, 344)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(613, 116)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_item_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_pet_icon_bg.png",
      capInsets = CCRectMake(57.5, 38.5, 57.5, 38.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(471.75, 219.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 99.599994024, h = 40.399997576},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_use_vitality",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(538.25, 64.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 99.599994024, h = 40.399997576},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      name = "btn_use_item",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(394.25, 64.5)
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
      name = "image_vitality_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/lottery/lottery_meat_bg.png",
      capInsets = CCRectMake(25, 12.5, 25, 12.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(836.75, 451.5)
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
      name = "image_fish_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/lottery/lottery_meat_bg.png",
      capInsets = CCRectMake(25, 12.5, 25, 12.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(947.75, 451.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(717.5, 349.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_click_area",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(117.25, 35)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/com_line_center.png",
      name = "image_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(467.25, 95.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(266, 28.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_left_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_quit_time_bg.png",
      capInsets = CCRectMake(16.5, 10, 16.5, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(466.75, 144.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(172, 255, 91),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_end_tips",
      z = 0,
      parent = "image_bg",
      text = T("\230\140\145\230\136\152\231\187\147\230\157\159\229\137\141\229\143\175\233\154\143\230\151\182\229\134\179\229\174\154\230\152\175\229\144\166\233\162\134\229\143\150"),
      size = 19
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(468.25, 115)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(622, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(159.75, 279.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 80)
    },
    t = "Layer",
    base = {
      parent = "image_item_bg",
      name = "panel_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(189, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 233, 162),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_use_vitality",
      z = 0,
      parent = "btn_use_vitality",
      text = T("\228\189\191\231\148\168"),
      size = 20
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(61.75, 25.75)
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
      parent = "btn_use_vitality",
      res = "UI/alpha/1080P/rogue/main/rogue_vitality.png",
      name = "ImageView_52543",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95.75, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 233, 162),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_use_item",
      z = 0,
      parent = "btn_use_item",
      text = T("\228\189\191\231\148\168"),
      size = 20
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(61.75, 25.75)
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
      parent = "btn_use_item",
      res = "UI/alpha/1080P/icon/fish.png",
      name = "ImageView_52544",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95.75, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 233, 162),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_use_vitality_amount",
      z = 0,
      parent = "btn_use_vitality",
      text = "1",
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(69.75, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(240, 233, 162),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_use_item_amount",
      z = 0,
      parent = "btn_use_item",
      text = "1",
      size = 20
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(69.75, 25.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 107.5, h = 59.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_item_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_pet_arrow.png",
      name = "ImageView_67160",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(142.5, 57.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(90, 90)
    },
    t = "Layer",
    base = {
      parent = "image_item_bg",
      name = "panel_egg_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(17, 13)
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
      parent = "image_vitality_bg",
      res = "UI/alpha/1080P/rogue/main/rogue_vitality.png",
      name = "vitality_icon",
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
      name = "vitality_amount",
      z = 0,
      parent = "image_vitality_bg",
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
      fix_wh = {w = 23, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_fish_bg",
      res = "UI/alpha/1080P/icon/fish.png",
      name = "fish_icon",
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
      name = "fish_amount",
      z = 0,
      parent = "image_fish_bg",
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
      fix_wh = {w = 228, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_line",
      res = "UI/alpha/1080P/common/com_line_left.png",
      name = "ImageView_61008",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-113.75, 4.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 228, h = 1.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_line",
      res = "UI/alpha/1080P/common/com_line_left.png",
      name = "ImageView_61008_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.25, 4.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.5, h = 20.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_left_bg",
      res = "UI/alpha/1080P/rogue/instance/instance_time_icon2.png",
      name = "ImageView_53484",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time",
      z = 0,
      parent = "image_left_bg",
      text = "00:00:00",
      size = 18
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(133, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(157, 155, 145),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_left_time_tips",
      z = 0,
      parent = "image_left_bg",
      text = T("\229\144\142\230\140\145\230\136\152\231\187\147\230\157\159"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(135.5, 14.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_hatch_tips",
      z = 0,
      parent = "ImageView_67160",
      text = T("\229\143\175\229\173\181\229\140\150"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53.75, 29.75)
    }
  }
}

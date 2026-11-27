ed.uieditor = ed.uieditor or {}
ed.uieditor.package = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(554, 468)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(20, 20, 36.5, 310),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "main_frame",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(572.5, 245)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(525, 56.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_sub_tag",
      z = 2,
      parent = "main_frame",
      res = "UI/alpha/1080P/package/bg_sub_tag.png",
      capInsets = CCRectMake(16.5, 0.5, 0.5, 25)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(277, 38.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_sub_tag",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "left_deco",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 25.75)
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
      parent = "bg_sub_tag",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "right_deco",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(476, 25.75)
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
      parent = "main_frame",
      name = "layer_button",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(549.5, 238.5)
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
      parent = "bg_sub_tag",
      name = "layer_sub_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(262.5, 28.25)
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
      visible = false,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/package/btn_package2.png",
      name = "btn_quick_compose",
      z = 0,
      parent = "bg_sub_tag",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(262.5, 26.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(275, 468)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(25, 20, 50, 350),
      res = "UI/alpha/1080P/common/com_new_1.png",
      name = "bg_detail",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(163, 245)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 299, h = 313.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "main_frame",
      res = "UI/alpha/1080P/package/fox.png",
      name = "fox",
      z = 10
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(84, 194.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_button",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "btn_goods",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 170.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_sub_btn",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "tag3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.5, -2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_sub_btn",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "tag2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-27.5, -2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_button",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "btn_fragment",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 82)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_sub_btn",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "tag5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.5, -2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_sub_btn",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "tag1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-82.5, -2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 403, h = 61},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "main_frame",
      res = "UI/alpha/1080P/package/fox_tip.png",
      name = "fox_tip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(277, 236)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_button",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "btn_equipment",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, -7.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_sub_btn",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "tag4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(82.5, -2)
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
      name = "Label_56",
      z = 0,
      parent = "btn_quick_compose",
      text = T("\228\184\128\233\148\174\229\144\136\230\136\144"),
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 77)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_goods_selected",
      z = 3,
      parent = "btn_goods",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_4.png",
      capInsets = CCRectMake(10, 0, 50, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-6.75, 36.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "tag3",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "tag_selected3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_tag3",
      z = 1,
      parent = "tag3",
      text = T("\232\180\181\233\135\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_sub_btn",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_1.png",
      name = "tag0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-137.5, -2)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.5, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_goods",
      res = "UI/alpha/1080P/package/icon_item_unavailable.png",
      name = "icon_goods_unseclected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 45.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 64.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_button",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_1.png",
      name = "btn_stone",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, -97)
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
      name = "label_goods",
      z = 0,
      parent = "btn_goods",
      text = T("\233\129\147 \229\133\183"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 19.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "tag2",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "tag_selected2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_tag2",
      z = 1,
      parent = "tag2",
      text = T("\230\180\187\229\138\168"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 236.5, h = 168},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_detail",
      res = "UI/alpha/1080P/package/bg_deso.png",
      name = "deco_top",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(138, 378)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(80, 77)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_fragment_selected",
      z = 3,
      parent = "btn_fragment",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_4.png",
      capInsets = CCRectMake(10, 0, 50, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-6.75, 36.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "tag5",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "tag_selected5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38.5, h = 47},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_goods_selected",
      res = "UI/alpha/1080P/package/icon_item.png",
      name = "icon_goods_seclected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 46.5)
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
      name = "label_tag5",
      z = 1,
      parent = "tag5",
      text = T("\229\133\187\230\136\144"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_goods_selected",
      z = 0,
      parent = "btn_goods_selected",
      text = T("\233\129\147 \229\133\183"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42.5, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_fragment",
      res = "UI/alpha/1080P/package/icon_fragment_unavailable.png",
      name = "icon_fragment_unseclected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 44.25)
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
      name = "label_fragment",
      z = 0,
      parent = "btn_fragment",
      text = T("\231\162\142 \231\137\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 19.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "tag1",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "tag_selected1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_tag1",
      z = 1,
      parent = "tag1",
      text = T("\229\184\184\232\167\132"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 254.5, h = 63},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_detail",
      res = "UI/alpha/1080P/package/new/equip_tattoos.png",
      name = "deco_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.5, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(80, 77)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_equipment_selected",
      z = 3,
      parent = "btn_equipment",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_4.png",
      capInsets = CCRectMake(10, 0, 50, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-6.75, 36.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "tag4",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "tag_selected4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
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
      name = "label_tag4",
      z = 1,
      parent = "tag4",
      text = T("\229\164\150\232\167\130"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -43.5, h = 43.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_equipment",
      res = "UI/alpha/1080P/hero/icon_skin_unavailable.png",
      name = "icon_equipment_unseclected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 44.25)
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
      name = "label_equipment",
      z = 0,
      parent = "btn_equipment",
      text = T("\232\163\133 \229\164\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 19.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 49, h = 50.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "tag0",
      res = "UI/alpha/1080P/battle/battle_prepare_shai_xuan_but_2.png",
      name = "tag_selected0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 25.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42.5, h = 49},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_fragment_selected",
      res = "UI/alpha/1080P/package/icon_fragment.png",
      name = "icon_fragment_seclected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 46.5)
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
      name = "label_tag0",
      z = 1,
      parent = "tag0",
      text = T("\229\133\168\233\131\168"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(24.5, 27.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_fragment_selected",
      z = 0,
      parent = "btn_fragment_selected",
      text = T("\231\162\142 \231\137\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1.30000007},
      flip = "",
      opacity = 255,
      fix_wh = {w = 256.750013825, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_detail",
      res = "UI/alpha/1080P/package/seg_normal.png",
      name = "deco_mid1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137, 310)
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
      name = "Label_1799",
      z = 0,
      parent = "fox_tip",
      text = T("\229\136\171\231\156\139\229\149\166\233\157\147\228\187\148\239\188\140\232\191\153\233\135\140\231\169\186\231\169\186\229\166\130\228\185\159\239\188\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(208.5, 30.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(80, 77)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_stone_selected",
      z = 3,
      parent = "btn_stone",
      res = "UI/alpha/1080P/common/battle_prepare_lift_but_4.png",
      capInsets = CCRectMake(0, 0, 0, 0)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-6.75, 36.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -37.5, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_stone",
      res = "UI/alpha/1080P/package/icon_soul_unavailable.png",
      name = "icon_stone_unseclected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 44.25)
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
      name = "label_stone",
      z = 0,
      parent = "btn_stone",
      text = T("\231\129\181\233\173\130\231\159\179"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(32.25, 19.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(249, 163.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_main_attr",
      z = 0,
      parent = "bg_detail",
      res = "UI/alpha/1080P/package/bg_attr.png",
      capInsets = CCRectMake(3.5, 0.5, 1.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(137, 309)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -43.5, h = 43.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_equipment_selected",
      res = "UI/alpha/1080P/hero/icon_skin.png",
      name = "icon_equipment_seclected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_equipment_selected",
      z = 0,
      parent = "btn_equipment_selected",
      text = T("\232\163\133 \229\164\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 19.5)
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
      name = "btn_use",
      z = 0,
      parent = "bg_detail",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(197, 38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -37.5, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_stone_selected",
      res = "UI/alpha/1080P/package/icon_soul.png",
      name = "icon_stone_seclected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(67, 57, 52),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_stone_selected",
      z = 0,
      parent = "btn_stone_selected",
      text = T("\231\129\181\233\173\130\231\159\179"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(40, 19.5)
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
      name = "btn_soldout",
      z = 0,
      parent = "bg_detail",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76.5, 37)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 121.5, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_detail",
      res = "UI/alpha/1080P/package/bg_number.png",
      name = "bg_soldout",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.5, 74)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(61, 48, 36),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_name",
      z = 1,
      parent = "bg_detail",
      text = T("\233\129\147\229\133\183\229\144\141\231\167\176\229\177\133\228\184\173\229\142\159\229\136\153"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137.5, 352)
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
      name = "btn_info",
      z = 0,
      parent = "bg_detail",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(76.5, 37)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(247.5, 203)
    },
    t = "Layer",
    base = {
      parent = "bg_main_attr",
      name = "layer_attr",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.5, -46.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.78, x = 0.78},
      flip = "",
      opacity = 255,
      fix_wh = {w = 72.93, h = 72.93},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_main_attr",
      res = "UI/alpha/1080P/package/1st.jpg",
      name = "icon_item",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124, 268.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1.1},
      flip = "y",
      opacity = 255,
      fix_wh = {w = 217.25, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_detail",
      res = "UI/alpha/1080P/package/seg_normal.png",
      name = "deco_mid2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(137, 92.5)
    }
  },
  {
    config = {
      rotation = 180,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 263, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_main_attr",
      res = "UI/alpha/1080P/package/new/equip_name_bg.png",
      name = "bg_item_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124.5, 206)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(240, 25)
    },
    t = "Layer",
    base = {
      parent = "bg_main_attr",
      name = "amount",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4.5, 166)
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
      name = "Label_51",
      z = 0,
      parent = "btn_use",
      text = T("\228\189\191\231\148\168"),
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
      name = "Label_50",
      z = 0,
      parent = "btn_soldout",
      text = T("\229\135\186\229\148\174"),
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_soldout",
      res = "UI/alpha/1080P/icon/gold.png",
      name = "icon_gold",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.25, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(195, 117, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_money",
      z = 0,
      parent = "bg_soldout",
      text = "1234567",
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(43.25, 12.5)
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
      name = "label_info",
      z = 0,
      parent = "btn_info",
      text = T("\232\175\166\230\131\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 19.5)
    }
  }
}

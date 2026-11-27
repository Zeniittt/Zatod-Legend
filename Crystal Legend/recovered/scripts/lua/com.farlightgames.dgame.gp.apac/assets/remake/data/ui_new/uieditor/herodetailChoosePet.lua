ed.uieditor = ed.uieditor or {}
ed.uieditor.herodetailChoosePet = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(872, 469)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(9.5, 10, 10, 201.5),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(44.5, 18)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40.5, h = 41.25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(866, 463.5)
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
      name = "ImageView_902",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28.5)
    }
  },
  {
    config = {
      rotation = 90,
      fix_scale = {y = 1, x = 7.19999361},
      flip = "",
      opacity = 255,
      fix_wh = {w = 457.199594235, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_border_line_2.png",
      name = "line3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(338.5, 465.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(512, 405)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(348, 54.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(508, 34.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_tab",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_add_pet_tag_bg.png",
      capInsets = CCRectMake(25, 15, 16, 7)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(350.5, 32)
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
      name = "Panel_433",
      z = 0
    },
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
      fix_wh = {w = 397.5, h = 91},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/pet/pet_list_empty_bg.png",
      name = "no_egg_bg_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(635, 261.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_tab",
      res = "UI/alpha/1080P/pet/pet_room_tag_chosen_2.png",
      name = "btn_tab_selected",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55.5, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(125, 33)
    },
    t = "Layer",
    base = {
      parent = "bg_tab",
      name = "tab1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(4.5, -0.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(125, 33)
    },
    t = "Layer",
    base = {
      parent = "bg_tab",
      name = "tab2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(129, 0.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(125, 33)
    },
    t = "Layer",
    base = {
      parent = "bg_tab",
      name = "tab3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(254, 0.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(125, 33)
    },
    t = "Layer",
    base = {
      parent = "bg_tab",
      name = "tab4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(379, 0.25)
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
      parent = "Panel_433",
      res = "UI/alpha/1080P/common/frame/hero_icon_bg.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.5, 408.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_433",
      res = "UI/alpha/1080P/pet/pet_tag_gold.png",
      name = "tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133.5, 427.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.1, h = 40.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_433",
      res = "UI/alpha/1080P/herolist/icon_int.png",
      name = "type",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(134.5, 384)
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
      name = "Label_7089",
      z = 0,
      parent = "btn_tab_selected",
      text = T("\229\133\168\233\131\168"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(55, 16.5)
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
      parent = "Panel_433",
      text = T("\229\147\136\229\163\171\229\165\135"),
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(163.5, 428.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(45, 255, 50),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "level",
      z = 0,
      parent = "Panel_433",
      text = "lv.15",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(228.5, 429)
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
      visible = true
    },
    t = "Label",
    base = {
      name = "no_egg_label",
      z = 0,
      parent = "no_egg_bg_Copy0",
      text = T("\232\175\165\229\136\134\231\177\187\228\184\139\232\191\152\230\178\161\230\156\137\228\191\161\228\189\191\229\147\166"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(144, 144, 144),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "tab_name1",
      z = 0,
      parent = "tab1",
      text = T("\229\133\168\233\131\168"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 206.5, h = 3.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_433",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_add_pet_border_line_1.png",
      name = "line1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210.5, 406)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.199993928, h = 154.399990736},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "no_egg_bg_Copy0",
      res = "UI/alpha/1080P/pet/pet_list_empty.png",
      name = "no_egg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(48.75, 52)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 95.1999864, h = 21.6999969},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_433",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_agi_bg.png",
      name = "bg_agi",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(271, 347)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(144, 144, 144),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "tab_name2",
      z = 0,
      parent = "tab2",
      text = T("\230\169\153\232\137\178"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 95.1999864, h = 21.6999969},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_433",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_int_bg.png",
      name = "bg_int",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(169, 347)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 95.1999864, h = 21.6999969},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_433",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_str_bg.png",
      name = "bg_str",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(65.5, 347)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(144, 144, 144),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "tab_name3",
      z = 0,
      parent = "tab3",
      text = T("\231\180\171\232\137\178"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 24)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_attr1",
      z = 0,
      parent = "Panel_433",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_add_pet_bg.png",
      capInsets = CCRectMake(20, 7.5, 5, 9.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17, 317)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 24)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_attr2",
      z = 0,
      parent = "Panel_433",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_add_pet_bg.png",
      capInsets = CCRectMake(20, 7.5, 5, 9.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17, 291.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(144, 144, 144),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "tab_name4",
      z = 0,
      parent = "tab4",
      text = T("\232\147\157\232\137\178"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(300, 24)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_attr3",
      z = 0,
      parent = "Panel_433",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_add_pet_bg.png",
      capInsets = CCRectMake(20, 7.5, 5, 9.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17, 266.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 62.999991, h = 62.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_433",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon_skill1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 213)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 62.999991, h = 62.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_433",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon_skill2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47, 122.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 279.5, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_433",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_border_line_1.png",
      name = "line2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168.5, 63.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_433",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_ok",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168, 32)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 84.5)
    },
    t = "Layer",
    base = {
      parent = "Panel_433",
      name = "skill_desc_2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(78.5, 69.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 84)
    },
    t = "Layer",
    base = {
      parent = "Panel_433",
      name = "skill_desc_1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(78.5, 159.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 300, h = 0.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_433",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_add_pet_border_line_2.png",
      name = "ImageView_7732",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(22, 157)
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
      name = "label_agi",
      z = 0,
      parent = "bg_agi",
      text = T("\230\149\143\230\141\183 2.3%"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, 15.5)
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
      name = "label_int",
      z = 0,
      parent = "bg_int",
      text = T("\230\153\186\229\138\155 2.3%"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, 15.5)
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
      name = "label_str",
      z = 0,
      parent = "bg_str",
      text = T("\229\138\155\233\135\143 2.3%"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(68, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name_attr1",
      z = 0,
      parent = "bg_attr1",
      text = T("\229\145\189\228\184\173\231\173\137\231\186\167"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(25, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "value_attr1",
      z = 0,
      parent = "bg_attr1",
      text = "123456",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(290, 12)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name_attr2",
      z = 0,
      parent = "bg_attr2",
      text = T("\229\145\189\228\184\173\231\173\137\231\186\167"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(25, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "value_attr2",
      z = 0,
      parent = "bg_attr2",
      text = "123456",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(290, 12)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name_attr3",
      z = 0,
      parent = "bg_attr3",
      text = T("\229\145\189\228\184\173\231\173\137\231\186\167"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(25, 12.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "value_attr3",
      z = 0,
      parent = "bg_attr3",
      text = "123456",
      size = 14
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(290, 12)
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
      name = "Label_5859",
      z = 0,
      parent = "btn_ok",
      text = T("\233\162\134 \229\133\187"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.75, 22.5)
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
      name = "desc2",
      z = 0,
      parent = "skill_desc_2",
      text = "",
      size = 14
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(6.5, 67)
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
      name = "desc1",
      z = 0,
      parent = "skill_desc_1",
      text = "",
      size = 14
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(6.5, 67)
    }
  }
}

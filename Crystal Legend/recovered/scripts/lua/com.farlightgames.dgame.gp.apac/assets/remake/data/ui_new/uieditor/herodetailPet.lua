ed.uieditor = ed.uieditor or {}
ed.uieditor.herodetailPet = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {name = "layer_pet", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(423, 460.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_skill_info",
      z = 0,
      parent = "layer_pet",
      res = "UI/alpha/1080P/hero/hero_info_bg_0.png",
      capInsets = CCRectMake(18, 150, 18, 160)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(213, 3.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(242.5, 32.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_title_feature",
      z = 1,
      parent = "bg_skill_info",
      res = "UI/alpha/1080P/skill/new/skill_button_bg.png",
      capInsets = CCRectMake(30, 10, 150, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212.5, 444.25)
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
      name = "feature",
      z = 0,
      parent = "bg_title_feature",
      text = T("\231\137\185\229\190\129"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.25, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(242.5, 32.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "skill_btn_bg",
      z = 1,
      parent = "bg_skill_info",
      res = "UI/alpha/1080P/skill/new/skill_button_bg.png",
      capInsets = CCRectMake(105, 10, 105, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(212.5, 311.75)
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
      parent = "layer_pet",
      name = "layer_left",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-432, -224.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(422, 96)
    },
    t = "Layer",
    base = {
      parent = "bg_skill_info",
      name = "bg_skill_ranks",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(2, 202.75)
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
      name = "skill_name",
      z = 0,
      parent = "skill_btn_bg",
      text = T("\230\138\128\232\131\189"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.25, 18.25)
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
      parent = "bg_skill_info",
      name = "layer_pet_right",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(211.5, 230.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "layer_pet",
      name = "layer_unpet",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-431.5, -224)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(421.5, 242)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_8579",
      z = 0,
      parent = "bg_skill_info",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_skill_bg.png",
      capInsets = CCRectMake(100, 80, 221.5, 82)
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(0, 312.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 398.5, h = 397.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_left",
      res = "UI/alpha/1080P/hero/hero_bg_tattoos_2.png",
      name = "image__bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(220, 257.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 259.5, h = 63.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill_ranks",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_collar_3.png",
      name = "bg_skill",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(208.5, 48.5)
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
      parent = "layer_left",
      name = "layer_pet_left",
      z = 1
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
      fix_wh = {w = 33, h = 39.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_pet",
      res = "UI/alpha/1080P/hero/hero_bg_frame_1.png",
      name = "ImageView_469",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(1.5, 213.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 78,
      visible = true,
      scaleSize = CCSizeMake(421, 29)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_feature1",
      z = 0,
      parent = "layer_pet_right",
      res = "UI/alpha/1080P/skill/new/skill_info_bg3.png",
      capInsets = CCRectMake(20, 10, 5, 9.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-210, 184)
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
      parent = "image__bg",
      name = "pet_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(191.75, 157.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 188.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_collar_1.png",
      name = "ImageView_6792",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(285.75, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 188.5, h = 73.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_collar_1.png",
      name = "ImageView_6792_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-22.75, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(421, 29)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_feature2",
      z = 0,
      parent = "layer_pet_right",
      res = "UI/alpha/1080P/skill/new/skill_info_bg3.png",
      capInsets = CCRectMake(20, 10, 5, 9.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-210, 155)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.5, h = 76},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_collar_2.png",
      name = "ImageView_6794",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-47.75, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125.199992488, h = 102.399993856},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_skill",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_1.png",
      name = "pet_skill1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(79.25, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 75,
      visible = true,
      scaleSize = CCSizeMake(421, 39)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_feature3",
      z = 0,
      parent = "layer_pet_right",
      res = "UI/alpha/1080P/skill/new/skill_info_bg3.png",
      capInsets = CCRectMake(20, 10, 5, 9.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-210, 119)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 125.199992488, h = 102.399993856},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "bg_skill",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_1.png",
      name = "pet_skill2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(186.75, 31.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 95)
    },
    t = "Layer",
    base = {
      parent = "layer_pet_right",
      name = "skill_simple_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-199.5, -159.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 239.5, h = 218},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_unpet",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_add_pet_2.png",
      name = "ImageView_6961",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(220, 257.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(400, 95)
    },
    t = "Layer",
    base = {
      parent = "layer_pet_right",
      name = "skill_detail_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-199.5, -159.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 345, h = 228.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_pet_left",
      res = "UI/alpha/1080P/hero/hero_bg_mid_2.png",
      name = "image_bg_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(217.5, 341)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47.625, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_pet_right",
      res = "UI/alpha/1080P/dungeon/dungeon_info_button_on.png",
      name = "bg_switch_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174.5, -39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39, h = 45},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_pet_left",
      res = "UI/alpha/1080P/herolist/icon_str.png",
      name = "icon_attr_type",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39.5, 191)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 311.5, h = 75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_unpet",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_noting_1.png",
      name = "ImageView_6966",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(641.5, 382)
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
      name = "type_desc",
      z = 0,
      parent = "layer_pet_right",
      text = T("\231\174\128\232\166\129\230\143\143\232\191\176"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.5, -39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 136, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_pet_left",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_agi_bg.png",
      name = "bg_agi",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(359, 154)
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
      name = "name_feature1",
      z = 0,
      parent = "bg_feature1",
      text = T("\229\164\169\232\181\139\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_feature1",
      res = "UI/alpha/1080P/skill/new/skill_rankup_point.png",
      name = "point1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 6.29999971},
      flip = "",
      opacity = 255,
      fix_wh = {w = 400.049981585, h = 1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_pet_right",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_border_line_2.png",
      name = "ImageView_6809",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -54)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 136, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_pet_left",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_int_bg.png",
      name = "bg_int",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(219.5, 152)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56.5, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_feature1",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_talent_bg.png",
      name = "talent1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(124, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pet_skill1",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_2.png",
      name = "selected_skill1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 64)
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
      parent = "pet_skill1",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon_skill1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 72)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56.5, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_feature1",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_talent_bg.png",
      name = "talent2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180, 14)
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
      name = "label_level_skill1",
      z = 1,
      parent = "pet_skill1",
      text = "Lv.1",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 172, h = 162.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_unpet",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_noting_2.png",
      name = "ImageView_6968",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(641.5, 100)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(423, 47)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_6811",
      z = 0,
      parent = "layer_pet_right",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_skill_levelup_bg.png",
      capInsets = CCRectMake(50, 15, 11, 17)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-210, -195)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 136, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_pet_left",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_str_bg.png",
      name = "bg_str",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.5, 152)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56.5, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_feature1",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_talent_bg.png",
      name = "talent3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(235.5, 14)
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
      name = "name_feature2",
      z = 0,
      parent = "bg_feature2",
      text = T("\229\164\150\229\189\162\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pet_skill2",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_2.png",
      name = "selected_skill2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 64)
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
      parent = "pet_skill2",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon_skill2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 72)
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
      visible = false
    },
    t = "Label",
    base = {
      name = "Label_7265",
      z = 0,
      parent = "bg_feature1",
      text = T("\230\151\160"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(125, 14)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_feature2",
      res = "UI/alpha/1080P/skill/new/skill_rankup_point.png",
      name = "point2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11, 14.5)
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
      name = "label_level_skill2",
      z = 1,
      parent = "pet_skill2",
      text = "Lv.1",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 223, 127),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name_skill",
      z = 0,
      parent = "layer_pet_right",
      text = T("\228\186\161\231\129\181\229\143\172\229\148\164"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-199.5, -39.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 180,
      visible = true,
      scaleSize = CCSizeMake(424, 24.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_attr2",
      z = 0,
      parent = "layer_pet_left",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_add_pet_bg.png",
      capInsets = CCRectMake(20, 7.5, 5, 9.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8.5, 95.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56.5, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_feature1",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_talent_bg.png",
      name = "talent4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(290.5, 14)
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
      name = "name_feature2_Copy0",
      z = 0,
      parent = "bg_feature2",
      text = T("\232\186\171\233\149\191\239\188\154123\231\177\179"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(116.5, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 56.5, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_feature1",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_talent_bg.png",
      name = "talent5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(346, 14)
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
      name = "name_feature2_Copy1",
      z = 0,
      parent = "bg_feature2",
      text = T("\228\189\147\229\158\139\239\188\1541.5"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(223, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(431.5, 82.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_find_master",
      z = 2,
      parent = "layer_pet_right",
      res = "UI/alpha/1080P/pet/pet_room_select_hero.png",
      capInsets = CCRectMake(100, 15, 231.5, 52.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-216, 118)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 80,
      visible = true,
      scaleSize = CCSizeMake(424, 24.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_attr3",
      z = 0,
      parent = "layer_pet_left",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_add_pet_bg.png",
      capInsets = CCRectMake(20, 7.5, 5, 9.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8.5, 69)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(191, 115, 45),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "name_feature2_Copy2",
      z = 0,
      parent = "bg_feature2",
      text = T("\228\189\147\229\158\139\239\188\1541.5"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(292, 14.5)
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
      name = "name_feature3",
      z = 0,
      parent = "bg_feature3",
      text = T("\228\184\187\228\186\186\239\188\154"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(20, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 213, h = 38},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg_name",
      res = "UI/alpha/1080P/hero/rank/hero_rank_1.png",
      name = "frame_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174, 202.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 11, h = 11},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_feature3",
      res = "UI/alpha/1080P/skill/new/skill_rankup_point.png",
      name = "point3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 253.5, h = 31},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_pet_right",
      res = "UI/alpha/1080P/skill/new/skill_max.png",
      name = "pet_max_skill",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -195)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 80,
      visible = true,
      scaleSize = CCSizeMake(424, 24.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_attr1",
      z = 0,
      parent = "layer_pet_left",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_add_pet_bg.png",
      capInsets = CCRectMake(20, 7.5, 5, 9.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8.5, 121)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_feature3",
      res = "UI/alpha/1080P/common/frame/hero_icon_bg.png",
      name = "icon_master",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(131.5, 19.5)
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
      name = "name_master",
      z = 0,
      parent = "bg_feature3",
      text = T("\232\139\177\233\155\132\229\144\141\229\173\151"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(154.5, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(424, 47)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_eat",
      z = 0,
      parent = "layer_pet_left",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_enhance_pet_bg.png",
      capInsets = CCRectMake(75, 16.5, 11, 15)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(8.5, 32.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 119.5, h = 123.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_6961",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_add_pet_1.png",
      name = "ImageView_6964",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.75, 99.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_feature3",
      res = "UI/alpha/1080P/hero/hero_info_detail_bg.png",
      name = "btn_attr_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(339, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34, h = 34},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_feature3",
      res = "UI/alpha/1080P/hero/hero_info_detail_bg.png",
      name = "btn_quit_master",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(392.5, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 253.5, h = 31},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_pet_left",
      res = "UI/alpha/1080P/skill/new/skill_max.png",
      name = "pet_max_level",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(215, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 249, 196),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_6965",
      z = 0,
      parent = "ImageView_6961",
      text = T("\231\130\185\229\135\187\233\162\134\229\133\187\228\191\161\228\189\191"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.75, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 326, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_pet_left",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_name_bg.png",
      name = "ImageView_285",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(219.5, 190.5)
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
      color = ccc3(248, 223, 134),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_talent1",
      z = 0,
      parent = "talent1",
      text = T("\229\191\160\232\175\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.25, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(248, 223, 134),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_talent2",
      z = 0,
      parent = "talent2",
      text = T("\229\191\160\232\175\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.25, 17.25)
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
      name = "Label_6967",
      z = 0,
      parent = "ImageView_6966",
      text = T("\229\176\154\230\156\170\233\128\137\230\139\169\228\191\161\228\189\191"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(155.75, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.4000001, x = 1.4000001},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30.8000022, h = 30.10000215},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_switch_btn",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_attr_details.png",
      name = "icon_switch",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(15.75, 15)
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
      color = ccc3(248, 223, 134),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_talent3",
      z = 0,
      parent = "talent3",
      text = T("\229\191\160\232\175\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.25, 17.25)
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
      name = "pet_name",
      z = 0,
      parent = "frame_name_bg",
      text = T("\232\136\185\233\149\191"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.25, x = 1.25},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.5, h = 42.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "frame_name_bg",
      res = "UI/alpha/1080P/pet/pet_tag_gold.png",
      name = "icon_pet_color",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11, 19)
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
      color = ccc3(248, 223, 134),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_talent4",
      z = 0,
      parent = "talent4",
      text = T("\229\191\160\232\175\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.25, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(248, 223, 134),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_talent5",
      z = 0,
      parent = "talent5",
      text = T("\229\191\160\232\175\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(28.25, 17.25)
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
      name = "Label_6967_Copy0",
      z = 0,
      parent = "ImageView_6968",
      text = T("\229\176\154\230\156\170\233\128\137\230\139\169\228\191\161\228\189\191"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(86, 75.75)
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
      position = ccp(25, 12.75)
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
      position = ccp(409, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_6811",
      res = "UI/alpha/1080P/skill/skill_line_center.png",
      name = "skill_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210, 50)
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
      position = ccp(25, 12.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_attr_detail",
      res = "UI/alpha/1080P/hero/hero_info_detail.png",
      name = "ImageView_6336",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 17)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.199995128, h = 33.599997984},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_6811",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_train",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(366, 23.5)
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
      position = ccp(409, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(95, 20)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_cost1",
      z = 0,
      parent = "ImageView_6811",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_cost_bg.png",
      capInsets = CCRectMake(10.5, 6.5, 10.5, 7)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(123.5, 24)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_quit_master",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_remove.png",
      name = "ImageView_6336",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17, 17)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(95, 20)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_cost2",
      z = 0,
      parent = "ImageView_6811",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_cost_bg.png",
      capInsets = CCRectMake(10.5, 6.5, 10.5, 7)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(260.5, 24)
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
      position = ccp(25, 12.75)
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
      position = ccp(409, 12.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.5, h = 25.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_find_master",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/dark_addteam_addicon.png",
      name = "ImageView_7048",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(111, 41.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(95, 20)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_food_amount1",
      z = 0,
      parent = "bg_eat",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_cost_bg.png",
      capInsets = CCRectMake(15, 6.5, 1.5, 6.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(81.5, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(417.5, 40)
    },
    t = "Layer",
    base = {
      parent = "btn_find_master",
      name = "Panel_7499",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(6.5, 22.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 81.199995128, h = 33.599997984},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_eat",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_eat",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(368.5, 22.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(95, 20)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_food_amount2",
      z = 0,
      parent = "bg_eat",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_cost_bg.png",
      capInsets = CCRectMake(15, 6.5, 1.5, 6.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(219.5, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(242, 221, 191),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_pet_max_skill",
      z = 0,
      parent = "pet_max_skill",
      text = T("\229\183\178\232\190\190\229\136\176\230\156\128\229\164\167\231\173\137\231\186\167"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(126.75, 18)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(242, 221, 191),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_pet_max_level",
      z = 0,
      parent = "pet_max_level",
      text = T("\229\183\178\232\190\190\229\136\176\230\156\128\229\164\167\231\173\137\231\186\167"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(126.75, 18)
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
      name = "pet_level",
      z = 0,
      parent = "ImageView_285",
      text = "+1",
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(163, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 110, h = 2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_line",
      res = "UI/alpha/1080P/skill/skill_line_left.png",
      name = "skill_line_left",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(0, 4.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110, h = 2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_line",
      res = "UI/alpha/1080P/skill/skill_line_left.png",
      name = "skill_line_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(50, 4.75)
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
      name = "Label_58591",
      z = 0,
      parent = "btn_train",
      text = T("\232\174\173 \231\187\131"),
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
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.5, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_cost1",
      res = "UI/alpha/1080P/icon/highsoul_big.jpg",
      name = "icon_cost1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-16.5, 10)
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
      name = "label_cost1",
      z = 0,
      parent = "bg_cost1",
      text = "Text Label",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.5, h = 24.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_cost2",
      res = "UI/alpha/1080P/icon/highsoul_big.jpg",
      name = "icon_cost2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-16.5, 10)
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
      name = "label_cost2",
      z = 0,
      parent = "bg_cost2",
      text = "Text Label",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.5, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_food_amount1",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon_food1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-16.5, 10)
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
      name = "label_food_amount1",
      z = 0,
      parent = "bg_food_amount1",
      text = "1",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.5, 10)
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
      parent = "btn_eat",
      text = T("\229\150\130 \229\133\187"),
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
      color = ccc3(255, 248, 129),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_7049",
      z = 0,
      parent = "ImageView_7048",
      text = T("\231\130\185\229\135\187\228\184\186\228\191\161\228\189\191\229\175\187\230\137\190\228\184\187\228\186\186"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(121.75, 13.25)
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
      name = "label_food_amount2",
      z = 0,
      parent = "bg_food_amount2",
      text = "1",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.5, 10)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.5, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_food_amount2",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "icon_food2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-16, 10)
    }
  }
}

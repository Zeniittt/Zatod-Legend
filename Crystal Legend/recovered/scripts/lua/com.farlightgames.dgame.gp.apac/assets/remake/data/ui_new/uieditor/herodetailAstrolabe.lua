ed.uieditor = ed.uieditor or {}
ed.uieditor.herodetailAstrolabe = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      name = "layer_astrolabe",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      parent = "layer_astrolabe",
      name = "panel_main",
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
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(960, 540)
    },
    t = "Layer",
    base = {
      parent = "layer_astrolabe",
      name = "Panel_unlock",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(862, 469)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg",
      z = 0,
      parent = "panel_main",
      res = "UI/alpha/1080P/astrolabe/astrolabe_bg.png",
      capInsets = CCRectMake(10, 0, 850, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(466.5, 254.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 381.5, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_main",
      res = "UI/alpha/1080P/astrolabe/astrolabe_title_frame.png",
      name = "main_title",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(232, 463)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(245, 32.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "main_level",
      z = 2,
      parent = "panel_main",
      res = "UI/alpha/1080P/skill/new/skill_button_bg.png",
      capInsets = CCRectMake(100, 0, 16.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(619.5, 463.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(330, 350)
    },
    t = "Layer",
    base = {
      parent = "panel_main",
      name = "Panel_item",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(45.5, 90.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(515, 350)
    },
    t = "Layer",
    base = {
      parent = "panel_main",
      name = "Panel_attr",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(376, 91)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(200, 40)
    },
    t = "Layer",
    base = {
      parent = "panel_main",
      name = "Panel_count",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(690, 86.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(850, 58.5)
    },
    t = "Layer",
    base = {
      parent = "panel_main",
      name = "Panel_cost",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(42.5, 29)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 381.5, h = 37},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_unlock",
      res = "UI/alpha/1080P/astrolabe/astrolabe_title_frame.png",
      name = "ImageView_title",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(483, 463)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(862, 469)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_bg",
      z = 0,
      parent = "Panel_unlock",
      res = "UI/alpha/1080P/astrolabe/astrolabe_bg.png",
      capInsets = CCRectMake(10, 0, 850, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(466.5, 254.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 320.5, h = 349},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_unlock",
      res = "UI/alpha/1080P/astrolabe/astrolabe_main_1.png",
      name = "ImageView_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(470, 264)
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
      name = "Label_name",
      z = 0,
      parent = "main_title",
      text = T("\229\176\143\233\187\145\231\154\132\230\152\159\231\155\152"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(177.25, 20)
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
      name = "Label_level",
      z = 0,
      parent = "main_level",
      text = T("\231\173\137\231\186\167 123"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.5, 18.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 93.5, h = 27.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "main_level",
      res = "UI/alpha/1080P/skilltower/abyss_main_icon_03_tf.png",
      name = "ImageView_max",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(188, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 320.5, h = 349},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_item",
      res = "UI/alpha/1080P/astrolabe/astrolabe_main_1.png",
      name = "ImageView_204",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168, 173.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 222.5, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_item",
      res = "UI/alpha/1080P/astrolabe/astrolabe_gs_bg.png",
      name = "ImageView_206",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(168.5, 27)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(579.5, 312)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_209",
      z = 0,
      parent = "Panel_attr",
      res = "UI/alpha/1080P/astrolabe/astrolabe_attr_bg.png",
      capInsets = CCRectMake(94.5, 0, 22.5, 0.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(-68, 193.5)
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
      parent = "Panel_attr",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_str_bg.png",
      name = "ImageView_210",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(109, 329)
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
      parent = "Panel_attr",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_int_bg.png",
      name = "ImageView_212",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(249.5, 329)
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
      parent = "Panel_attr",
      res = "UI/alpha/1080P/pet/hero_pet/hero_pet_agi_bg.png",
      name = "ImageView_213",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(390, 329)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(450, 350)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "panel_clip_rect",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5.5, 67)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 83.5, h = 252},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_attr",
      res = "UI/alpha/1080P/astrolabe/astrolabe_main_2.png",
      name = "ImageView_223",
      z = 99
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-1.5, 170)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(45, 250)
    },
    t = "Layer",
    base = {
      parent = "Panel_attr",
      name = "Panel_attr_unlock",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(465, 46.5)
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
      parent = "main_level",
      res = "UI/alpha/1080P/hero/hero_info_detail_bg.png",
      name = "ImageView_what",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(265.5, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 325, h = 325},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_item",
      res = "UI/alpha/1080P/astrolabe/astrolabe_lock_bg_1.png",
      name = "ImageView_245",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(170, 176.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(201, 210, 223),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_add_times",
      z = 0,
      parent = "Panel_count",
      text = T("\228\187\138\230\151\165\229\137\169\228\189\153\229\141\160\230\152\159\230\172\161\230\149\176 4/10"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 38, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_count",
      res = "UI/alpha/1080P/astrolabe/astrolabe_add_times.png",
      name = "btn_add_times",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(173.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(839, 54.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_231",
      z = 0,
      parent = "Panel_cost",
      res = "UI/alpha/1080P/astrolabe/astrolabe_cost_bg_1.png",
      capInsets = CCRectMake(15, 0, 5.5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(423.5, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 96.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_cost",
      res = "UI/alpha/1080P/astrolabe/astrolabe_cost_bg_2.png",
      name = "ImageView_cost_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 96.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_cost",
      res = "UI/alpha/1080P/astrolabe/astrolabe_cost_bg_2.png",
      name = "ImageView_cost_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(262, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 96.5, h = 20},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "Panel_cost",
      res = "UI/alpha/1080P/astrolabe/astrolabe_cost_bg_2.png",
      name = "ImageView_cost_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(405.5, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(114, 43.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_save",
      z = 0,
      parent = "Panel_cost",
      res = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(50, 20, 24.5, 10.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(654, 30)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(114, 43.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_upgrade",
      z = 0,
      parent = "Panel_cost",
      res = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(50, 20, 24.5, 10.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(778, 30)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(114, 43.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_dalete",
      z = 0,
      parent = "Panel_cost",
      res = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(50, 20, 24.5, 10.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(530.5, 30)
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
      name = "Label_name_2",
      z = 0,
      parent = "ImageView_title",
      text = T("\229\176\143\233\187\145\231\154\132\230\152\159\231\155\152"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(177.25, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 325, h = 325},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_btn",
      res = "UI/alpha/1080P/astrolabe/astrolabe_lock_bg_2.png",
      name = "ImageView_159",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(162.25, 177.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 325, h = 325},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_btn",
      res = "UI/alpha/1080P/astrolabe/astrolabe_lock_bg_3.png",
      name = "ImageView_160",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(162.25, 176.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(237, 228, 253),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_163",
      z = 9,
      parent = "ImageView_btn",
      text = T("\231\130\185\229\135\187\232\167\163\233\148\129\230\152\159\231\155\152"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(162.25, 139)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 430, h = 329},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_bg",
      res = "UI/alpha/1080P/astrolabe/astrolabe_main_bg.png",
      name = "ImageView_168",
      z = 9
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(431, 234.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 325, h = 325},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_btn",
      res = "UI/alpha/1080P/astrolabe/astrolabe_lock_bg_1.png",
      name = "ImageView_161",
      z = 8
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(162.25, 177.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 225, 173),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_max",
      z = 0,
      parent = "ImageView_max",
      text = T("\229\183\178\230\187\161\231\186\167"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.25, 14.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 22},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_206",
      res = "UI/alpha/1080P/hero/hero_gs_2.png",
      name = "ImageView_207",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59.25, 16)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 430, h = 329},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_clip_rect",
      res = "UI/alpha/1080P/astrolabe/astrolabe_main_bg.png",
      name = "ImageView_201",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(185.5, 164.5)
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
      name = "Label_attr_1",
      z = 0,
      parent = "ImageView_210",
      text = "Text Label",
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
      name = "Label_attr_2",
      z = 0,
      parent = "ImageView_212",
      text = "Text Label",
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
      name = "Label_attr_3",
      z = 0,
      parent = "ImageView_213",
      text = "Text Label",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.5, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_223",
      res = "UI/alpha/1080P/astrolabe/astrolabe_quality_1.png",
      name = "astrolabe_quality_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27.75, 228.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.5, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_223",
      res = "UI/alpha/1080P/astrolabe/astrolabe_quality_2.png",
      name = "astrolabe_quality_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(51.25, 178)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.5, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_223",
      res = "UI/alpha/1080P/astrolabe/astrolabe_quality_3.png",
      name = "astrolabe_quality_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.75, 128.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.5, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_223",
      res = "UI/alpha/1080P/astrolabe/astrolabe_quality_4.png",
      name = "astrolabe_quality_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.25, 79)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.5, h = 50},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_223",
      res = "UI/alpha/1080P/astrolabe/astrolabe_quality_4.png",
      name = "astrolabe_quality_5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.25, 28.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_209",
      res = "astrolabe_attr_bg_icon.png",
      name = "ImageView_246",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(85, 289.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = -1},
      flip = "",
      opacity = 255,
      fix_wh = {w = -37.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_209",
      res = "astrolabe_attr_bg_icon.png",
      name = "ImageView_246_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(553, 290.5)
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
      parent = "ImageView_what",
      res = "UI/alpha/1080P/hero/hero_info_detail.png",
      name = "ImageView_241",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 246, 170),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_236",
      z = 0,
      parent = "btn_save",
      text = T("\228\191\157\229\173\152"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58, 23.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 246, 170),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_236",
      z = 0,
      parent = "btn_upgrade",
      text = T("\229\141\160\230\152\159"),
      size = 23
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58, 23.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(253, 246, 170),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_236",
      z = 0,
      parent = "btn_dalete",
      text = T("\228\184\141\228\191\157\229\173\152"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58, 23.25)
    }
  }
}

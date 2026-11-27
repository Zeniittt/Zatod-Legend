ed.uieditor = ed.uieditor or {}
ed.uieditor.herodetailNormal = {
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
      name = "layer_normal",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(463, 252)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 268, h = 464},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_normal",
      res = "UI/art/card_bg_big_2.jpg",
      name = "card",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-300, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 270, h = 466},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "card",
      res = "UI/alpha/1080P/summon/card_quality_white.png",
      name = "frame_card",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(135.5, 235)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(228, 460.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_attr",
      z = 0,
      parent = "layer_normal",
      res = "UI/alpha/1080P/hero/hero_info_bg_0.png",
      capInsets = CCRectMake(18, 150, 18, 160)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(311, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(369, 461)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_mid1",
      z = 0,
      parent = "layer_normal",
      res = "UI/alpha/1080P/hero/hero_bg_mid_1.png",
      capInsets = CCRectMake(12, 150, 12, 150)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14, 3)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(227, 48.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_level",
      z = 0,
      parent = "bg_attr",
      res = "UI/alpha/1080P/hero/hero_level_bg.png",
      capInsets = CCRectMake(150, 16, 5, 16)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114, 432.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.5, h = 18.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_attr",
      res = "UI/alpha/1080P/hero/hero_exp_icon.png",
      name = "icon_exp",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 389.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 458.5, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_normal",
      res = "UI/alpha/1080P/hero/hero_gs_up_bg.png",
      name = "bg_gsadd",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.5, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_attr",
      res = "UI/alpha/1080P/herolist/icon_stone.png",
      name = "icon_stone",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(21, 349.25)
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
      parent = "bg_level",
      res = "UI/alpha/1080P/herolist/icon_str.png",
      name = "icon_type",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(29, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 225, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_level",
      z = 0,
      parent = "bg_level",
      text = T("\231\173\137\231\186\1672"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(92.5, 24.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(227, 43.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_star",
      z = 0,
      parent = "bg_attr",
      res = "UI/alpha/1080P/hero/hero_star_bg_0.png",
      capInsets = CCRectMake(75, 14.5, 75, 19.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114, 299.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(226.5, 46)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_info",
      z = 0,
      parent = "bg_attr",
      res = "UI/alpha/1080P/hero/hero_info_bg.png",
      capInsets = CCRectMake(150, 15, 25, 15.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.5, 244.25)
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
      parent = "bg_mid1",
      res = "UI/alpha/1080P/hero/hero_bg_mid_2.png",
      name = "bg_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(184.5, 343.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(117, 13.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_bar_exp",
      z = 0,
      parent = "icon_exp",
      res = "UI/alpha/1080P/hero/hero_exp_progress_bg.png",
      capInsets = CCRectMake(3.5, 6, 3.5, 6)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(27.25, 8.75)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(63, 30.5),
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
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(30, 10.5, 29.5, 16),
      name = "btn_levelup",
      z = 0,
      parent = "icon_exp",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(181.25, 8.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(224, 149)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_attrlist",
      z = 0,
      parent = "bg_attr",
      res = "UI/alpha/1080P/hero/hero_info_bg_3.png",
      capInsets = CCRectMake(25, 50, 10, 50)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114, 117.75)
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
      parent = "bg_mid1",
      res = "UI/alpha/1080P/hero/hero_bg_frame_1.png",
      name = "sep1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-2, 442.5)
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
      parent = "bg_attr",
      name = "layer_collect",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(114, 0.25)
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
      parent = "bg_mid1",
      res = "UI/alpha/1080P/hero/hero_bg_frame_1.png",
      name = "sep2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(367.5, 442.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(117, 21)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_bar_stone",
      z = 0,
      parent = "icon_stone",
      res = "UI/alpha/1080P/hero/hero_soulstone_progress_bg.png",
      capInsets = CCRectMake(3.5, 7, 3.5, 7)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(26.75, 15.25)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(63, 30.5),
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
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(30, 10.5, 29.5, 16),
      name = "btn_evolve",
      z = 0,
      parent = "icon_stone",
      text = "",
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180.75, 14.75)
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
      name = "label_exp",
      z = 1,
      parent = "bg_bar_exp",
      text = "54%",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.5, 7.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(115.5, 11.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_15683",
      z = 0,
      parent = "bg_bar_exp",
      res = "UI/alpha/1080P/hero/hero_exp_progress.png",
      capInsets = CCRectMake(22.5, 4, 22.5, 1)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0.5, 6.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "bg_star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53.5, 21.75)
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
      parent = "bg_name",
      res = "UI/alpha/1080P/hero/rank/hero_rank_1.png",
      name = "frame_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172.5, 202.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_levelup",
      z = 0,
      parent = "btn_levelup",
      text = T("\229\141\135\231\186\167"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31.5, 16.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "bg_star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.5, 21.75)
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
      parent = "bg_name",
      res = "UI/alpha/1080P/hero/hero_bg_tattoos_2.png",
      name = "bg_equip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172.5, -41.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "bg_star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.5, 21.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 52.5, h = 52.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_name",
      res = "UI/alpha/1080P/pet/hero_pet_bottom.png",
      name = "bg_pet",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36, 202.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "bg_star4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(143.5, 21.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(226.5, 29)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_element_attr",
      z = 0,
      parent = "bg_attr",
      res = "UI/alpha/1080P/hero/hero_element_bg.png",
      capInsets = CCRectMake(100, 0, 5, 0.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.5, 207.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 27.5, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star",
      res = "UI/alpha/1080P/hero/hero_star_bg.png",
      name = "bg_star5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(173.5, 21.75)
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
      name = "label_info",
      z = 0,
      parent = "bg_info",
      text = T("\232\167\146\232\137\178\229\177\158\230\128\167"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.25, 23)
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
      z = 1,
      parent = "bg_bar_stone",
      text = "128/180",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57, 10.5)
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
      parent = "bg_info",
      res = "UI/alpha/1080P/hero/hero_info_detail_bg.png",
      name = "btn_info",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(199.75, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 63.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_info",
      res = "UI/alpha/1080P/dungeon/dungeon_info_button_off.png",
      name = "dungeon_switch_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(128.25, 23)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(246, 235, 215),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_evolve",
      z = 0,
      parent = "btn_evolve",
      text = T("\229\141\135\230\152\159"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31.5, 16.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.05, h = 13.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_evolve",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "evolve_redlight",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(57.5, 25.25)
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
      name = "attr1",
      z = 0,
      parent = "bg_attrlist",
      text = T("\230\156\128\229\164\167\231\148\159\229\145\189\229\128\188"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(21, 133.5)
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
      parent = "frame_name",
      text = T("\232\136\185\233\149\191+2"),
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
      name = "num_attr1",
      z = 0,
      parent = "bg_attrlist",
      text = "123456",
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(218, 133)
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
      name = "attr2",
      z = 0,
      parent = "bg_attrlist",
      text = T("\231\137\169\231\144\134\230\148\187\229\135\187\229\138\155"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(21, 104)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star1",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "equip1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.25, 345.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "equip2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.25, 260.25)
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
      name = "num_attr2",
      z = 0,
      parent = "bg_attrlist",
      text = "123456",
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(218, 103.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "equip3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(69.25, 175.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "equip4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(329.25, 345.25)
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
      name = "attr3",
      z = 0,
      parent = "bg_attrlist",
      text = T("\233\173\148\230\179\149\229\188\186\229\186\166"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(21, 74.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 99, h = 86.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_collect",
      res = "UI/alpha/1080P/hero/hero_bg_tattoos_1.png",
      name = "deco1",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(-14, 46.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star2",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "equip5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(329.25, 262.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 144,
      fix_wh = {w = 21, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_pet",
      res = "UI/alpha/1080P/pet/bg_item_level.png",
      name = "bg_pet_level",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.25, 9.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 71.99999568, h = 71.99999568},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/common/frame/gocha.png",
      name = "equip6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(329.25, 176.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44.999991, h = 44.999991},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_pet",
      res = "UI/alpha/1080P/common/frame/hero_icon_frame_7.png",
      name = "icon_pet",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26.25, 26.25)
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
      name = "num_attr3",
      z = 0,
      parent = "bg_attrlist",
      text = "123456",
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(218, 74.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 0.9},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 99, h = 86.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_collect",
      res = "UI/alpha/1080P/hero/hero_bg_tattoos_1.png",
      name = "deco2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(16, 45.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 383, h = 54.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/hero/hero_gs_bg.png",
      name = "bg_gs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(195.75, 61.75)
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
      name = "btn_up",
      z = 0,
      parent = "bg_equip",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(199.25, 111.25)
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
      name = "attr4",
      z = 0,
      parent = "bg_attrlist",
      text = T("\231\137\169\231\144\134\230\138\164\231\148\178"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(19.5, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 44, h = 40},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_collect",
      res = "UI/alpha/1080P/herolist/icon_uncollect.png",
      name = "icon_uncollect",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star3",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
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
      name = "num_attr4",
      z = 0,
      parent = "bg_attrlist",
      text = "123456",
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(216.5, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40, h = 36.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_collect",
      res = "UI/alpha/1080P/herolist/icon_collect.png",
      name = "icon_collect",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 20.5)
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
      name = "attr5",
      z = 0,
      parent = "bg_attrlist",
      text = T("\233\173\148\230\179\149\230\138\151\230\128\167"),
      size = 15
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(21, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star4",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "star4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
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
      name = "num_attr5",
      z = 0,
      parent = "bg_attrlist",
      text = "123456",
      size = 15
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(218, 15.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 30},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_star5",
      res = "UI/alpha/1080P/hero/hero_star_1.png",
      name = "star5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(13.75, 14.5)
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
      parent = "btn_info",
      res = "UI/alpha/1080P/hero/hero_info_detail.png",
      name = "icon_info",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "equip1",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame_equip1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 28.5, h = 28},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "dungeon_switch_bg",
      res = "UI/alpha/1080P/dungeon/dungeon_info_button_switch.png",
      name = "dungeon_switch",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49.25, 15)
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
      parent = "equip2",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame_equip2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
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
      parent = "equip3",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame_equip3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
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
      parent = "equip4",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame_equip4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 251, 165),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "pet_level",
      z = 0,
      parent = "bg_pet_level",
      text = "15",
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.5, 6)
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
      parent = "equip5",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame_equip5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
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
      parent = "equip6",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "frame_equip6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(45, 45)
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
      parent = "bg_gs",
      res = "UI/alpha/1080P/hero/hero_gs_2.png",
      name = "icon_gs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(114.5, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_gs",
      res = "UI/alpha/1080P/hero/number/hero_gs_9.png",
      name = "num_gs",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(225.5, 26.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(248, 224, 175),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_gs",
      z = 0,
      parent = "bg_gs",
      text = T("\230\136\152\229\138\155\239\188\154"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(127.5, 29.25)
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
      name = "label_up",
      z = 0,
      parent = "btn_up",
      text = T("\229\141\135 \233\152\182"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(46.25, 20)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 15},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_up",
      res = "UI/alpha/1080P/common/digit_red_tag_bg.png",
      name = "up_redlight",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.25, 31.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 233, 132),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_element_attr",
      z = 0,
      parent = "bg_element_attr",
      text = T("\229\133\131\231\180\160\229\177\158\230\128\167"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.25, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6, x = 0.6},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22.2, h = 23.1},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_element_attr",
      res = "UI/alpha/1080P/tag/Kael_fire.png",
      name = "img_element_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(200.25, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(169, 154, 144),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_30900",
      z = 0,
      parent = "icon_uncollect",
      text = T("\229\133\179\230\179\168"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(22, 23)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 226, h = 106.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_equip",
      res = "UI/alpha/1080P/legendequip/equip_background1.png",
      name = "bg_legend_equip",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(198.75, 372.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75, h = 75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_legend_equip",
      res = "UI/alpha/1080P/legendequip/equip_board.png",
      name = "legend_equip_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113, 57.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(108.5, 17)
    },
    t = "Scale9Sprite",
    base = {
      name = "legend_equip_bind_bg",
      z = 0,
      parent = "bg_legend_equip",
      res = "UI/alpha/1080P/legendequip/unlockinfo_board.png",
      capInsets = CCRectMake(10, 5.5, 10, 5.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113, 8.75)
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
      name = "legend_equip_bind_time",
      z = 0,
      parent = "legend_equip_bind_bg",
      text = T("48\229\176\143\230\151\182\229\144\142\229\143\175\232\167\163\231\187\145"),
      size = 13
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(54.25, 8.5)
    }
  }
}

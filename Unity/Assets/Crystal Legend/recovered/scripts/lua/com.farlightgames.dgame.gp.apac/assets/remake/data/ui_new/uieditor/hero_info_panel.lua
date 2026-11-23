ed.uieditor = ed.uieditor or {}
ed.uieditor.hero_info_panel = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 389.84375, h = 447.65625},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/herodetail-bg.png",
      name = "image_bg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(572.66, 239.84)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 344.53125, h = 447.65625},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/pet/pet_detail_bg.png",
      name = "image_bg2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(205.47, 239.84)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 57.8125, h = 58.59375},
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
      normal = "UI/alpha/1080P/common/herodetail-detail-close.png",
      name = "btn_close",
      z = 0,
      parent = "image_bg1",
      text = "",
      press = "UI/alpha/1080P/common/herodetail-detail-close-p.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(387.11, 416.8)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46.09375, h = 46.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg1",
      res = "UI/alpha/HVGA/icon_str.png",
      name = "image_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37.11, 211.33)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 153.125, h = 42.96875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg1",
      res = "UI/alpha/HVGA/herodetail_name_frame_1.png",
      name = "image_name_frame",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(139.45, 212.11)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(23.44, 117.19)
    },
    t = "Layer",
    base = {
      parent = "image_bg1",
      name = "node_star",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(20.7, 265.23)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(78.13, 156.25)
    },
    t = "Layer",
    base = {
      parent = "image_bg1",
      name = "node_fca",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(126.95, 249.61)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(140.63, 210.94)
    },
    t = "Layer",
    base = {
      parent = "image_bg1",
      name = "node_equip",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(227.73, 194.14)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(312.5, 39.06)
    },
    t = "Layer",
    base = {
      parent = "image_bg1",
      name = "node_info",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(15.23, 144.92)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 75.78125, h = 247.65625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg2",
      res = "UI/alpha/HVGA/pet/pet_detail_curtain_left.png",
      name = "image_curtain_left",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(47.27, 312.11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76.5625, h = 247.65625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg2",
      res = "UI/alpha/HVGA/pet/pet_detail_curtain_right.png",
      name = "image_curtain_right",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(295.7, 312.89)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(156.25, 156.25)
    },
    t = "Layer",
    base = {
      parent = "image_bg2",
      name = "node_pet",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(170.7, 249.61)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(312.5, 175.78)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_equip_bg",
      z = 0,
      parent = "image_bg2",
      res = "UI/alpha/HVGA/herodetail_skill_bg_1.png",
      capInsets = CCRectMake(23.44, 23.44, 0.78, 0.78)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172.27, 105.08)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 347.65625, h = 3.90625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg1",
      res = "UI/alpha/HVGA/herodetail_delimiter.png",
      name = "image_delimiter",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(191.8, 140.23)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(156.25, 39.06)
    },
    t = "Layer",
    base = {
      parent = "image_bg2",
      name = "node_heart",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(94.14, 352.73)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(73, 156, 6),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_pet_name",
      z = 2,
      parent = "image_bg2",
      text = T("\229\176\143\233\163\158\233\190\153"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(172.27, 416.02)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(156.25, 39.06)
    },
    t = "Layer",
    base = {
      parent = "image_bg2",
      name = "node_name_frame",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(169.14, 433.2)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(156.25, 156.25)
    },
    t = "Layer",
    base = {
      parent = "image_bg1",
      name = "node_hero_rect",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(58.98, 245.7)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(140.63, 140.63)
    },
    t = "Layer",
    base = {
      parent = "image_bg2",
      name = "node_pet_rect",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(103.52, 222.27)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(351.56, 79.69)
    },
    t = "Layer",
    base = {
      parent = "image_bg1",
      name = "pnl_tarot",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(18.36, 60.55)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(105.47, 50.78),
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
      normal = "UI/alpha/HVGA/stageselect_difficulty_button_normal.png",
      capInsets = CCRectMake(19.53, 21.88, 52.34, 21.09),
      name = "btn_rune",
      z = 0,
      parent = "image_bg1",
      text = "",
      press = "UI/alpha/HVGA/stageselect_difficulty_button_normal_pressed.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.14, 37.11)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(105.47, 50.78),
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
      normal = "UI/alpha/HVGA/stageselect_difficulty_button_normal.png",
      capInsets = CCRectMake(19.53, 21.88, 52.34, 21.09),
      name = "btn_tarot",
      z = 0,
      parent = "image_bg1",
      text = "",
      press = "UI/alpha/HVGA/stageselect_difficulty_button_normal_pressed.png",
      size = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(270.7, 37.11)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(351.56, 79.69)
    },
    t = "Layer",
    base = {
      parent = "image_bg1",
      name = "pnl_rune",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(18.36, 60.55)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.21875, h = 25.78125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_star",
      res = "UI/alpha/HVGA/herodetail_star_grey.png",
      name = "image_star_bg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.06, 16.41)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.21875, h = 25.78125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_star",
      res = "UI/alpha/HVGA/herodetail_star_grey.png",
      name = "image_star_bg2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.06, 39.06)
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
      name = "label_level_tip",
      z = 0,
      parent = "node_info",
      text = T("\231\173\137\231\186\167\239\188\154"),
      size = 22
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(64.06, 14.06)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.21875, h = 25.78125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_star",
      res = "UI/alpha/HVGA/herodetail_star_grey.png",
      name = "image_star_bg3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.06, 61.72)
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
      name = "label_gs_tip",
      z = 0,
      parent = "node_info",
      text = T("\230\136\152\230\150\151\229\138\155\239\188\154"),
      size = 22
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(214.06, 14.06)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.21875, h = 25.78125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_star",
      res = "UI/alpha/HVGA/herodetail_star_grey.png",
      name = "image_star_bg4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.06, 84.38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.21875, h = 25.78125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_star",
      res = "UI/alpha/HVGA/herodetail_star_grey.png",
      name = "image_star_bg5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(14.06, 107.03)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(146, 0, 4),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_level",
      z = 0,
      parent = "node_info",
      text = "100",
      size = 22
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(67.97, 14.06)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(146, 0, 4),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_gs",
      z = 0,
      parent = "node_info",
      text = "26333",
      size = 22
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(217.97, 14.06)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.09375, h = 21.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_heart",
      res = "UI/alpha/HVGA/pet/pet_heart_grey.png",
      name = "image_heart_bg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(8.59, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.09375, h = 21.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_heart",
      res = "UI/alpha/HVGA/pet/pet_heart_grey.png",
      name = "image_heart_bg2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42.97, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.09375, h = 21.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_heart",
      res = "UI/alpha/HVGA/pet/pet_heart_grey.png",
      name = "image_heart_bg3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.13, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.09375, h = 21.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_heart",
      res = "UI/alpha/HVGA/pet/pet_heart_grey.png",
      name = "image_heart_bg4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(113.28, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.09375, h = 21.09375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_heart",
      res = "UI/alpha/HVGA/pet/pet_heart_grey.png",
      name = "image_heart_bg5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148.44, 22.66)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(273.44, 148.44)
    },
    t = "Layer",
    base = {
      parent = "image_equip_bg",
      name = "node_pet_equip",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(19.53, 14.45)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(351.56, 79.69)
    },
    t = "Layer",
    base = {
      parent = "pnl_rune",
      name = "node_rune",
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
      name = "label_rune_lock_tip",
      z = 0,
      parent = "pnl_rune",
      text = T("\232\175\165\232\139\177\233\155\132\230\156\170\232\167\163\233\148\129\231\172\166\231\159\179"),
      size = 22
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(166.41, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(105.47, 50.78)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_rune_select",
      z = 0,
      parent = "btn_rune",
      res = "UI/alpha/HVGA/stageselect_difficulty_button_selected.png",
      capInsets = CCRectMake(19.53, 21.88, 52.34, 21.09)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.73, 25.39)
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
      name = "label_rune",
      z = 0,
      parent = "btn_rune",
      text = T("\231\172\166\231\159\179"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.73, 25.39)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(105.47, 50.78)
    },
    t = "Scale9Sprite",
    base = {
      name = "img_tarot_select",
      z = 0,
      parent = "btn_tarot",
      res = "UI/alpha/HVGA/stageselect_difficulty_button_selected.png",
      capInsets = CCRectMake(19.53, 21.88, 52.34, 21.09)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.73, 25.39)
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
      name = "Label_7415",
      z = 0,
      parent = "btn_tarot",
      text = T("\229\161\148\231\189\151"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(52.73, 25.39)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 241.40625, h = 55.46875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "pnl_tarot",
      res = "UI/alpha/HVGA/tarot_card/tag_bg.png",
      name = "img_tarot_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174.22, 39.84)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(351.56, 79.69)
    },
    t = "Layer",
    base = {
      parent = "pnl_rune",
      name = "node_magicstone",
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
      fix_wh = {w = 24.21875, h = 25.78125},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_star_bg1",
      res = "UI/alpha/1080P/common/detail_star.png.png",
      name = "image_star1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.11, 12.89)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.21875, h = 25.78125},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_star_bg2",
      res = "UI/alpha/1080P/common/detail_star.png.png",
      name = "image_star2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.11, 12.89)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.21875, h = 25.78125},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_star_bg3",
      res = "UI/alpha/1080P/common/detail_star.png.png",
      name = "image_star3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.11, 12.89)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.21875, h = 25.78125},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_star_bg4",
      res = "UI/alpha/1080P/common/detail_star.png.png",
      name = "image_star4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.11, 12.89)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.21875, h = 25.78125},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "image_star_bg5",
      res = "UI/alpha/1080P/common/detail_star.png.png",
      name = "image_star5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(12.11, 12.89)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.4375, h = 21.875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_heart_bg1",
      res = "UI/alpha/HVGA/pet/pet_heart.png",
      name = "image_heart1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.55, 10.55)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.4375, h = 21.875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_heart_bg2",
      res = "UI/alpha/HVGA/pet/pet_heart.png",
      name = "image_heart2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.55, 10.55)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.4375, h = 21.875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_heart_bg3",
      res = "UI/alpha/HVGA/pet/pet_heart.png",
      name = "image_heart3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.55, 10.55)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.4375, h = 21.875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_heart_bg4",
      res = "UI/alpha/HVGA/pet/pet_heart.png",
      name = "image_heart4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.55, 10.55)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 23.4375, h = 21.875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_heart_bg5",
      res = "UI/alpha/HVGA/pet/pet_heart.png",
      name = "image_heart5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(10.55, 10.55)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 73.4375, h = 74.21875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_rune",
      res = "UI/alpha/1080P/common/gocha.png",
      name = "image_sun_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(83.59, 40.63)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 73.4375, h = 74.21875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_rune",
      res = "UI/alpha/1080P/common/gocha.png",
      name = "image_moon_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(175, 40.63)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 73.4375, h = 74.21875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_rune",
      res = "UI/alpha/1080P/common/gocha.png.png",
      name = "image_star_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(267.19, 40.63)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.40625, h = 41.40625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_tarot_bg",
      res = "UI/alpha/HVGA/tarot_card/green.png",
      name = "img_tarot_active_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(44.92, 27.73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.40625, h = 41.40625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_tarot_bg",
      res = "UI/alpha/HVGA/tarot_card/green.png",
      name = "img_tarot_active_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(96.48, 27.73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.40625, h = 41.40625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_tarot_bg",
      res = "UI/alpha/HVGA/tarot_card/green.png",
      name = "img_tarot_active_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(148.05, 27.73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41.40625, h = 41.40625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_tarot_bg",
      res = "UI/alpha/HVGA/tarot_card/green.png",
      name = "img_tarot_active_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(199.61, 27.73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 240.625, h = 55.46875},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "node_magicstone",
      res = "UI/alpha/HVGA/MagicStone/MagicStone_EnterAndTags/MagicStone_Show_Bg.png",
      name = "img_magicstone_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174.22, 39.84)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.0625, h = 24.0625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_tarot_active_1",
      res = "UI/alpha/HVGA/tarot_card/tag_ball.png",
      name = "ImageView_7782",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.7, 20.7)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.0625, h = 24.0625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_tarot_active_2",
      res = "UI/alpha/HVGA/tarot_card/tag_ball.png",
      name = "ImageView_7782_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.7, 20.7)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.0625, h = 24.0625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_tarot_active_3",
      res = "UI/alpha/HVGA/tarot_card/tag_ball.png",
      name = "ImageView_7782_Copy1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.7, 20.7)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.35, x = 0.35},
      flip = "",
      opacity = 255,
      fix_wh = {w = 24.0625, h = 24.0625},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_tarot_active_4",
      res = "UI/alpha/HVGA/tarot_card/tag_ball.png",
      name = "ImageView_7782_Copy2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(20.7, 20.7)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_magicstone_bg",
      res = "UI/alpha/HVGA/MagicStone/MagicStone_EnterAndTags/MagicStone_Show_Blue.png",
      name = "img_magicstone_1",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(31.25, 27.73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_magicstone_bg",
      res = "UI/alpha/HVGA/MagicStone/MagicStone_EnterAndTags/MagicStone_Show_Orange.png",
      name = "img_magicstone_2",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66.41, 27.73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_magicstone_bg",
      res = "UI/alpha/HVGA/MagicStone/MagicStone_EnterAndTags/MagicStone_Show_Purple.png",
      name = "img_magicstone_3",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(102.34, 27.73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_magicstone_bg",
      res = "UI/alpha/HVGA/MagicStone/MagicStone_EnterAndTags/MagicStone_Show_Green.png",
      name = "img_magicstone_4",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(138.28, 27.73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_magicstone_bg",
      res = "UI/alpha/HVGA/MagicStone/MagicStone_EnterAndTags/MagicStone_Show_Green.png",
      name = "img_magicstone_5",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174.22, 27.73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 31.25, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_magicstone_bg",
      res = "UI/alpha/HVGA/MagicStone/MagicStone_EnterAndTags/MagicStone_Show_Green.png",
      name = "img_magicstone_6",
      z = 5
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210.16, 27.73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 211.71875, h = 33.59375},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_magicstone_bg",
      res = "UI/alpha/HVGA/MagicStone/MagicStone_EnterAndTags/MagicStone_Show_Item06.png",
      name = "img_magicstone_slots",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(14.84, 27.73)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 78.125, h = 78.125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_7782",
      res = "UI/alpha/HVGA/tarot_card/tarot_tag/tag_1.png",
      name = "img_tarot_tag_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.38, 34.38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 78.125, h = 78.125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_7782_Copy0",
      res = "UI/alpha/HVGA/tarot_card/tarot_tag/tag_1.png",
      name = "img_tarot_tag_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.38, 34.38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 78.125, h = 78.125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_7782_Copy1",
      res = "UI/alpha/HVGA/tarot_card/tarot_tag/tag_1.png",
      name = "img_tarot_tag_3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.38, 34.38)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 78.125, h = 78.125},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "ImageView_7782_Copy2",
      res = "UI/alpha/HVGA/tarot_card/tarot_tag/tag_1.png",
      name = "img_tarot_tag_4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.38, 34.38)
    }
  }
}

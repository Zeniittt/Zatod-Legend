ed.uieditor = ed.uieditor or {}
ed.uieditor.legend_equip_select_window = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(288, 462)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(96, 119, 96, 30),
      res = "UI/alpha/1080P/legendequip/chooseequip_board1.png",
      name = "image_bg_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(249, 255)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(495, 472)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(30, 130, 30, 130),
      res = "UI/alpha/1080P/common/com_new_2.png",
      name = "image_bg_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(635, 250.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(785, 465)
    },
    t = "Layer",
    base = {name = "click_area", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(99, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.4999999, x = 0.4999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 124.999975, h = 124.999975},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg_1",
      res = "UI/alpha/1080P/legendequip/to_jpg_x_alpha/le1.png",
      name = "image_equip_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66.5, 395.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg_1",
      name = "panel_equip_name",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(126.5, 418)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 98.5, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg_1",
      res = "UI/alpha/1080P/legendequip/onlyequip_board2.png",
      name = "image_only_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(173.5, 398)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(150, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg_1",
      name = "panel_star",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(126.5, 358.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(262.5, 123.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg_1",
      name = "panel_attr_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(13, 216)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "y",
      opacity = 255,
      fix_wh = {w = 197.5, h = 9.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg_1",
      res = "UI/alpha/1080P/common/battle_prepare_lins_2.png",
      name = "image_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(152.5, 215.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 262, h = 142},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg_1",
      res = "UI/alpha/1080P/legendequip/chooseequip_board2.png",
      name = "image_skill_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145, 135.5)
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
      parent = "image_bg_1",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_bind",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(144, 37)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 0,
      fix_wh = {w = 477.5, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg_2",
      res = "UI/alpha/1080P/legendequip/chooseequip_board4.png",
      name = "image_title_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(248, 444.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(180, 30)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_filter",
      z = 0,
      parent = "image_bg_2",
      res = "installer/login/unselected.png",
      capInsets = CCRectMake(15, 10, 15, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(382, 445)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(450, 382.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg_2",
      name = "panel_equip_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(25, 31)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 55.599996664, h = 55.599996664},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_skill_bg",
      res = "UI/alpha/1080P/legendequip/skill_frame.png",
      name = "image_skill_frame",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 108.5)
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
      name = "label_skill_name",
      z = 0,
      parent = "image_skill_bg",
      text = T("\229\175\146\233\156\156\229\134\178\229\135\187"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(69, 124.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_skill_bg",
      res = "UI/alpha/1080P/legendequip/chooseequip_board3.png",
      name = "image_rune_bg_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115.5, 94.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 85, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_skill_bg",
      res = "UI/alpha/1080P/legendequip/chooseequip_board3.png",
      name = "image_rune_bg_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(210.5, 94.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 65)
    },
    t = "Layer",
    base = {
      parent = "image_skill_bg",
      name = "panel_skill_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(6, 5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_bind",
      z = 0,
      parent = "btn_bind",
      text = T("\231\129\181\233\173\130\231\187\145\229\174\154"),
      size = 17
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
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_title_bg",
      text = T("\229\164\135\233\128\137\232\163\133\229\164\135"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(21.25, 21.5)
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
      name = "label_filter",
      z = 0,
      parent = "btn_filter",
      text = T("\229\148\175\228\184\128\232\163\133\229\164\135"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(90, 15)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14.5, h = 13},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_filter",
      res = "installer/login/down.png",
      name = "image_arrow",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(162.5, 15)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 108, 110),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_skill_lock",
      z = 0,
      parent = "image_skill_bg",
      text = T("3\230\152\159\232\167\163\233\148\129"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(203, 124.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.2, h = 25.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_rune_bg_1",
      res = "UI/alpha/1080P/legendequip/testicon1.png",
      name = "image_rune_icon_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(6.5, 10)
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
      name = "label_rune_name_1",
      z = 0,
      parent = "image_rune_bg_1",
      text = T("\229\134\176\229\135\140"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(22, 11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.9, x = 0.9},
      flip = "",
      opacity = 255,
      fix_wh = {w = 25.2, h = 25.2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_rune_bg_2",
      res = "UI/alpha/1080P/legendequip/testicon1.png",
      name = "image_rune_icon_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(6.5, 10)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(159, 154, 151),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_rune_name_2",
      z = 0,
      parent = "image_rune_bg_2",
      text = T("\229\188\186\229\140\150\229\134\178\229\135\187"),
      size = 14
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(22, 11)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 69, h = 19},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg_1",
      res = "UI/alpha/1080P/legendequip/left_time_bg.png",
      name = "image_bind_time_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 37.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 15.3999978, h = 17.84999745},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bind_time_bg",
      res = "UI/alpha/1080P/lottery/lottery_time_newyear.png",
      name = "ImageView_22028",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(8.5, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 92, 92),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_bind_time",
      z = 0,
      parent = "image_bind_time_bg",
      text = T("2\229\164\1692\229\176\143\230\151\182"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(42, 9.5)
    }
  }
}

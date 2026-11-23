ed.uieditor = ed.uieditor or {}
ed.uieditor.legend_equip_others_hero_window = {
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
      position = ccp(480, 270)
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
      fix_wh = {w = 227, h = 86.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg_1",
      res = "UI/alpha/1080P/legendequip/onlyequip_board.png",
      name = "image_only_tag",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(160, 398)
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(262, 196.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_skill_bg",
      z = 0,
      parent = "image_bg_1",
      res = "UI/alpha/1080P/legendequip/chooseequip_board2.png",
      capInsets = CCRectMake(87, 72.5, 87, 47)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(145, 111)
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
      position = ccp(34.5, 161.75)
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
      position = ccp(69, 179.25)
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
      position = ccp(115.5, 148.25)
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
      position = ccp(210.5, 148.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(250, 120)
    },
    t = "Layer",
    base = {
      parent = "image_skill_bg",
      name = "panel_skill_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(6, 4.25)
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
  }
}

ed.uieditor = ed.uieditor or {}
ed.uieditor.PetChooseMasterWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(859.5, 463)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(15, 15, 10, 10),
      res = "UI/alpha/1080P/pet/hero_pet_bg.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(477.5, 261)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      name = "ImageView_7230",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(334.25, 436.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/comm_line_b.png",
      name = "ImageView_7231",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(532.75, 436.5)
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
      name = "Label_7232",
      z = 0,
      parent = "bg",
      text = T("\233\128\137\230\139\169\232\139\177\233\155\132"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(435.25, 439)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(840, 300)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_item",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(9.75, 116)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(705.5, 34.5)
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
      position = ccp(81.25, 84.5)
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
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_mini.png",
      name = "btn_ok",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(438.75, 32)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 33)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_tab_selected",
      z = 1,
      parent = "bg_tab",
      res = "UI/alpha/1080P/pet/pet_room_tag_chosen_2.png",
      capInsets = CCRectMake(45, 11, 10, 11)
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1, 0.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 33)
    },
    t = "Layer",
    base = {
      parent = "bg_tab",
      name = "tab1",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1, 1.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 33)
    },
    t = "Layer",
    base = {
      parent = "bg_tab",
      name = "tab2",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(100.5, 1.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 33)
    },
    t = "Layer",
    base = {
      parent = "bg_tab",
      name = "tab3",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(202, 1.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 33)
    },
    t = "Layer",
    base = {
      parent = "bg_tab",
      name = "tab4",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(302, 1.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 33)
    },
    t = "Layer",
    base = {
      parent = "bg_tab",
      name = "tab5",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(402.5, 1.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 33)
    },
    t = "Layer",
    base = {
      parent = "bg_tab",
      name = "tab6",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(503, 1.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 33)
    },
    t = "Layer",
    base = {
      parent = "bg_tab",
      name = "tab7",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(603, 1.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "Label_5859",
      z = 0,
      parent = "btn_ok",
      text = T("\231\161\174\229\174\154"),
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
      name = "Label_7089",
      z = 0,
      parent = "btn_tab_selected",
      text = T("\229\133\168\233\131\168"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(49, 16)
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
      position = ccp(50.5, 16.5)
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
      text = T("\229\137\141\230\142\146"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 16.5)
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
      text = T("\228\184\173\230\142\146"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 16.5)
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
      text = T("\229\144\142\230\142\146"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 16.5)
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
      name = "tab_name5",
      z = 0,
      parent = "tab5",
      text = T("\229\138\155\233\135\143"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 16.5)
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
      name = "tab_name6",
      z = 0,
      parent = "tab6",
      text = T("\230\153\186\229\138\155"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 16.5)
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
      name = "tab_name7",
      z = 0,
      parent = "tab7",
      text = T("\230\149\143\230\141\183"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50.5, 16.5)
    }
  }
}
